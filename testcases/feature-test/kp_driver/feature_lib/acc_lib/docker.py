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


import os
import time

from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_utils import check_result
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal
from common_lib.base_lib.base_multi_mode_terminal import TYPE_BASE_SSH
from common_lib.base_lib.base_config import SUCCESS_CODE, FAILURE_CODE


class Docker:
    """
    Docker类
    """

    def __init__(self, name="acc", image="euleros", **kwargs):
        """
        #!!==================================================================================
        #  方法名字: __init__
        #  参数说明:
        #           name 创建的容器的名称
        #           image 容器镜像名称
        #  函数
        #  生成日期: 2021-03-19
        #  修改记录:
        #!!==================================================================================
        """
        self.ret = 0
        self.name = name
        self.image = image
        self.stdout = None
        MultiModeTerminal.realtime_output = True
        MultiModeTerminal.cmd_result = True
        if not kwargs.get("terminal", None):
            ip_addr = kwargs.get("ip", "172.26.101.179")
            port = kwargs.get("port", 22)
            username = kwargs.get("username", "root")
            password = kwargs.get("password", 'root')
            con_type = kwargs.get("con_type", TYPE_BASE_SSH)
            timeout = kwargs.get("timeout", 5)
            self.terminal = MultiModeTerminal(ip=ip_addr, port=port,
                                              username=username,
                                              password=password,
                                              type=con_type, timeout=timeout, strip_head_tail=True
                                              )
            self.terminal.open_connect()
        else:
            self.terminal = kwargs.get("terminal")

    def docker_reboot(self):
        """
        #!!==================================================================================
        #  方法名字: docker_reboot方法
        #  方法说明: 重启容器服务
        #  参数说明: NA
        #  方法返回: 0:success, 1:fail
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "重启容器服务"
        msg_center.info(step_name)

        cmd = 'systemctl daemon-reload'
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        cmd = 'service docker restart'
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        return SUCCESS_CODE

    def docker_start(self):
        """
        #!!==================================================================================
        #  方法名字: docker_start方法
        #  方法说明: 启动停止的容器
        #  参数说明: name：容器名称
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "启动停止的容器{}".format(self.name)
        msg_center.info(step_name)

        cmd = 'docker start {}'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        cmd = 'docker ps -a | grep {} | grep "Exited"'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code == 0:
            return FAILURE_CODE

        return SUCCESS_CODE

    def docker_run(self, image="acc_docker", **kwargs):
        """
        #!!==================================================================================
        #  方法名字: docker_run方法
        #  方法说明: 启动一个新的容器
        #  参数说明: name：容器名称，str
        #          image：镜像名称，str
        #          hostname：容器的主机名称，str
        #          network：容器的网络连接名称，str
        #          ip：容器网卡的IP地址，str
        #          pri：容器获得特权，--privileged或空
        #          device：指定需要用的设备文件挂载到容器，list
        #          volume：绑定一个卷，list
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        para_volume = ""
        para_device = ""
        para_hostname = ""
        para_network = ""
        para_ip = ""
        hostname = kwargs.get('hostname', "")
        network = kwargs.get('network', "")
        ip = kwargs.get('ip', "")
        pri = kwargs.get('pri', "")
        device = kwargs.get('device', [])
        volume = kwargs.get('volume', [])
        para_name = '--name={}'.format(self.name)

        if hostname:
            if not isinstance(hostname, str):
                raise TypeError(r"hostname in para type error %s" % type(hostname))
            para_hostname = '-h {}'.format(hostname)

        if network:
            if not isinstance(network, str):
                raise TypeError(r"network in para type error %s" % type(network))
            para_network = '--net={}'.format(network)

        if ip:
            if not isinstance(ip, str):
                raise TypeError(r"ip in para type error %s" % type(ip))
            para_ip = '--ip={}'.format(ip)

        if volume:
            if not isinstance(volume, list):
                raise TypeError(r"volume in para type error %s" % type(volume))
            for vol in volume:
                para_volume += "-v {} ".format(vol)

        if device:
            if not isinstance(device, list):
                raise TypeError(r"device in para type error %s" % type(device))
            for dev in device:
                para_device += "--device={} ".format(dev)

        para_pri = "--privileged" if pri else ""

        if not isinstance(image, str):
            raise TypeError(r"image in para type error %s" % type(image))
        para_image = image

        step_name = "启动新的容器{}".format(self.name)
        msg_center.info(step_name)

        cmd = 'docker run -i {} {} {} {} {} {} {} {} /bin/bash &'. \
            format(para_name, para_hostname, para_network, para_ip, para_volume, para_device, para_pri, para_image)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        if self.check_docker_process() != 0:
            return FAILURE_CODE

        if self.docker_start() != 0:
            return FAILURE_CODE

        return SUCCESS_CODE

    def excecute_job_with_no_file(self, timeout=5, is_bak=False, time_len=1, **kwargs):
        '''
        #!!=====================================================================
        # 过  程  名： excute_long_testcase
        # 函数说明：执行hpre测试用例
        # 参数说明： timeout 超时时间
        is_bak 是否放后台
        time_len 隔多少秒检查一次
        **kwargs xxx 等参数字典
        # 返  回  值：retcode -1 失败, 0 成功;
        # 注意事项：
        # 使用实例：object = self.excute_long_testcase()
        # 对应命令：无
        #
        # 
        # 生成时间： 2022-7-27
        # 修改纪录：
        #!!=====================================================================
        '''
        cmd = "acc_test {options} {alg} {key_size} {thread} {poll_num} {op_type} {check} {other} -vv " \
              ">> /home/acc_test.log 2>&1 &".format(**kwargs)
        self.docker_execute(cmd)
        if is_bak:
            return SUCCESS_CODE
        # 判断业务是否执行结束
        cmd = "ps -ef | grep acc_test"
        while timeout > 0:
            retstr = self.terminal.send_command(cmd)
            if timeout <= 0:
                msg_center.error('业务执行超时, cmd=%s' % cmd)
                self.terminal.send_command("pkill -9 acc_test")
                return FAILURE_CODE
            if kwargs.get("alg") not in retstr:
                msg_center.error('业务执行结束, cmd=%s' % cmd)
                break
            time.sleep(1)
            timeout -= time_len
        # 判断业务是否执行成功
        cmd = "cat /home/acc_test.log"
        retstr = self.terminal.send_command(cmd)
        cmd = "rm -rf /home/acc_test.log"
        self.terminal.send_command(cmd)
        if "error" in retstr.lower() or 'fail' in retstr.lower():
            msg_center.error('命令执行失败, cmd=%s' % cmd)
            return FAILURE_CODE
        return SUCCESS_CODE

    def check_docker_process(self):
        """
        #!!==================================================================================
        #  方法名字: check_docker_process方法
        #  方法说明: 检查容器进程是否存在
        #  参数说明: name：容器名称
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "查看容器{}进程是否在".format(self.name)
        msg_center.info(step_name)

        cmd = 'docker ps -a | grep {}'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            msg_center.info("docker {} not exist".format(self.name))
            return FAILURE_CODE

        return SUCCESS_CODE

    def docker_execute(self, command="ls", full=False):
        """
        #!!==================================================================================
        #  方法名字: docker_execute方法
        #  方法说明: 容器内执行命令
        #  参数说明: name：容器名称
        #          full: 如果是True，则会返回shell命令执行后的状态码与结果信息，默认是False
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        return self.terminal.send_command("docker exec {} {}".format(self.name, command))

    def docker_cp(self, file=None, file_path="/"):
        """
        #!!==================================================================================
        #  方法名字: docker_cp方法
        #  方法说明: 拷贝文件到docker
        #  参数说明: file：需要拷贝的文件
        #          file_path：拷贝到容器内的路径
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "拷贝文件{}到容器{}".format(file, self.name)
        msg_center.info(step_name)

        cmd = 'docker cp {} {}:{}'.format(file, self.name, file_path)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            msg_center.info("cp {} to docker dir {} fail".format(file, file_path))
            return FAILURE_CODE
        return SUCCESS_CODE

    def docker_stop(self):
        """
        #!!==================================================================================
        #  方法名字: docker_stop方法
        #  方法说明: 停止启动的容器
        #  参数说明: name：容器名称
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "停止启动的容器{}".format(self.name)
        msg_center.info(step_name)

        cmd = 'docker stop {}'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        cmd = 'docker ps -a | grep {} | grep "Exited"'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            return FAILURE_CODE

        return SUCCESS_CODE

    def docker_remove(self):
        """
        #!!==================================================================================
        #  方法名字: docker_remove方法
        #  方法说明: 删除指定容器，只能删除stop状态的容器
        #  参数说明: name：容器名称
        #  方法返回:
        #  方法
        #  生成日期: 2020-03-19
        #  修改记录:
        #!!==================================================================================
        """
        step_name = "删除容器{}".format(self.name)
        msg_center.info(step_name)

        cmd = 'docker rm -f {}'.format(self.name)
        self.terminal.send_command(cmd)
        if self.terminal.ret_code != 0:
            msg_center.info("remove docker {} fail".format(self.name))
            return FAILURE_CODE

        if self.check_docker_process() == 0:
            return FAILURE_CODE

        return SUCCESS_CODE

    def down_docker(self, timeout=180):
        """
        下载docker文件
        """
        wget_cmd = [
            'wget -c -q -t 1 -T 5 --no-check-certificate -P /root/docker/ http://10.90.31.79:8083/platform/VM/docker/centos.tar',
            'wget -c -q -t 1 -T 5 --no-check-certificate -P /root/docker/ http://10.90.31.79:8083/platform/VM/docker/container-selinux-2.107-3.el7.noarch.rpm',
            'wget -c -q -t 1 -T 5 --no-check-certificate -P /root/docker/ http://10.90.31.79:8083/platform/VM/docker/containerd.io-1.2.6-3.3.el7.aarch64.rpm',
            'wget -c -q -t 1 -T 5 --no-check-certificate -P /root/docker/ http://10.90.31.79:8083/platform/VM/docker/docker-ce-18.09.7-3.el7.aarch64.rpm',
            'wget -c -q -t 1 -T 5 --no-check-certificate -P /root/docker/ http://10.90.31.79:8083/platform/VM/docker/docker-ce-cli-18.09.7-3.el7.aarch64.rpm'
        ]
        for i in wget_cmd:
            self.terminal.send_command(i)
            ret_code = self.terminal.ret_code
        file_generator = (file for *_, file in os.walk('/root/docker'))
        file_list = list(file_generator)[0]
        check_result(len(file_list), 5)
    
    def install_docker(self):
        """
        安装docker
        """
        self.terminal.send_command('cd /root/docker; yum install -y *.rpm')
        self.terminal.send_command('systemctl daemon-reload')
        self.terminal.send_command('service docker restart')
        self.terminal.send_command('docker')
        ret_code = self.terminal.send_command.ret_code
        check_result(ret_code, 0)

    def docker_load_image(self):
        """
        load centos
        """
        self.terminal.send_command('systemctl daemon-reload')
        self.terminal.send_command('service docker restart')
        self.terminal.send_command('cd /root/docker;docker load < centos.tar')
        ret_str = self.terminal.send_command('docker image ls |awk \'NR==2{print $1}\'')
        check_result(ret_str, 'centos')

    @staticmethod
    def docker_wait_process(process_name, docker_name):
        """
        函数说明 : 等待docker进程结束
        参数说明 :process_name：进程名，docker_name：docker
        """
        task_cmd = 'ps -ef | grep "{}" | grep -v grep | grep -v defunct'.format(process_name)
        times = 0
        while True:
            _, stdout = docker_name.docker_execute(task_cmd)
            if not stdout:
                break
            if times == 600:
                msg_center.error('FAIL, {} exit failed')
                return FAILURE_CODE
            time.sleep(1)
            times += 1
        return SUCCESS_CODE
    
    def docker_kill_process(self, process_name, docker_name):
        """
        函数说明 : kill docker进程
        参数说明 :process_name：进程名，docker_name：docker
        """
        task_cmd = "ps -ef | grep %s | grep -v grep | awk -F ' ' '{print $2}'" % process_name
        _, stdout = docker_name.docker_execute(task_cmd)
        proce_id = stdout.split()
        if not proce_id:
            return FAILURE_CODE
        for pid in proce_id:
            task_cmd = "kill -9 %s" % pid
            docker_name.docker_execute(task_cmd)
            ret_code = self.docker_wait_process(process_name, docker_name)
            if ret_code != 0:
                msg_center.error('FAIL,kill -9 %s failed' % process_name)
                return FAILURE_CODE
    
        return SUCCESS_CODE


if __name__ == '__main__':
    device_list = ["/dev/hisi_hpre-2:/dev/hisi_hpre-2:rwm", "/dev/hisi_hpre-3:/dev/hisi_hpre-3:rwm"]
    docker1 = Docker(name="roce")
    docker2 = Docker(name="acc")
    docker1.docker_reboot()
    docker1.docker_run(hostname="roce")
    docker2.docker_run(hostname="acc", device=device_list)
    docker1.docker_cp(file="server", file_path="/")
    docker2.docker_cp(file="server", file_path="/")
    docker1.docker_execute()
    docker2.docker_execute(command="ls /dev")
    docker1.docker_stop()
    docker2.docker_stop()
    docker1.docker_remove()
    docker2.docker_remove()
