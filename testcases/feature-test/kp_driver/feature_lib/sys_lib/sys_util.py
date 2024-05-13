#!/usr/bin/python3

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   Li Xiaodong
# @Contact   	:   lixiaodong67@huawei.com
# @Date      	:   2024-05-06 15:36:43
# @License   	:   Mulan PSL v2
# @Desc      	:   add lib for acc enviroment
#####################################

import time
import os
import re
import hashlib
import psutil

from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config import lava_global
from test_config.feature_config.hns_config import hns_config
from test_config.feature_config.sys_config import sys_config
from test_config.feature_config.sys_config.sys_config import ENV_TYPE


class SysUtil:
    """
    系统级公共函数库
    """

    def __init__(self):
        """
        根据eth1网口ip 判断环境类型：1 D06、2 ESL、3 FPGA
        """
        if lava_global.feature_global.server_ssh.send_command("ifconfig eth1 2>/dev/null | grep '192.168.100'"):
            self.RUNING_ENV_TYPE = 2
        elif lava_global.feature_global.server_ssh.send_command("ifconfig eth1 2>/dev/null | grep '192.168.200'"):
            self.RUNING_ENV_TYPE = 3
        else:
            self.RUNING_ENV_TYPE = 1

    def fn_kill_process(self, pro_name):
        """
        Description ：杀掉进程
        Examples ：fn_kill_process("iperf")
        :param pro_name:进程名称(必要参数）
        :return: 无返回结果
        """
        pro_status_dic = self.fn_get_process_status(pro_name)
        if len(pro_status_dic) == 0:
            msg_center.info("{} is not running".format(pro_name))
        # 杀掉进程
        for pro_pid in pro_status_dic:
            if "running" in pro_status_dic.get(pro_pid)[1]:
                msg_center.info("{} {} is going".format(pro_pid, pro_status_dic.get(pro_pid)[0]))
                lava_global.feature_global.server_ssh.send_command("kill {}".format(pro_pid))
        time.sleep(1)

    def fn_clean_tmp_file(self):
        """
        删除临时文件
        :return:
        """
        tmp_file_list = self.fn_get_files_list(sys_config.LAVA_JOB_LOG_PATH, sys_config.LAVA_JOB_LOG_PATH, 1)
        for i in tmp_file_list:
            if ".tmp" in i:
                os.remove(i)

    @staticmethod
    def fn_get_env_type():
        # 根据工程传递的文件包含的hostname，识别组网类型
        host_name = lava_global.feature_global.server_ssh.send_command("cat /home/ci-test-cases/host_name")
        env_type = ""
        for key in ENV_TYPE.keys():
            if key in host_name:
                env_type = ENV_TYPE.get(key)
                break
        # 本对端传入的是空值就是单机环境
        if env_type:
            env_type_cp = env_type + "_cp"
        else:
            env_type_cp = ""
        return env_type, env_type_cp

    def fn_restart_network(self):
        """
        根据不同类型的系统，用不同的命令进行网络重启
        :return: bool
        """
        os_name = self.fn_get_os_name()
        os_name = os_name.split(" ")[0].lower()
        cmd = hns_config.NETWORK_RESTART_CMD.get(os_name)
        result_reset = lava_global.feature_global.server_ssh.send_command(cmd)
        time.sleep(hns_config.NETWORK_RESTART_TIME)
        if result_reset == 0:
            msg_center.info("the network restart is succ")
            return True
        else:
            msg_center.error("the network restart is fail")
            return False

    def fn_nic_environment_check(self):
        """
        检查当前所有网口是否能ping通，如不通则执行一些恢复的操作
        """
        # 获取所有除网桥和未配置静态ip的口数量
        cmd = "ip a | grep BROADCAST|egrep -v 'virbr|NO-CARRIER'| wc -l"
        nic_num = int(lava_global.feature_global.server_ssh.send_command(cmd)) - 1
        # 获取所有测试口数量
        cmd = "ip r | grep '0.11' | wc -l"
        ip_r_num = int(lava_global.feature_global.server_ssh.send_command(cmd))
        cmd = "ip a | grep -w inet | grep '0.11' | awk '{{print $2}}'"
        ip_a_list = lava_global.feature_global.server_ssh.send_command(cmd).replace("/24", "").split("\n")
        # 两者不相等即有板载口或者标卡的口没有ip
        if nic_num != ip_r_num:
            # 有网口没有ip时，执行本对端执行重启网络服务的操作并up网口，本端网口重启网络服务后up起来会出现ip，若对端网口没有up下面检查连通性时会up
            # 延迟导包以解决导包失败的问题
            self.fn_restart_network()
            cmd = "ip a |grep state|awk '{print$2}'|tr -d ':'|egrep -v 'lo|NONE|virbr'"
            all_port = lava_global.feature_global.server_ssh.send_command(cmd).split()
            for port in all_port:
                lava_global.feature_global.server_ssh.send_command(f"ip link set {port} up")
            time.sleep(3)
        all_nic_ip = []
        for ip in ip_a_list:
            if "0.11" in ip:
                all_nic_ip.append(ip)
        for nic_ip in all_nic_ip:
            ping_ip = nic_ip.replace("0.11", "0.12")
            cmd = f"ping -c 2 {ping_ip} > {nic_ip}.log &"
            lava_global.feature_global.server_ssh.send_command(f"echo '{cmd}' >> nic_check.sh")
        lava_global.feature_global.server_ssh.send_command("bash nic_check.sh")
        pass_inc_list = []
        fail_nic_list = []
        lava_global.feature_global.server_ssh.send_command("rm -f nic_check.sh")
        for every_ip in all_nic_ip:
            nic_result = lava_global.feature_global.server_ssh.send_command(f"cat {every_ip}.log")
            if " 0% packet loss" in nic_result:
                pass_inc_list.append(every_ip)
            else:
                fail_nic_list.append(every_ip)
            lava_global.feature_global.server_ssh.send_command(f"rm -f {every_ip}.log")
        if len(fail_nic_list) != 0 and len(pass_inc_list) != 0:
            ssh_ip = pass_inc_list[0]
            for fail_nic in fail_nic_list:
                tc_ip = fail_nic.replace('0.11', '0.12')
                cmd = f"ip a | grep {fail_nic}|awk '{{print $NF}}'"
                sut_port = lava_global.feature_global.server_ssh.send_command(cmd)
                cmd = f"ip a | grep {tc_ip}|awk '{{print $NF}}'"
                tc_port = lava_global.feature_global.client_ssh.send_command(cmd)
                # 为了防止ssh的口刚好是down的口导致失败而把down和up操作写在一条命令里
                cmd = f"ifconfig {sut_port} down;sleep 1;ifconfig {sut_port} up"
                lava_global.feature_global.server_ssh.send_command(cmd)
                cmd = f"ifconfig {tc_port} down;sleep 1;ifconfig {tc_port} up"
                lava_global.feature_global.client_ssh.send_command(cmd)
                time.sleep(2)
            for fail_nic in fail_nic_list:
                ping_ip = fail_nic.replace("0.11", "0.12")
                fail_nic_result = lava_global.feature_global.server_ssh.send_command(f"ping -c 2 {ping_ip}")
                if " 0% packet loss" not in fail_nic_result:
                    msg_center.error(f"{fail_nic} is fail")
                else:
                    msg_center.info(f"{fail_nic} is pass")
        elif len(fail_nic_list) == 0:
            msg_center.info(f"all ip is pass")
        elif len(pass_inc_list) == 0:
            msg_center.error(f"all ip is fail")

    @staticmethod
    def fn_get_sys_time():
        """
        获取当前系统时间
        :return:返回日期和具体时间
        """
        start_time = time.time()
        time_array = time.localtime(start_time)
        start_time = time.strftime("%Y%m%d %H:%M:%S", time_array)
        date = start_time.split(" ")[0]
        hours = start_time.split(" ")[1].split(':')[0]
        minutes = start_time.split(" ")[1].split(':')[1]
        seconds = start_time.split(" ")[1].split(':')[2]
        now_time = "{}:{}:{}".format(hours, minutes, seconds)
        return date, now_time

    @staticmethod
    def fn_get_os_name(tc=False):
        """
        获取当前OS名，包括内核版本
        :return: OS名，如：Centos 7.7.1908
        """
        cmd = "cat /etc/os-release | grep -w ID | awk -F'=' '{print $2}' | tr '[:upper:]' '[:lower:]'"
        if tc:
            os_name_tmp = lava_global.feature_global.client_ssh.send_command(cmd)
        else:
            os_name_tmp = lava_global.feature_global.server_ssh.send_command(cmd)
        if not os_name_tmp:
            return "None"
        if "suse" in os_name_tmp or "sles" in os_name_tmp:
            os_name = "suse"
        elif "ubuntu" in os_name_tmp:
            os_name = "ubuntu"
        elif "centos" in os_name_tmp:
            os_name = "centos"
        elif "uos" in os_name_tmp:
            os_name = "uos"
        elif "openeuler" in os_name_tmp:
            os_name = "openeuler"
        elif "euleros" in os_name_tmp:
            os_name = "euleros"
        return os_name

    @staticmethod
    def fn_get_mem():
        """
        查询全部、使用和空闲的内存并返回，单位为KB
        :return: 全部、使用和空闲的内存
        """
        total_mem = psutil.virtual_memory().total / 1024
        used_mem = psutil.virtual_memory().used / 1024
        free_mem = psutil.virtual_memory().free / 1024
        return total_mem, used_mem, free_mem

    @staticmethod
    def fn_conversion_mem(input_mem):
        """
        内存单位转换，全部转为KB
        :param input_mem:输入带转换内存大小及单位字符串：”123MB“
        :return:返回转换成kb的大小
        """
        expect_num = input_mem[:-2]
        cal_unit = input_mem[-2:].lower()
        expect_num = int(expect_num)
        if cal_unit == "mb":
            expect_num = expect_num * 1024
        elif cal_unit == "gb":
            expect_num = expect_num * 1024 * 1024
        elif cal_unit == "tb":
            expect_num = expect_num * 1024 * 1024 * 1024
        elif cal_unit == "kb":
            expect_num = expect_num
        else:
            # 获取数据不符合预期，返回异常信息
            msg_center.error("input mem info wrong: {}".format(input_mem))
            return False
        return expect_num

    def fn_check_mem(self, expect_mem, expect_type):
        """
        判断传入的内存大小是否与实际的相近
        :param expect_mem:输入内存的大小，格式为KB
        :param expect_type:预期内存类型（全部、使用、空闲）
        :return:TURE or FALSE
        """
        # 确定范围
        cur_mem = self.fn_get_mem()
        if expect_type == "total":
            get_mm_size = cur_mem[0]
        elif "use" in expect_type:
            get_mm_size = cur_mem[1]
        elif expect_type == "free":
            get_mm_size = cur_mem[2]
        mm_low = float(get_mm_size) * 0.9
        mm_up = float(get_mm_size) * 1.1
        if expect_mem > mm_low and expect_mem < mm_up:
            msg_center.info("current {} is {} ,memory check succeed".format(expect_type, get_mm_size))
            return True
        else:
            msg_center.error("current {} is {} ,memory check failed".format(expect_type, get_mm_size))
            return False

    @staticmethod
    def fn_get_md5sum(file_path):
        """
        计算文件的md5值
        :param file_path:待计算的文件路径
        :return: 返回计算的md5值
        """
        # 得到md5算法对象
        hash_md5 = hashlib.md5()
        # 文件分块读取
        chunk_size = 4096  # 4096 字节（4KB）
        # 以二进制方式读文件
        with open(file_path, "rb") as f:
            # 获取分块数据（bytes），一次读取 chunk_size 个字节
            chunk = f.read(chunk_size)
            # 如果能读取到内容，就一直读取
            while bool(chunk):
                # 应用MD5算法，计算
                hash_md5.update(chunk)
                # 继续读
                chunk = f.read(chunk_size)
        # 返回计算结果(16进制字符串，32位字符)
        return hash_md5.hexdigest()

    def fn_get_files_list(self, local_dir, base_dir, vendor=0):
        """
        根据目录获取当前目录所欲文件列表
        :param local_dir: 待检查目录
        :param base_dir: 获取相对目录时候需要将base_dir从文件路径中剔除
        :param vendor: 0代表获取相对路径，其他代表获取绝对路径
        :return:
        """
        base_dir = os.path.realpath(base_dir)
        # 保存所有文件的列表
        all_files = list()
        # 获取当前指定目录下的所有目录及文件，包含属性值
        files = os.listdir(local_dir)
        for x in files:
            # local_dir目录中每一个文件或目录的完整路径
            filename = os.path.join(local_dir, x)
            # 如果是目录，则递归处理该目录
            if os.path.isdir(filename):
                all_files.extend(self.fn_get_files_list(filename, base_dir, vendor))
            else:
                if vendor == 0:
                    filename = filename.replace(base_dir, "")[1:]
                all_files.append(filename)
        return all_files

    @staticmethod
    def fn_get_process_status(pro_name):
        """
        查看进程是结束
        example：fn_get_process_status(pro_name="iperf")
        :param pro_name:进程名称，必要参数
        :return:
        """
        pro_status_dic = {}
        # 查看所有进程ID
        pids = psutil.pids()
        for pid in pids:  # 匹配进程名称
            p = psutil.Process(pid)
            if pro_name in p.name():
                pro_id = p.pid
                pro_status = p.status()
                msg_center.info("{} {} is {}".format(pro_id, pro_name, pro_status))
                pro_status_dic[pro_id] = [p.name(), pro_status]
        return pro_status_dic

    @staticmethod
    def fn_check_cpu():
        """
        获取CPU核数
        :return: 返回CPU核数
        """
        cpu_num = psutil.cpu_count()
        msg_center.info("CPU has {} cores.".format(cpu_num))
        return cpu_num

    @staticmethod
    def fn_change_route_ip(ip_list=None):
        """
        将输入的IP列表转换为路由的形式
        :param ip_list: 正常的IP列表
        :return: 路由列表
        """
        if ip_list is None:
            ip_list = []
        add_route = []
        for ip_temp in ip_list:
            head_ip = ip_temp.split(".")[:-1]
            route_temp = ".".join(head_ip) + ".0/24"
            msg_center.info("get route".format(route_temp))
            add_route.append(route_temp)
        return add_route

    @staticmethod
    def fn_get_ip_by_port(port_name):
        """
        通过网口名获取IP
        :param port_name:网口名
        :return: 查询到则返回IP，否返回FALSE
        """
        # 查询更改之后的ipv4地址，成功返回0，否则为非0值
        try:
            cmd = f"ip a show {port_name} |grep -w inet |awk '{{print$2}}'|awk -F'/' '{{print$1}}'"
            this_ip = lava_global.feature_global.server_ssh.send_command(cmd)
            msg_center.info("get {0} IP address : {1}".format(port_name, this_ip))
            return this_ip
        except Exception as e:
            msg_center.info(e)
            msg_center.info("{0} doesn't has IP address".format(port_name))
            return False
        finally:
            pass

    @staticmethod
    def fn_get_ip6_by_port(port_name):
        """
        通过网口名获取ipv6地址
        :param port_name: 网口名
        :return: 查询到则返回IP6，否返回FALSE
        """
        # 查询更改之后的ipv4地址，成功返回0，否则为非0值
        try:
            cmd = f"ip a show {port_name} |grep inet6 |awk '{{print$2}}'|awk -F'/' '{{print$1}}'"
            this_ip = lava_global.feature_global.server_ssh.send_command(cmd)
            msg_center.info("get {0} IP address : {1}".format(port_name, this_ip))
            return this_ip
        except Exception as e:
            msg_center.info(e)
            msg_center.info("{0} doesn't has IP address".format(port_name))
            return False
        finally:
            pass

    def fn_ip_port_list(self):
        """
        获取本机所有IP和网口名对应的字典，由列表保存
        :return: 格式[{"eth0","129.168.1.1"},{"192.168.1.1":"eth0"}]
        """
        # 获取所有网口名
        cmd = "ip a |grep state|awk '{print$2}' |tr -d ':' |egrep -v 'lo|NONE|virbr''"
        port_name_loop = lava_global.feature_global.server_ssh.send_command(cmd).split()
        port_ip_list = [{}, {}, {}]
        # 遍历所有网口名
        for port_name in port_name_loop:
            this_ip = self.fn_get_ip_by_port(port_name)
            if this_ip:
                port_ip_list[0][port_name] = this_ip
                port_ip_list[1][this_ip] = port_name
        msg_center.info("all ip and port :\n {0}".format(port_ip_list[0]))
        return port_ip_list

    def fn_get_port_name(self, ip_list):
        """
        根据网口IP获取网口名
        :param ip_list: 传入待查询的IP列表
        :return: 返回网口名列表
        """
        port_name_list = []
        port_ip_list = self.fn_ip_port_list()[1]
        # 遍历传入的ip列表
        for this_ip in ip_list:
            if this_ip in port_ip_list.keys():
                port_name_list.append(port_ip_list.get(this_ip))
        if len(port_name_list) == len(ip_list):
            return False
        else:
            return port_name_list

    def fn_add_route(self, add_ip_list=None):
        """
        检查路由是否存在，若不存在添加路由
        :param add_ip_list: 需要检查的IP列表
        :return: 添加成功返回TRUE，失败FALSE
        """
        if add_ip_list is None:
            add_ip_list = []
        add_name = self.fn_get_port_name(add_ip_list)
        add_route = self.fn_change_route_ip(add_ip_list)
        if add_ip_list == []:
            msg_center.error("Usage: fn_add_route ip_list is null")
            return False
        check_tag = 0
        for add_num in range(0, len(add_ip_list)):
            cmd1 = "ip route | grep {}".format(add_route[add_num])
            if lava_global.feature_global.server_ssh.send_command(cmd1) != 0:
                cmd2 = "ip route add dev {} {}".format(add_name[add_num], add_route[add_num])
                lava_global.feature_global.server_ssh.send_command(cmd2)
                if lava_global.feature_global.server_ssh.send_command(cmd1) == 0:
                    msg_center.info("SUT {}} route add success!".format(add_name[add_num]))
                else:
                    msg_center.error("SUT {} route add fail!".format(add_name[add_num]))
                    check_tag += 1
            else:
                msg_center.info("SUT {} route is already ok!".format(add_name[add_num]))
        if check_tag == 0:
            return True
        return False

    def fn_check_dmesg(self, check_type="not like", check_content="error|fail|call trace", information=""):
        """
        检查dmesg是否异常
        :param check_type:匹配类型："like" or "not like"
        :param check_content:检查内容
        :param information:不检查的内容
        :return:
        """
        ret = lava_global.feature_global.server_ssh.send_command("dmidecode -t bios |grep -i pangea")
        if len(ret) != 0:
            msg_center.info("当前测试环境为盘古环境，跳过校验dmesg信息")
            return True
        unchecked = "drm_atomic_helper_wait_for_vblanks.part"  # 屏蔽drm错误引起的call trace
        default_info = "Hardware Error|-16|warning: setlocale|unknown memory|EXT failed|set xfermode|USBDEVFS_CONTROL failed|faillog"
        if information == "":
            information = default_info
        else:
            information = default_info + "|" + information
        os_type = self.fn_get_os_name()
        if os_type == "openeuler":
            information = information + "|terminal=ssh"
        if self.check_os_kernel_version():
            check_content = "error|fail"  # call trace另做校验
            cmd = "dmesg | grep -vE 'fail to alloc uacce' | grep -vE \"{}\" | grep -iE \"{}\"". \
                format(information, check_content)
            check_dmesg_fail = lava_global.feature_global.server_ssh.send_command(cmd)
            check_dmesg_trace = ""
            msg = lava_global.feature_global.server_ssh.send_command("dmesg | grep -iA 1 'call trace'")
            if len(msg) > 0:
                for trace in msg.split(']\n'):
                    if re.search(unchecked, trace) is not None:  # 过滤trace白名单
                        continue
                    else:
                        check_dmesg_trace = "Unexpected call trace exists, please check!"
                        break
            check_dmesg = check_dmesg_fail + check_dmesg_trace
        else:
            cmd = "dmesg | grep -vE \"{}\" | grep -iE \"{}\"".format(information, check_content)
            check_dmesg = lava_global.feature_global.server_ssh.send_command(cmd)
        if check_type == "like" and len(check_dmesg) > 0:
            msg_center.info("check dmesg pass")
            msg_center.info(check_dmesg)
            return True
        elif check_type == "not like" and len(check_dmesg) == 0:
            msg_center.info("check dmesg pass")
            return True
        else:
            msg_center.error(check_dmesg)
            msg_center.error("check dmesg fail")
            return False

    @staticmethod
    def fn_write_file(file_path=None, op_num=3, write_content=None):
        op_dic = {1: "w+", 2: "r+", 3: "a+"}
        # 打开一个文件，写入指定内容
        f = open("{0}".format(file_path), "{0}".format(op_dic.get(op_num)))
        f.write("{}".format(write_content))
        f.close()
        # 检查文件中是否写入指定内容
        f = open("{0}".format(file_path), "r")
        line = f.readline()
        while line:
            # 逐行读取文件，在传入的字符串中（单行或含\n分割的多行）查找
            if write_content.find("{}".format(line.strip())) != -1:
                msg_center.info("Write'{0}' to file(:{1}) pass".format(line.strip(), file_path))
                # 找到后，从字符串中将对应内容替换为空格
                write_content = write_content.replace("{}".format(line.strip()), " ", 1)
                # 最终判断字符串是否被删完，删完即pass
                if len(write_content.strip()) == 0:
                    f.close()
                    return True
                else:
                    line = f.readline()
            else:
                line = f.readline()
        msg_center.error("Write file(:{0}) fail".format(file_path))
        return False

    @staticmethod
    def fn_remote_reboot(input_commad, execute_times=1):
        """
        远程重启
        :param input_commad:
        :param execute_times: reboot参数
        :return:
        """
        command_list = {"-f": "reboot -f", "-i": "reboot -i", "-s": "reboot -s"}
        if input_commad not in command_list.keys():
            exec_command = "reboot"
        else:
            exec_command = command_list.get(input_commad)
        print(exec_command)
        for i in range(execute_times):
            cmd_command = exec_command
            lava_global.feature_global.client_ssh.send_command(cmd_command)
            time.sleep(300)

    @staticmethod
    def fn_dmesg_info(dmesg_info, max_time, info_count=1):
        """
        查看一段时间内，dmesg是否有需要的打印
        Examples:fn_dmesg_info("fail",20,10)
        :param dmesg_info: 需要在dmesg中检查的字段
        :param max_time:最大时间，超过这个时间dmesg还未出现需要的打印则返回false,单位：秒
        :param info_count:dmesg中检查字段出现的次数
        :return:
        """
        for i in range(max_time):
            cmd = "dmesg | egrep -i '{}'".format(dmesg_info)
            if lava_global.feature_global.server_ssh.send_command(cmd) == 0:
                cmd = "dmesg | egrep -i '{}' | wc -l".format(dmesg_info)
                if int(lava_global.feature_global.server_ssh.send_command(cmd)) >= info_count:
                    msg_center.info(
                        "check dmesg {} {} times successfully".format(dmesg_info, info_count))
                    return True
            else:
                time.sleep(1)
        msg_center.error("check dmesg {} {} times failed".format(dmesg_info, info_count))
        return False

    @staticmethod
    def check_os_kernel_version():
        """
        判断内核是否大于5.11
        :return:
        gt 5.11 return False
        lt 5.11 return True
        """
        cmd = 'uname -r'
        ret = lava_global.feature_global.server_ssh.send_command(cmd)
        os_name_lst = ret.split('.')
        if 2 > len(os_name_lst[1]):
            os_name_lst[1] = os_name_lst[1].zfill(2)
        os_name = os_name_lst[0] + '.' + os_name_lst[1]
        return False if 5.11 <= float(os_name) else True

    def save_sys_log(self, start=True, tc=False):
        """
        保存log
        :param start:
        :param tc:
        :return:
        """
        # 判断是否是单机环境，单机环境时候tc为True直接退出
        msg_center.info("start save sys log")
        if tc:
            rst = lava_global.feature_global.server_ssh.send_command("ip a")
            if "192.168.40.11" not in rst:
                msg_center.info("single environment")
                return
        # 获取os名
        os_name = self.fn_get_os_name(tc=tc)
        sys_log_file = []
        if os_name in ["ubuntu", "debian"]:
            sys_log_file.extend(["kern.log", "syslog", "dpkg.log"])
        elif os_name in ["suse", "opensuse", "redhat", "centos", "kylin", "openeuler", "uos"]:
            sys_log_file.extend(["messages"])
        else:
            msg_center.error("os type is not supported: %s" % os_name)
            return
        # 获取日志保存路径，对端没有lava-xxx路径，直接仿照本端环境生成该路径即可
        cur_dir = lava_global.feature_global.server_ssh.send_command("pwd")
        lava_jobid = re.findall("lava[^/]+", cur_dir)
        if len(lava_jobid) != 1:
            msg_center.error("get lava job url error: %s" % cur_dir)
            return
        cilog_dir = "/home/cilog/%s" % lava_jobid[0]
        local_dir = ["{}/{}".format(cilog_dir, i) for i in ["start", "end", "new"]]
        # 避免干扰，删除已有日志文件，再重新创建目录
        if start:
            lava_global.feature_global.server_ssh.send_command("rm -rf %s" % local_dir[0])
        else:
            lava_global.feature_global.server_ssh.send_command("rm -rf %s %s" % (local_dir[1], local_dir[2]))
        lava_global.feature_global.server_ssh.send_command("mkdir -p %s %s %s" % (local_dir[0], local_dir[1],
                                                                                  local_dir[2]))
        # 获取系统日志文件名
        sys_log_dir = "/var/log"
        sys_logs = lava_global.feature_global.server_ssh.send_command("cd %s; ls" % sys_log_dir).splitlines()
        msg_center.info(sys_logs)
        # 对日志文件名逐一检查，符合要求的复制到前面lava-xxx路径下
        for i in sys_logs:
            if True in list(map(lambda x: True if x == i else False, sys_log_file)) and (
                    "20" not in i or "19" not in i):
                file_path = os.path.join(sys_log_dir, i)
                cp_path = local_dir[0] if start else local_dir[1]
                msg_center.info("cp %s %s" % (file_path, cp_path))
                lava_global.feature_global.server_ssh.send_command("cp %s %s" % (file_path, cp_path))
                # 对于后置操作，需要检查增量日志，通过diff获取增量日志内容
                if not start:
                    cmd = "diff {1}/{0} {2}/{0} | grep '<'".format(i, sys_log_dir, local_dir[0])
                    rst = lava_global.feature_global.server_ssh.send_command(cmd)
                    rst = rst.replace("< ", "")
                    lava_global.feature_global.server_ssh.send_command("echo '%s' > %s/%s" % (rst, local_dir[2], i))
        # 对端后置处理需要将日志文件拷贝到本端环境才能被lava平台收集
        if tc and not start:
            lava_global.feature_global.server_ssh.send_command("rm -rf %s/tc" % cilog_dir)
            lava_global.feature_global.client_scp.pull(cilog_dir, "%s/tc" % cilog_dir)

    @staticmethod
    def wait_cmd_end(cmd, iterate=1, times=10, expect_word=None, ssh_type="server"):
        '''
        函 数 名：wait_cmd_end
        函数说明: 根据执行命令与预期值，进行循环等待
        参数 cmd: str 待执行命令
        参数 iterate: int 每轮循环等待时间间隔
        参数 times: int 最大循环次数
        参数 expect_word: str 命令执行返回中所包含的预期
        参数 ssh_type: 是否到对端执行(str)入参：server/client
        返回值: 超时退出则返回1， 正常退出返回0
        '''
        if ssh_type == "server":
            ssh_connect = lava_global.feature_global.server_ssh
        else:
            ssh_connect = lava_global.feature_global.client_ssh
        for i in range(times):
            rst = ssh_connect.send_command(cmd, disable_show_and_log=True)
            # 命令返回结果有打印时，传入的期望值不为None,根据传入的期望值进行判断
            if expect_word is not None:
                if expect_word in rst:
                    msg_center.info(f"check time is: {i * iterate}")
                    msg_center.info(f"cmd result is: {rst}")
                    return 0
            # 命令无打印时，期望值默认None，此时返回的结果长度为0
            else:
                if len(rst.strip()) == 0:
                    msg_center.info(f"check time is: {i * iterate}")
                    return 0
            time.sleep(iterate)
        msg_center.error(f"check timeout,please check,time is: {i * iterate}")
        ssh_connect.send_command(cmd)
        return 1

    @staticmethod
    def get_hostname():
        """
        获取当前主机的终端名称
        :return:
        """
        os_name = SysUtil.fn_get_os_name()
        hostname = lava_global.feature_global.server_ssh.send_command("cat /etc/hostname")
        if "ubuntu" in os_name or "debian" in os_name:
            host_expect = f"root@{hostname}:~#"
        elif "centos" in os_name or "openeuler" in os_name:
            host_expect = f"[root@{hostname.split('.')[0]} ~]#"
        elif "suse" in os_name:
            host_expect = "localhost:~ #"
        else:
            host_expect = f"{hostname}:~ #"
        msg_center.info(f"this is :{os_name},hostname is :{hostname},host_expect is :{host_expect}")
        return host_expect
