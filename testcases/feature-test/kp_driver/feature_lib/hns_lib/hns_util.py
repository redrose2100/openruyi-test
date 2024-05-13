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
# @Date      	:   2024-05-07 15:36:43
# @License   	:   Mulan PSL v2
# @Desc      	:   add lib for acc enviroment
#####################################


import os
import time
import re
import random
from IPy import IP
import concurrent.futures
import pytest

THIS_FILE_PATH = os.path.dirname(os.path.realpath(__file__))

from test_config.feature_config.hns_config import hns_config as configs_network
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal
from feature_lib.sys_lib.sys_init import SysInit as sys_env_init
from feature_lib.sys_lib.sys_util import SysUtil as sys_base_info
from feature_lib.sys_lib.sys_clean import SysClean
from test_config.feature_config.hns_config.hns_config import hns_global
from kp_net import common_net as knet
from kp_devinfo.device import eth as kdevinfo

from common_lib.base_lib.base_config import SUCCESS_CODE, FAILURE_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from test_config.feature_config.hns_config import hns_config
from feature_lib.hns_lib import hns_eth_attributes as attr
from feature_lib.hns_lib import hns_common as comm
from feature_lib.hns_lib import hns_ko
from feature_lib.hns_lib import hns_config_basic as conf
from feature_lib.hns_lib import hns_config_ethtool as ethtool
from feature_lib.hns_lib import hns_config_dcb as dcb


class Hns3Util:
    """
    HNS模块公共库函数
    """

    def __init__(self, **kwargs):
        self.terminal_server = kwargs.get("terminal_server", hns_global.server_ssh)
        self.terminal_client = kwargs.get("terminal_client", hns_global.client_ssh)

    def nic_up_card_list(self):
        """
        获取本端所有link状态为“yes”的网口名（ethtool ethx的Link detected字段为准）
        :return:满足以上条件的网口名的列表
        """
        physical_network_card = []
        # 1、找出非“lo|vi|br”类型的网口集合
        cmd = "ip a |grep state |egrep -v '@|lo|vi|br' |awk '{print $2}' |tr -d ':'"
        info = self.terminal_server.send_command(cmd).split()
        # 2、设置以上网口为up
        for i in info:
            self.terminal_server.send_command("ip link set dev {0} up".format(i))
        time.sleep(configs_network.NETWORK_RESTART_TIME)
        # 3、筛选出在步骤1的集合，且状态为up的网口列表
        for i in info:
            cmd = f"ethtool {i} |grep -i 'link detected' |awk '{{print$NF}}'"
            if self.terminal_server.send_command(cmd) == "yes":
                physical_network_card.append(i)
            else:
                msg_center.error("eth {0} link status is down!".format(i))
        msg_center.info("all up network card: \n{}".format(physical_network_card))
        return physical_network_card

    def nic_run_iperf(self, port_name, server_ip, run_times, run_interval, pkg_num, run_port, tc=False):
        """
        Description ：启动iperf client
        Examples ：nic_run_iperf("","","","","")
        :param port_name: 本端网口名(必要参数）
        :param server_ip：server端ip(必要参数）
        :param run_times: iperf冲包时间(必要参数）
        :param tc:默认本端做发包客户端，对端发包入参tc=True
        :param run_interval: 打印时间间隔(非必要参数）
        :param pkg_num: 线程数(非必要参数）
        :param run_port: iperf冲包端口(非必要参数）
        :return :
        """
        numa_cpus = self.nic_taskset_check(port_name)[2]
        # 检查是否有ip输入
        if not server_ip and run_times:
            msg_center.info("Please enter ip or time.")
            return False
        # iperf冲包
        if tc:
            if not run_interval:
                cmd = "taskset -c {} iperf -c {} -t {} -P {} -p {} > /tmp/iperf.log &" \
                    .format(numa_cpus, server_ip, run_times, pkg_num, run_port)
                self.terminal_client.send_command(cmd)
            else:
                cmd = "taskset -c {} iperf -c {} -t {} -i {} -P {} -p {} > /tmp/iperf.log &" \
                    .format(numa_cpus, server_ip, run_times, run_interval, pkg_num, run_port)
                self.terminal_client.send_command(cmd)
        else:
            if not run_interval:
                cmd = "taskset -c {} iperf -c {} -t {} -P {} -p {} > /tmp/iperf.log &" \
                    .format(numa_cpus, server_ip, run_times, pkg_num, run_port)
                self.terminal_server.send_command(cmd)
            else:
                cmd = "taskset -c {} iperf -c {} -t {} -i {} -P {} -p {} > /tmp/iperf.log &" \
                    .format(numa_cpus, server_ip, run_times, run_interval, pkg_num, run_port)
                self.terminal_server.send_command(cmd)

    def nic_run_netperf(self, rx_ip, run_times, tc=False, **kwargs):
        """
        Description ：启动netperf client
        Examples ：nic_run_netperf_client("", "", "")
        :param rx_ip:收包端IP
        :param protocol:报文协议类型
        :param tc: 默认本端做发包客户端，对端发包入参tc=True
        :param run_times: iperf冲包时间(必要参数）
        :param pkg_size: pkt_length的大小(非必要参数）
        :return:
        """
        protocol = kwargs.get("protocol", "TCP_STREAM")
        ip_type = kwargs.get("ip_type", "")
        pkg_size = kwargs.get("pkg_size", "")
        # 检查是否有ip输入
        if not rx_ip and run_times:
            msg_center.info("Please enter ip or time.")
        terminal1 = self.terminal_server if tc else self.terminal_client
        terminal2 = self.terminal_client if tc else self.terminal_server
        # 开启netserver
        if not terminal1.send_command("pgrep netserver"):
            terminal1.send_command("netserver")
        comm.wait_time(2)
        # netperf冲包
        terminal2.send_command("killall -9 netperf")
        cmd = "netperf {3} -H {0} -t {1} -l {2} {4} > /root/{1}.log &".format(rx_ip, protocol, run_times, ip_type,
                                                                              pkg_size)
        terminal2.send_command(cmd)
        cmd = f"grep '10\\.' /root/{protocol}.log | head -n 1 | awk '{{print $NF}}'"
        speed = terminal2.send_command(cmd)
        return float(speed)

    def nic_run_qperf(self, port_name, rx_ip, test_type, tc=False):
        """
        Description ：启动qperf client
        Examples ：nic_run_qperf_client("", "", ")
        :param port_name: 本端网口名(必要参数）
        :param rx_ip：server收包端ip(必要参数）
        :param test_type: 测试协议类型tcp_lat|udp_lat(必要参数）
        :return:
        """
        numa_cpus = self.nic_taskset_check(port_name)[2]
        # 检查是否有ip输入
        if not rx_ip and test_type:
            msg_center.info("Please enter ip or test protocol type .")
        # 启动qperf
        if tc:
            if not numa_cpus:
                cmd = "qperf -oo msg_size:1:64K:*2 {} -vu {} > /tmp/qperf.log".format(rx_ip, test_type)
                self.terminal_client.send_command(cmd)
            else:
                cmd = "taskset -c {} qperf -oo msg_size:1:64K:*2 {} -vu {} > /tmp/qperf.log &" \
                    .format(numa_cpus, rx_ip, test_type)
                self.terminal_client.send_command(cmd)
        else:
            if not numa_cpus:
                cmd = "qperf -oo msg_size:1:64K:*2 {} -vu {} > /tmp/qperf.log".format(rx_ip, test_type)
                self.terminal_server.send_command(cmd)
            else:
                cmd = "taskset -c {} qperf -oo msg_size:1:64K:*2 {} -vu {} > /tmp/qperf.log &" \
                    .format(numa_cpus, rx_ip, test_type)
                self.terminal_server.send_command(cmd)

    def nic_taskset_check(self, port_name, tc=False):
        """
        Description ：查询网口的node节点、CPU绑核数Y
        Examples ：nic_taskset_check(port_name)[2]
        :param tc: 默认检查本端，检查对端时入参tc=True
        :param port_name:网口名称(必要参数）
        :return:
        """
        if tc:
            cmd = "cat /sys/class/net/{}/device/numa_node".format(port_name)
            numa_num = self.terminal_client.send_command(cmd)
            cmd = "cat /sys/class/net/{}/device/local_cpulist".format(port_name)
            numa_cpus = self.terminal_client.send_command(cmd)
        else:
            cmd = "cat /sys/class/net/{}/device/numa_node".format(port_name)
            numa_num = self.terminal_server.send_command(cmd)
            cmd = "cat /sys/class/net/{}/device/local_cpulist".format(port_name)
            numa_cpus = self.terminal_server.send_command(cmd)
        return numa_num, numa_cpus

    def nic_check_net_offload(self, port_list, param, expect, tc=False):
        """
        :param tc: 默认查询本端，查询对端入参tc=True
        :description：检查sut网卡offload参数值
        :param port_list: (INT)传入网口列表
        :param param: (INT)传入想要查询的offload的参数名称(gso|tso|ufo|gro|lro
        |rx|tx|rxvlan|txvlan|ntuple|rxhash|rx-gro-hw)
        :param expect:(INT)预期的结果(on|off)
        :return:NULL
        :example：nic_check_net_offload（'eno1','gso','on'）
        """
        fail_list = []
        param_list = configs_network.OFFLOAD_PARAMS
        if param in param_list.keys():
            for port in port_list:
                cmd = "ethtool -k %s |grep %s |awk '{print $2}'" % (port, param_list.get(param))
                if tc:
                    result = self.terminal_client.send_command(cmd)
                else:
                    result = self.terminal_server.send_command(cmd)
                if result == expect:
                    msg_center.info("check {} {} {} pass".format(port, param, expect))
                    continue
                else:
                    msg_center.error("check {} {} {} fail".format(port, param, expect))
                    fail_list.append(port)
            if len(fail_list) == 0:
                msg_center.info("all port_list check {} pass".format(param))
                return True
            else:
                msg_center.error("{} check {} fail".format(fail_list, param))
                return False
        else:
            msg_center.error("param is not support, please check ,param support gso/tso/gro..")
            return False

    @staticmethod
    def nic_check_net(command, port_list, expect, tc=False):
        """
        Description ：查询网卡模块信息是否与预期一致
        Examples ：
        nic_check_net('num','[eno1]','1')
        nic_check_net('link','[eno1]','yes')
        nic_check_net('speed','[eno1]','100000')
        nic_check_net('stat','[eno1]','UP/DOWN')
        nic_check_net('driver','[eno1]','hns3')
        :param tc: 默认查询本端，查询对端入参tc=True
        :param command: (INT)需要查询网卡的模块信息(num/link/speed/stat/drive)(必要参数）
        :param port_list：(INT)需要查询的网口列表（必要参数）
        :param expect: (INT)预期的与模块对应的查询信息（必要参数）
        :return :
        """
        key_list = ["num", "link", "speed", "stat", "driver"]
        for i in key_list:
            if i in command:
                func_name = "nic_check_" + i
                result = eval(func_name)(port_list, expect, tc=tc)
                if result == 0:
                    msg_center.info("check {} success!".format(i))
                    return True
                else:
                    msg_center.error("check {} fail!".format(i))
                    return False
        msg_center.error("no such command,only support num/link/speed/stat/drive")
        return False

    @staticmethod
    def nic_check_num(port_list, expect, tc=False):
        check_point = 0
        check_num = len(port_list)
        if check_num == int(expect):
            if tc:
                msg_center.info("tc port_list check num is expectations,success")
            else:
                msg_center.info("sut port_list check num is expectations,success")
        else:
            msg_center.error("check num is not expectations,fail")
            check_point += 1
        return check_point

    def nic_check_link(self, port_list, expect, tc=False):
        check_point = 0
        for port_name in port_list:
            cmd = "ethtool {0} |grep -i 'Link detected' |grep {1}".format(port_name, expect)
            if tc:
                res = self.terminal_client.send_command(cmd)
            else:
                res = self.terminal_server.send_command(cmd)
            if expect in res:
                msg_center.info("check link is expectations,success")
            else:
                msg_center.error("{} check link is not expectations,fail".format(port_name))
                check_point += 1
        return check_point

    def nic_check_speed(self, port_list, expect, tc=False):
        check_point = 0
        for port_name in port_list:
            cmd = "ethtool {0} |grep -i 'Speed' |grep {1}".format(port_name, expect)
            if tc:
                res = self.terminal_client.send_command(cmd)
            else:
                res = self.terminal_server.send_command(cmd)
            if expect in res:
                msg_center.info("{} check speed is expectations,success".format(port_name))
            else:
                msg_center.error("{} check speed is not expectations,fail".format(port_name))
                check_point += 1
        return check_point

    def nic_check_stat(self, port_list, expect, tc=False):
        check_point = 0
        for port_name in port_list:
            cmd = "ip a |grep {0} |grep -i 'State {1}'".format(port_name, expect)
            if tc:
                res = self.terminal_client.send_command(cmd)
            else:
                res = self.terminal_server.send_command(cmd)
            if f"State {expect}" in res:
                msg_center.info("{} check stat is expectations,success".format(port_name))
            else:
                msg_center.error("{} check stat is not expectations, fail".format(port_name))
                check_point += 1
        return check_point

    def nic_check_driver(self, port_list, expect, tc=False):
        check_point = 0
        for port_name in port_list:
            cmd = "ethtool -i {0} |grep -i 'driver' |grep {1}".format(port_name, expect)
            if tc:
                res = self.terminal_client.send_command(cmd)
            else:
                res = self.terminal_server.send_command(cmd)
            if expect in res:
                msg_center.info("{} check driver is expectations,success".format(port_name))
            else:
                msg_center.error("{} check driver is not expectations,fail".format(port_name))
                check_point += 1
        return check_point

    def nic_add_vlan(self, port_list, vlan_id, vlan_num=1, tc=False):
        """
        添加vlan
        :param port_list:输入的网口名列表
        :param vlan_id: 第一个vlan的vlanid(int)
        :param vlan_num: vlan的数量(int)
        :param tc: 本对端
        :return: vlan名列表
        """
        if tc == False:
            handle = self.terminal_server
        elif tc == True:
            handle = self.terminal_client
        else:
            msg_center.error("Please enter a correct parameter！")
            assert False
        # 遍历所有传入的网口
        vlan_add_list = []
        vlan_port_list = []
        for port_name in port_list:
            # 判断网口长度
            if len(port_name) >= 10:
                vlan_port = port_name[-10:]
            else:
                vlan_port = port_name
            for i in range(vlan_num):
                # 逐个添加vlan
                vlan_name = vlan_port + "." + str(vlan_id + i)
                cmd = f"ip link add dev {vlan_name} link {port_name} type vlan id {vlan_id + i}"
                handle.send_command(cmd)
                vlan_add_list.append(vlan_name)
        # 需要排除系统原本就有的vlan
        ret_info = handle.send_command("ip a |grep @ | grep -v @NONE |awk '{print $2}' |awk -F '@' '{print $1}'",
                                       disable_show_and_log=True)
        for vlan in vlan_add_list:
            if vlan in ret_info:
                vlan_port_list.append(vlan)
            else:
                msg_center.error(f"添加vlan口{vlan}失败！")
                assert False
        # 返回添加的vlan网口列表
        return vlan_port_list

    @staticmethod
    def nic_check_link_up(port_name, timeout_value=5, link_status="yes", terminal_ssh=hns_global.server_ssh):
        """
        检查网口当前网络状态
        :param port_name:输入的网口名称
        :param timeout_value:超时时间（int），每秒检查一次
        :param link_status:预期网口状态（str）
        :return:
        """
        for check_up_times in range(timeout_value):
            speed_tmp = knet.Eth(port_name, terminal=terminal_ssh).get_speed()
            link_status_tmp = knet.Eth(port_name, terminal=terminal_ssh).get_linkstat()
            if link_status_tmp == link_status and speed_tmp != "Unknown!" and speed_tmp != "0":
                msg_center.info("{} link is up,time {} sec".format(port_name, check_up_times))
                return True
            elif link_status_tmp == link_status:
                msg_center.info("{} link is up,time {} sec".format(port_name, check_up_times))
                return True
            else:
                time.sleep(1)
        msg_center.error("{} network status check fail".format(port_name))
        return False

    def nic_get_sut_onboard_port_list(self, port_type):
        """
        获取符合要求的网口列表
        :param port_type:网口类型：fibre(光口)、tp(电口)、25G_fibre(25G)、100G_fibre(100G)、82599、i350、mlx、HI1822
        :return: port_list：网口名列表，bus_info：bus号列表
        """
        # 将入参全部转为小写，统一格式
        global ip_segment
        port_type = port_type.lower()
        port_name_list = []
        port_businfo_list = []
        port_type_list = ["tp", "fibre", "25g_fibre", "100g_fibre", "i350", "82599", "mlx", "hi1822", "x550"]
        port_list_temp = []
        port_driver = {"i350": "igb", "82599": "ixgbe", "mlx": "mlx5_core", "hi1822": "hinic", "x550": "ixgbe"}
        # 判断入参是否符合规范
        if port_type not in port_type_list:
            return False
        cmd = "ip a |grep -i state |awk '{print$2}'|tr -d :"
        port_list_temp_all = self.terminal_server.send_command(cmd, disable_show_and_log=True).split()
        port_list_temp_all.remove("lo")
        if port_type in ["tp", "fibre", "25g_fibre", "100g_fibre"]:
            for port_name in port_list_temp_all:
                cmd = "ethtool -i {} | grep 'driver: hns'".format(port_name)
                res = self.terminal_server.send_command(cmd, disable_show_and_log=True)
                if 'driver: hns' in res:
                    port_list_temp.append(port_name)
            msg_center.info(f"本端获取到port_list_temp(即'driver: hns'口):{port_list_temp}")

            for port_name in port_list_temp:
                port_ethtool = self.terminal_server.send_command("ethtool {}".format(port_name),
                                                                 disable_show_and_log=True)
                if "Link detected: yes" not in port_ethtool:
                    msg_center.error(f"本端{port_name}非link up状态，无需继续执行！")
                    continue
                # 新增判断对端是否板载网口，针对板载对接标卡的情况
                # 获取本端网口的网段
                this_ip = sys_base_info.fn_get_ip_by_port(port_name)
                if this_ip:
                    ip_segment = ".".join(this_ip.split(".")[:-1])
                else:
                    msg_center.error("本端{0}口无ip，无需继续执行！ ".format(port_name))
                    continue
                # 通过网段获取对端ip
                tc_ip_commd = f"ip a | grep inet | grep '{ip_segment}.' | awk '{{print $2}}' | cut -d '/' -f 1"
                tc_ip = self.terminal_client.send_command(tc_ip_commd, disable_show_and_log=True)
                # 获取对端网口名
                tc_port_name_commd = "ip a | grep %s |awk '{print $NF}'" % tc_ip
                tc_port_name = self.terminal_client.send_command(tc_port_name_commd, disable_show_and_log=True)
                tc_device_info = self.terminal_client.send_command(f"ethtool -i {tc_port_name}",
                                                                   disable_show_and_log=True)
                if 'driver: hns' not in tc_device_info:
                    msg_center.error(f"对端{tc_port_name}非hns口，无需继续执行！")
                    continue
                # 遍历所有网口，筛选出符合要求的网口
                if port_type == "tp":
                    if "TP" in port_ethtool:
                        port_name_list.append(port_name)
                if port_type == "fibre":
                    # 普通光口不支持100000baseCR/Full和25000baseCR/Full
                    if "FIBRE" in port_ethtool:
                        port_name_list.append(port_name)
                if port_type == "25g_fibre":
                    # 普通光口不支持100000baseCR/Full和25000baseCR/Full
                    if "FIBRE" in port_ethtool and "Speed: 25000Mb/s" in port_ethtool:
                        port_name_list.append(port_name)
                if port_type == "100g_fibre":
                    # 100G扣卡为光口还要支持100000baseCR/Full
                    if "FIBRE" in port_ethtool and "Speed: 100000Mb/s" in port_ethtool:
                        port_name_list.append(port_name)
            msg_center.info(f"获取到port_name_list:{port_name_list}")
        else:
            for port_name in port_list_temp_all:
                port_ethtool = self.terminal_server.send_command("ethtool {}".format(port_name),
                                                                 disable_show_and_log=True)
                if "Link detected: yes" not in port_ethtool:
                    continue
                port_ethtool_i = self.terminal_server.send_command("ethtool -i {}".format(port_name),
                                                                   disable_show_and_log=True)
                if port_type not in ["82599", "x550"]:
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i:
                        port_name_list.append(port_name)
                elif port_type == "82599":
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i and "FIBRE" in port_ethtool:
                        port_name_list.append(port_name)
                elif port_type == "x550":
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i and "TP" in port_ethtool:
                        port_name_list.append(port_name)
            msg_center.info(f"获取到port_name_list:{port_name_list}")
        for port_name in port_name_list:
            # 遍历每个网口获取其bus号
            cmd = "ethtool -i %s | grep 'bus-info' | awk '{print $NF}' | sed 's/ //g'" % port_name
            port_businfo = self.terminal_server.send_command(cmd, disable_show_and_log=True)
            port_businfo_list.append(port_businfo)
        return port_name_list, port_businfo_list

    def nic_set_autoneg(self, port_name_list, neg_type, tc=False):
        """
        设置本端网口自协商
        :param port_name_list: 传入网口名称列表
        :param neg_type: 自协商协商on/off
        :return: bool
        """
        # 判断自协商类型是否符合规则
        if neg_type not in ["on", "off"]:
            msg_center.error("neg type is wrong,should be on or off")
            return False
        # 判断传入网口列表是否为空
        elif len(port_name_list) == 0:
            msg_center.error("port_name_list is null")
            return False
        else:
            for port_name in port_name_list:
                # 命令是否执行成功
                cmd = "ethtool -s {0} autoneg {1}".format(port_name, neg_type)
                if tc:
                    self.terminal_client.send_command(cmd)
                    if self.terminal_client.ret_code != 0:
                        msg_center.error("{0} command exec error".format(port_name))
                        return False
                else:
                    self.terminal_server.send_command(cmd)
                    if self.terminal_server.ret_code != 0:
                        msg_center.error("{0} command exec error".format(port_name))
                        return False
            # 所有网口设置完毕，等待指定时间后，检查是否达到预期
            time.sleep(configs_network.NETWORK_RESTART_TIME)
            for port_name in port_name_list:
                cmd = "ethtool %s | grep Auto-negotiation|awk '{print $2}'" % port_name
                if tc:
                    type_tmp = self.terminal_client.send_command(cmd)
                else:
                    type_tmp = self.terminal_server.send_command(cmd)
                if type_tmp == neg_type:
                    msg_center.info("{0} set neg {1} pass".format(port_name, neg_type))
                else:
                    msg_center.error("{0} set neg {1} fail".format(port_name, neg_type))
                    return False
        return True

    def nic_set_mtu(self, port_list, mtu_set=0, tc=False):
        """
        设置本端或者对端的mtu值
        :param tc:默认设置版本，需要设置对端时候，带参tc=True
        :param port_list:入参，本端网口名列表
        :param mtu_set:入参，待设置的mtu值
        :return:bool
        """
        check_point = 0
        if len(port_list) == 0 or mtu_set == 0:
            msg_center.error("invalid input, test fail.")
            return False
        else:
            for i in port_list:
                if tc:
                    set_result = knet.Eth(i, terminal=self.terminal_client).config_mtu(mtu_set)
                else:
                    set_result = knet.Eth(i, terminal=self.terminal_server).config_mtu(mtu_set)
                if set_result != 0:
                    msg_center.error(
                        "eth {0} set mut:{1} test fail".format(i, mtu_set))
                    check_point += 1
                else:
                    msg_center.info("eth {0} set mut to {1} success!".format(i, mtu_set))
        if check_point == 0:
            return True
        else:
            return False

    def nic_set_both_mtu_check(self, sut_port, tc_port, mtu_set=0):
        """
        设置本端和对端的mtu值并检查是否设置成功
        :param sut_port:入参，本端网口名
        :param tc_port:入参，对端网口名
        :param mtu_set:入参，待设置的mtu值
        :return:bool
        """
        ret1 = self.nic_set_mtu([sut_port], mtu_set, tc=False)
        ret2 = self.nic_check_mtu(sut_port, mtu_set, tc=False)
        ret3 = self.nic_set_mtu([tc_port], mtu_set, tc=True)
        ret4 = self.nic_check_mtu(tc_port, mtu_set, tc=True)
        ret5 = self.nic_check_link_up(sut_port)
        ret6 = self.nic_check_link_up(tc_port, terminal_ssh=hns_global.client_ssh)
        for check_ret in [ret1, ret2, ret3, ret4, ret5, ret6]:
            if check_ret == False:
                return False
        return True

    def nic_up_down_net(self, port_list, times=1, tc=False):
        """
        复位port_list中的网口times次
        :param tc:默认本端，对端操作入参tc=Ture
        :param port_list: 入参，待复位的网口列表
        :param times: 入参，复位次数，必须大于1次
        :return: bool
        """
        if len(port_list) == 0:
            msg_center.error("invalid port_list, test fail.")
            return False
        for port_tmp in port_list:
            for i in range(times):
                if tc:
                    knet.Eth(port_tmp, terminal=self.terminal_client). \
                        config_link_status(status="down", sleep_t=configs_network.NETWORK_RESTART_TIME)
                    knet.Eth(port_tmp, terminal=self.terminal_client). \
                        config_link_status(status="up", sleep_t=configs_network.NETWORK_RESTART_TIME)
                    if knet.Eth(port_tmp, terminal=self.terminal_client).get_linkstat() == "no":
                        msg_center.error("round {}, {} up failed".format(i, port_tmp))
                        return False
                else:
                    knet.Eth(port_tmp, terminal=self.terminal_server). \
                        config_link_status(status="down", sleep_t=configs_network.NETWORK_RESTART_TIME)
                    knet.Eth(port_tmp, terminal=self.terminal_server). \
                        config_link_status(status="up", sleep_t=configs_network.NETWORK_RESTART_TIME)
                    self.terminal_server.send_command(f"ifup {port_tmp}")
                    time.sleep(3)
                    if knet.Eth(port_tmp, terminal=self.terminal_server).get_linkstat() == "no":
                        msg_center.error("round {}, {} up failed".format(i, port_tmp))
                        return False
            msg_center.info("up & down {0} for {1} times!".format(port_tmp, times))
        return True

    def nic_up_down_net_exceptip(self, ip_except, port_list, times=1):
        """
        up/down port_list中的网口times次，除ip_expect之外
        :param ip_except:入参，不对这个ip执行up/down操作，调用者确保该ip存在且合法
        :param port_list:入参，待up/down的网口列表
        :param times: 入参，up/down次数，必须>=1次
        :return:bool
        """
        if len(port_list) == 0:
            msg_center.error("invalid port_list, test fail.")
            return False
        # 根据ip地址获取网口名字
        nic_except = sys_base_info.fn_get_port_name([ip_except])
        # 生成执行up/down操作的网口名列表
        if nic_except and nic_except[0] in port_list:
            port_list.remove(nic_except[0])
        # 执行up/down操作
        ret = self.nic_up_down_net(port_list, times)
        return ret

    def nic_check_mtu(self, nic_port_name, mtu_expect, tc=False):
        """
        检查网口的mtu值是否和预期的一致
        :param tc: 默认本端，查询对端入参tc=True
        :param nic_port_name: 入参，网口名
        :param mtu_expect:入参，mtu预期值
        :return:bool
        """
        if tc:
            mtu_get = knet.Eth(nic_port_name, terminal=self.terminal_client).get_mtu()
        else:
            mtu_get = knet.Eth(nic_port_name, terminal=self.terminal_server).get_mtu()
        if mtu_expect == mtu_get:
            msg_center.info("{0} mtu is {1}, check pass!".format(nic_port_name, mtu_expect))
            return True
        else:
            msg_center.error(
                "{0} mtu is {1}, while expect is {2}, test fail.".format(nic_port_name, mtu_get, mtu_expect))
            return False

    def nic_set_mac(self, nic_name, nic_mac, tc=False):
        """
        传入需要更改的网口名和更改之后的MAC地址，更改
        :param tc: 默认本端，设置对端入参tc=True
        :param nic_name:需要更改的网口名
        :param nic_mac:需要更改的mac地址
        :return:bool
        """
        if tc:
            set_result = knet.Eth(nic_name, terminal=self.terminal_client).config_mac(nic_mac)
        else:
            set_result = knet.Eth(nic_name, terminal=self.terminal_server).config_mac(nic_mac)
        if set_result == 0:
            msg_center.info("The mac_address is modified successfully")
            return True
        else:
            msg_center.error("The mac_address fails to be modified")
            return False

    def nic_check_mac(self, nic_name, tc=False):
        """
        传入网口名字，查询其mac地址
        :param tc: 默认查询本端，查询对端入参tc=True
        :param nic_name:需要查询的网口名
        :return:mac
        """
        if tc:
            get_mac = knet.Eth(nic_name, terminal=self.terminal_client).get_mac()
        else:
            get_mac = knet.Eth(nic_name, terminal=self.terminal_server).get_mac()
        return get_mac

    def nic_set_ip(self, nic_name, address_ip, mask, tc=False):
        """
        指定网口设定ip和掩码
        :param tc:默认设置本端。设置对端入参tc=True
        :param nic_name:网口名
        :param address_ip:待设定的ip地址
        :param mask:待设定的掩码
        :return:bool
        """
        if tc:
            set_result = knet.Eth(nic_name, terminal=self.terminal_client).add_ip(address_ip, mask=mask)
        else:
            set_result = knet.Eth(nic_name, terminal=self.terminal_server).add_ip(address_ip, mask=mask)
        if set_result == 0:
            msg_center.info("The IP address is changed successfully")
            return True
        else:
            msg_center.info("The IP address is changed fail")
            return False

    def nic_clear_atr(self, port_name, tc=False):
        """
        清除ATR规则
        :param tc: 默认本端，对端入参tc=True
        :param port_name:需要清除规则的网口名
        :return: none
        """
        # 全局rps_sock_flow_entries值归零，关闭ATR功能
        cmd = "ethtool -l %s | grep Combined | awk '{print $NF}' | tail -1" % port_name
        if tc:
            self.terminal_client.send_command("echo 0 > /proc/sys/net/core/rps_sock_flow_entries")
            port_queues = int(self.terminal_client.send_command(cmd))
        else:
            self.terminal_server.send_command("echo 0 > /proc/sys/net/core/rps_sock_flow_entries")
            port_queues = int(self.terminal_server.send_command(cmd))
        # 局部rps_flow_cnt值归零，关闭ATR功能
        for i in range(port_queues):
            cmd = "echo 0 > /sys/class/net/%s'/'queues/rx-%d/rps_flow_cnt" % (port_name, i)
            if tc:
                self.terminal_client.send_command(cmd)
            else:
                self.terminal_server.send_command(cmd)

    def nic_set_net_offload(self, port_list, param_name, on_off, tc=False):
        """
        打开关闭本端的offload属性
        :param tc: 默认设置本端，设置对端时入参tc=True
        :param port_list: 入参，输入的网口名列表
        :param param_name: 入参，要修改的offload属性，字符串类型，取值范围：gso|tso|ufo|gro|lro
        |rx|tx|rxvlan|txvlan|ntuple|rxhash|rx-gro-hw
        :param on_off:入参，要修改成的状态，on或者off
        :return:bool
        """
        param_list = configs_network.OFFLOAD_PARAMS
        if len(port_list) == 0:
            msg_center.error("invalid port_list, test fail.")
            return False
        if param_name not in param_list.keys():
            msg_center.error("invalid param_name, test fail.")
            return False
        if on_off != 'on' and on_off != 'off':
            msg_center.error("invalid on_off, test fail.")
            return False
        # 设置
        for i in port_list:
            if tc:
                self.terminal_client.send_command("ethtool -K {0} {1} {2}".format(i, param_name, on_off))
            else:
                self.terminal_server.send_command("ethtool -K {0} {1} {2}".format(i, param_name, on_off))
            msg_center.info("set: ethtool -K {0} {1} {2}".format(i, param_name, on_off))
        # 查询，调用nic_check_net_offload函数
        ret = self.nic_check_net_offload(port_list, param_name, on_off, tc=tc)
        if ret:
            msg_center.info("set & get net offload {0} success.".format(param_name))
            return True
        else:
            msg_center.error("set & get net offload {0} fail.".format(param_name))
            return False

    def nic_env_reset_sut(self, port_list):
        """
        设置本端网卡默认参数，包括mtu，ethtool -k的offload属性等
        :param port_list:入参，输入的网口名列表
        :return:bool
        """
        check_point = 0
        if len(port_list) == 0:
            msg_center.error("invalid port_list, test fail.")
            return False
        else:
            ret = self.nic_set_mtu(port_list, 1500)
            if not ret:
                msg_center.error("nic_set_mtu {0} {1} fail.".format(port_list, 1500))
                check_point += 1
            offload_list = {
                "gro": "on",
                "rx-gro-hw": "on",
                "gso": "on",
                "tso": "on",
            }
            for i in offload_list:
                ret = self.nic_set_net_offload(port_list, i, offload_list.get(i))
                if not ret:
                    msg_center.error(
                        "nic_set_net_offload {0} {1} {2} fail.".format(port_list, i, offload_list.get(i)))
                    check_point += 1
        if check_point == 0:
            return True
        else:
            return False

    def nic_choose_mac(self, nic_name):
        """
        根据输入的网口名字，找到一个本端和对端都未占用的mac地址
        :param nic_name:入参，网口名字
        :return:一个本端及对端都未占用的mac地址
        """
        nic_mac = self.nic_check_mac(nic_name)
        msg_center.info("get mac addr: {0}".format(nic_mac))
        nic_mac_head = nic_mac[0:-2]
        for nic_mac_end in range(99, -1, -1):
            nic_mac_new = nic_mac_head + str(nic_mac_end).zfill(2)
            # 判断新生成的mac地址是否在本端和对端存在
            ret_sut = self.terminal_server.send_command("ip a | grep {0}".format(nic_mac_new))
            ret_tc = self.terminal_client.send_command("ip a | grep {0}".format(nic_mac_new))
            if ret_sut == "" and ret_tc == "":
                msg_center.info("find mac addr: {0} available!".format(nic_mac_new))
                return nic_mac_new
        msg_center.info("no available mac get!")
        return False

    def nic_add_bond_sut(self, port_name_list, bond_type_num, bond_ip):
        """
        非修改配置文件的方式添加bond
        :param port_name_list:传入待添加bond的网口列表 （必须参数）
        :param bond_type_num:the type of bond (0:balance_rr|1:active-backup) （必须参数）
        :param bond_ip:需要设置的bond ip （必须参数）
        :return:bool
        """
        # ubuntu系统需安装ifenslave
        install_tmp = sys_env_init.fn_install_ifenslave()
        if not install_tmp:
            return False
        # 判断传入bond type num，选择对应类型
        if bond_type_num == 0:
            bond_type = "balance-rr"
        elif bond_type_num == 1:
            bond_type = "active-backup"
        else:
            msg_center.error("param error: bond_type_num should be 0 or 1")
            return False
        # 添加bond
        cmd = "ip link add bond{0} type bond mode {1}".format(bond_type_num, bond_type)
        self.terminal_server.send_command(cmd)
        ret = self.terminal_server.send_command("ip a| grep bond{0}".format(bond_type_num))
        if len(ret) > 0:
            # 网口设置bond 负载均衡或主备模式
            for port_name in port_name_list:
                self.terminal_server.send_command("ip link set dev {0} down".format(port_name))
                self.terminal_server.send_command(
                    "ip link set dev {0} master bond{1}".format(port_name, bond_type_num))
                self.terminal_server.send_command("ip link set dev {0} up".format(port_name))
                # 判断网口添加bond是否成功
                ret1 = self.terminal_server.send_command(
                    "ip a| grep {0}| grep bond{1}".format(port_name, bond_type_num))
                if len(ret1) == 0:
                    msg_center.error("{0} set bond fail".format(port_name))
                    return False
        else:
            msg_center.error("ip link add bond fail")
            return False
        # 网口bond模式添加成功后，bond设置IP
        self.terminal_server.send_command("ip addr add {0}/24 dev bond{1}".format(bond_ip, bond_type_num))
        ret = self.terminal_server.send_command("ip a| grep bond{0}| grep {1}/24".format(bond_type_num, bond_ip))
        if len(ret) > 0:
            msg_center.info("bond set ip pass")
            self.terminal_server.send_command("ip link set dev bond{0} up".format(bond_type_num))
            return True
        else:
            msg_center.error("bond set ip fail")
            return False

    def nic_remove_bond_sut(self, bond_name=""):
        """
        删除本端bond
        :param bond_name:传入需要删除的bond名字 （非必须参数）
        :return:
        """
        # 如果传入bond 名字，就删除指定名字bond。如没有传参，就默认寻找bond开头的 bond网口名
        if len(bond_name) != 0:
            bond_name_tmp = bond_name
        else:
            bond_name_tmp = "bond"
            msg_center.info("Bond name not given,will use default bond name: bond*")
        cmd = "ip a | egrep %s| egrep -v inet| awk -F': ' 'END{print $2}'" % bond_name_tmp
        bond_name_del = self.terminal_server.send_command(cmd)
        # 如果没传参，且没有bond开头的网口名，认为当前环境没有bond需要删除
        if len(bond_name_del) == 0:
            msg_center.info(
                "There is no bond named or prefix:{} to remove,ignore it".format(bond_name_tmp))
            return True
        # 删除bond
        self.terminal_server.send_command("ip link del dev {0}".format(bond_name_del))
        if not self.terminal_server.send_command("ip a| egrep {0}".format(bond_name_del)):
            msg_center.info("{} removed pass".format(bond_name_del))
            return True
        else:
            msg_center.error("{} removed fail".format(bond_name_del))
            return False

    def nic_query_vlan(self, port_name_list, vlan_id, expect_value="yes"):
        """
        判断传入的vlan id是否存在，存在返回True，不存在返回Fail
        :param port_name_list:网口名列表
        :param vlan_id:vlan id
        :param expect_value:预期结果，yes(有)，no(没有)
        :return:bool
        """
        port_name_fail = []
        for port_name in port_name_list:
            cmd = "ip a | grep -w {0} |grep -w {1} |grep -v '^{1}'".format(port_name, vlan_id)
            vlan_result = self.terminal_server.send_command(cmd)
            # CI_LOG打印加上预期
            msg_center.info("sut vlan info : {}".format(vlan_result))
            if vlan_result != "" and expect_value == "no":
                port_name_fail.append(port_name)
            elif vlan_result == "" and expect_value == "yes":
                port_name_fail.append(port_name)
        if len(port_name_fail) == 0:
            msg_center.info("check vlan {0} {1} pass".format(port_name_list, vlan_id))
            return True
        else:
            msg_center.error(
                "check vlan {0} {1} fail in {2}".format(port_name_fail, vlan_id, port_name_list))
            return False

    def nic_check_net_drop_error(self, nic_name, tc=False):
        """
        根据传入的网口名查找其接收与发送对应的丢包和错包的情况,并将结果传入到字典中
        :param nic_name:需要查询的网口名
        :return:dirt
        """
        check_nic = {}
        rx_check_errors = kdevinfo.EthDevice(nic_name, terminal=self.terminal_server).statistics.rx_errors
        msg_center.info("rx_check_errors:{}".format(rx_check_errors))
        check_nic['rx_errors'] = rx_check_errors
        rx_check_dropped = kdevinfo.EthDevice(nic_name, terminal=self.terminal_server).statistics.rx_dropped
        msg_center.info("rx_check_dropped:{}".format(rx_check_dropped))
        check_nic['rx_dropped'] = rx_check_dropped
        tx_check_errors = kdevinfo.EthDevice(nic_name, terminal=self.terminal_server).statistics.tx_errors
        msg_center.info("tx_check_errors:{}".format(tx_check_errors))
        check_nic['tx_errors'] = tx_check_errors
        tx_check_dropped = kdevinfo.EthDevice(nic_name, terminal=self.terminal_server).statistics.tx_dropped
        msg_center.info("tx_check_dropped:{}".format(tx_check_dropped))
        check_nic['tx_dropped'] = tx_check_dropped
        return check_nic

    def nic_ping_test(self, ip_addr_tc, loss=False):
        """
        测试能否ping通对端的IP
        :param loss: 是否允许丢部分包，loss=False为不允许丢包，loss=True 为ping通即可，允许部分丢包
        :param ip_addr_tc: 输入对端的IPV6地址
        :return:bool
        """
        ping_result = knet.Eth("lo", terminal=self.terminal_server).ping_ip(ip_addr_tc, loss)
        if ping_result == 0:
            msg_center.info("The IP address is conneted successfully")
            return True
        else:
            msg_center.error("Failed to conneted the IP address,please check the environment")
            return False

    def nic_del_vf(self, port_list_sut):
        """
        删除本端和对端的vf，即 echo 0 > /sys/class/net/ethx/device/sriov_numvfs
        :param port_list_sut:入参，本端需要删除vf的网口名列表
        :return:bool
        """
        check_point = 0
        if len(port_list_sut) == 0:
            msg_center.error("invalid port_list, test fail.")
            return False
        os_name_tmp = sys_base_info.fn_get_os_name()
        cmd_vfbus = "lspci |grep -i 'Virtual Function' |awk '{print $1}'"
        if os_name_tmp == "centos":
            try:
                for name_tmp in CENTOS_VF_NAME:
                    # 当前使用日构建镜像为centos7.6版本，重启使用service network.service restart,centos8.0以上版本使用NetworkManager
                    self.terminal_server.send_command(f"nmcli con delete {name_tmp}")
                tc_vf_buslist = self.terminal_client.send_command(cmd_vfbus).split()
                if len(tc_vf_buslist) == 0:
                    msg_center.info(f"TC no need to delete VF!")
                else:
                    for bus_tmp in tc_vf_buslist:
                        vf_name = self.terminal_client.send_command(f"ls /sys/bus/pci/devices/0000:{bus_tmp}/net")
                        self.terminal_client.send_command(f"nmcli con delete {vf_name}")
            except NameError:
                pass
            finally:
                pass
        elif os_name_tmp == 'openeuler':
            try:
                for name_tmp in CENTOS_VF_NAME:
                    self.terminal_server.send_command(f"nmcli con delete {name_tmp}")
                    tc_vf_buslist = self.terminal_client.send_command(cmd_vfbus).split()
                    if len(tc_vf_buslist) == 0:
                        msg_center.info(f"TC no need to delete VF!")
                    else:
                        for bus_tmp in tc_vf_buslist:
                            vf_name = self.terminal_client.send_command(f"ls /sys/bus/pci/devices/0000:{bus_tmp}/net")
                            self.terminal_client.send_command(f"nmcli con delete {vf_name}")
            except NameError:
                pass
            finally:
                pass
        for i in port_list_sut:
            # 1、删除本端vf
            sriov_num = self.terminal_server.send_command(f"cat /sys/class/net/{i}/device/sriov_numvfs")
            if int(sriov_num) == 0:
                msg_center.info(f"{i} get sriov_numvfs 0, no need to delete VF!")
            else:
                self.terminal_server.send_command(f"echo 0 > /sys/class/net/{i}/device/sriov_numvfs")
                time.sleep(configs_network.NETWORK_RESTART_TIME)
                sriov_num = self.terminal_server.send_command(f"cat /sys/class/net/{i}/device/sriov_numvfs")
                if int(sriov_num) == 0:
                    msg_center.info(f"{i} set & get sriov_numvfs: {sriov_num}, VF is deleted.")
                else:
                    msg_center.error(
                        f"{i} set sriov_numvfs to 0, while get is: {sriov_num}, VF delete fail.")
                    check_point += 1

            # 2、删除对端vf，根据ip网段获取对端的网口名列表，然后像本端那样操作删除vf
            # 根据网口名字获取ip地址
            ip_sut = sys_base_info.fn_get_ip_by_port(i)
            if not ip_sut:
                msg_center.info(f"{i} doesn't have an ip addr, go to next port!")
                continue
            else:
                # 根据ip地址提取ip网段，例如192.168.20.12的网段是192.168.20
                ip_sut_tmp = ip_sut.split(".")
                ip_sut_tmp = ip_sut_tmp[0:-1]
                network_seg = ".".join(ip_sut_tmp)
                msg_center.info(f"ip: {ip_sut}, network_seg is: {network_seg}")
                # 查找对端是否有同网段的ip，并根据ip地址获取对端的网口名
                cmd = "ip a | grep 'inet' | grep -w %s | awk '{print $NF}'" % network_seg
                port_tc = self.terminal_client.send_command(cmd)
                # 执行删除vf操作
                cmd = f"cat /sys/class/net/{port_tc}/device/sriov_numvfs"
                sriov_num_tc = self.terminal_client.send_command(cmd)
                if not sriov_num_tc:
                    msg_center.info("connect to tc fail.")
                elif int(sriov_num_tc) == 0:
                    msg_center.info(
                        f"[tc] {network_seg}.xx: {port_tc} get sriov_numvfs 0, no need to delete VF!")
                else:
                    msg_center.info(
                        f"[tc] {network_seg}.xx: {port_tc} get sriov_numvfs: {sriov_num_tc}, now set it to 0")
                    self.terminal_client.send_command(f"echo 0 > /sys/class/net/{port_tc}/device/sriov_numvfs")
                    time.sleep(configs_network.NETWORK_RESTART_TIME)
                    cmd = f"cat /sys/class/net/{port_tc}/device/sriov_numvfs"
                    sriov_num_tc = self.terminal_client.send_command(cmd)
                    if not sriov_num_tc:
                        pass
                    elif int(sriov_num_tc) == 0:
                        msg_center.info(
                            f"[tc] {network_seg}.xx: {port_tc} set & get sriov_numvfs: {sriov_num_tc}, VF is deleted.")
                    else:
                        msg_center.error(
                            f"[tc] {network_seg}.xx: {port_tc} set sriov_numvfs to 0, while get is: {sriov_num_tc}, VF delete fail.")
                        check_point += 1
        if check_point == 0:
            return True
        else:
            return False

    def nic_create_vf_sut(self, port_list_sut, num):
        """
        本端创建vf并设置ip，最多支持245个，返回VF网口名和对应的IP列表
        :param port_list_sut:(INT)传入本端需要创建vf的网口数组
        :param num:(INT)传入每个网口需要创建的vf的个数
        :param sut_vf_port_list: (OUT)返回sut_vf的网口数组列表
        :param sut_vf_ip_list: (OUT)返回sut_vf_ip的ip数组列表
        :return:sut_vf_port_list、sut_vf_ip_list
        """
        fail_list = []
        sut_vf_ip_list = []
        sut_vf_port_list = []
        # vf的ip规则：从172.201.10.3开始，对第3个网段自增，到172.201.256.3结束
        sut_vf_ip_part = 10
        sut_vf_rang_start = '172.201.'
        sut_vf_rang_end = '.3'
        os_name_tmp = sys_base_info.fn_get_os_name()
        global CENTOS_VF_NAME
        for port in port_list_sut:
            msg_center.info("**************Start sut {} create vf**************".format(port))
            cmd = "ip a |grep -i state |awk '{print$2}'|tr -d :"
            port_list_before = self.terminal_server.send_command(cmd).split()
            self.terminal_server.send_command("echo {} > /sys/class/net/{}/device/sriov_numvfs".format(num, port))
            time.sleep(2)
            port_list_after = self.terminal_server.send_command(cmd).split()
            if len(port_list_before) == len(port_list_after):
                msg_center.error("sut vf create fail,port_list is consistent before and after")
                fail_list.append(port)
            for port_temp in port_list_before:
                if port_temp in port_list_after:
                    port_list_after.remove(port_temp)
            msg_center.info("sut {} vf port list: {}".format(port, port_list_after))
            for vf_port_temp in port_list_after:
                set_ip = sut_vf_rang_start + str(sut_vf_ip_part) + sut_vf_rang_end
                if os_name_tmp == "centos":
                    self.terminal_server.send_command(f"service NetworkManager restart")
                    self.terminal_server.send_command(
                        f"nmcli c add type ethernet con-name {vf_port_temp} ifname {vf_port_temp} ip4 {set_ip}/24")
                    self.terminal_server.send_command(f"nmcli c up {vf_port_temp}")
                elif os_name_tmp == "openeuler":
                    self.terminal_server.send_command(
                        f"nmcli c add type ethernet con-name {vf_port_temp} ifname {vf_port_temp} ip4 {set_ip}/24")
                    self.terminal_server.send_command(f"nmcli c up {vf_port_temp}")
                else:
                    self.terminal_server.send_command("ip addr add {}/24 dev {}".format(set_ip, vf_port_temp))
                    self.terminal_server.send_command("ip link set {} up".format(vf_port_temp))
                sut_vf_ip_list.append(set_ip)
                sut_vf_port_list.append(vf_port_temp)
                sut_vf_ip_part += 1
                msg_center.info("sut vf port:{} vf ip:{}".format(vf_port_temp, set_ip))
            msg_center.info("**************Finish sut {} create vf**************".format(port))
        msg_center.info("sut vf port:{}".format(sut_vf_port_list))
        msg_center.info("sut vf ip:{}".format(sut_vf_ip_list))
        if len(fail_list) == 0:
            CENTOS_VF_NAME = sut_vf_port_list
            return sut_vf_port_list, sut_vf_ip_list
        else:
            msg_center.error("sut port {} create vf fail".format(fail_list))
            return []

    def nic_create_vf_tc(self, port_list_tc, num):
        """
        :Description：对端创建vf并设置ip，最多支持245个
        :param port_list_tc: (INT)传入对端需要创建vf的网口数组
        :param num: (INT)传入每个网口需要创建的vf的个数
        :param tc_port_list: (OUT)返回sut_vf的网口数组列表
        :param tc_vf_ip_list: (OUT)返回sut_vf_ip的ip数组列表
        :return: vf_port_list_tc、vf_ip_list_tc
        :Example: nic_create_vf_set_ip_tc(eno1,1)
        """
        fail_list = []
        tc_vf_ip_list = []
        tc_vf_port_list = []
        # vf的ip规则：从172.201.10.6开始，对第3个网段自增，到172.201.256.6结束
        tc_vf_ip_part = 10
        tc_vf_rang_start = '172.201.'
        tc_vf_rang_end = '.6'
        os_name_tmp = sys_base_info.fn_get_os_name(tc=True)
        for port in port_list_tc:
            msg_center.info("**************Start tc {} create vf**************".format(port))
            self.terminal_client.send_command("modprobe hclgevf")
            port_list_before = self.terminal_client.send_command("ip a | grep state | grep -v lo |\
                 awk -F':' '{print $2}' | sed 's/ //g'").split("\n")
            self.terminal_client.send_command("echo {} > /sys/class/net/{}/device/sriov_numvfs".format(num, port))
            time.sleep(3)
            # 对端centos设备起最大数量的VF时进程较慢
            if os_name_tmp == "centos" and num == 7:
                self.terminal_client.send_command("ip a | grep {}".format(port))
                time.sleep(5)
                self.terminal_client.send_command("ip a | grep {}".format(port))
            msg_center.info(
                "this is fn double ssh show-------------------------{} {} ".format(num, port))
            port_list_after = self.terminal_client.send_command("ip a | grep state | grep -v lo |\
                 awk -F':' '{print $2}' | sed 's/ //g'").split("\n")
            if len(port_list_before) == len(port_list_after):
                msg_center.error("tc vf create fail,port_list is consistent before and after")
                fail_list.append(port)
            for port_temp in port_list_before:
                if port_temp in port_list_after:
                    port_list_after.remove(port_temp)
            msg_center.info("tc {} vf port list: {}".format(port, port_list_after))
            for vf_port_temp in port_list_after:
                set_ip = tc_vf_rang_start + str(tc_vf_ip_part) + tc_vf_rang_end
                if os_name_tmp == "centos":
                    self.terminal_client.send_command(f"service NetworkManager restart")
                    time.sleep(2)
                    self.terminal_client.send_command(
                        f"nmcli c add type ethernet con-name {vf_port_temp} ifname {vf_port_temp} ip4 {set_ip}/24")
                    self.terminal_client.send_command(f"nmcli c up {vf_port_temp}")
                elif os_name_tmp == "openeuler":
                    self.terminal_client.send_command(
                        f"nmcli c add type ethernet con-name {vf_port_temp} ifname {vf_port_temp} ip4 {set_ip}/24")
                    self.terminal_client.send_command(f"nmcli c up {vf_port_temp}")
                else:
                    self.terminal_client.send_command("ip addr add {}/24 dev {}".format(set_ip, vf_port_temp))
                    self.terminal_client.send_command("ip link set {} up".format(vf_port_temp))
                tc_vf_ip_list.append(set_ip)
                tc_vf_port_list.append(vf_port_temp)
                tc_vf_ip_part += 1
                msg_center.info("tc vf port:{} vf ip:{}".format(vf_port_temp, set_ip))
            msg_center.info("**************Finish tc {} create vf**************".format(port))
        msg_center.info("tc vf port:{}".format(tc_vf_port_list))
        msg_center.info("tc vf ip:{}".format(tc_vf_ip_list))
        if len(fail_list) == 0:
            return tc_vf_port_list, tc_vf_ip_list
        else:
            msg_center.error("tc port {} create vf fail".format(fail_list))
            return False

    def nic_create_vf_link(self, port_list_sut, num):
        """
        :Description：直连的网口两端创建同vf并配置同网段的IP
        :param port_list_sut: （INT）传入本端的网口列表
        :param num: （INT）传入需要设置的VF数量
        :param sut_vf_port_list: (OUT)返回sut_vf的网口数组列表
        :param sut_vf_ip_list: (OUT)返回sut_vf_ip的ip数组列表
        :param tc_port_list: (OUT)返回tc_vf的网口数组列表
        :param tc_vf_ip_list: (OUT)返回tc_vf_ip的ip数组列表
        :return: sut_vf_port_list、sut_vf_ip_list
        tc_port_list、tc_vf_ip_list
        :Example:nic_create_vf_set_ip_link(['eno1','eno2'], 2)
        """
        # 本端对端分别创建vf并设置同网段IP
        port_list_tc = []
        vf_ping_fial_list = []
        for port in port_list_sut:
            msg_center.info(f"show the port:{port}")
            port_dict_tc = self.nic_get_directly_ip_tc(port)
            msg_center.info(f"show the port_dict_tc: {port_dict_tc}")
            port_list_tc.append(port_dict_tc[port][1])
        else:
            msg_center.info("tc port list is {}".format(port_list_tc))
        vf_return_sut = self.nic_create_vf_sut(port_list_sut, num)
        sut_vf_port_list = vf_return_sut[0]
        sut_vf_ip_list = vf_return_sut[1]
        vf_return_tc = self.nic_create_vf_tc(port_list_tc, num)
        msg_center.info(f"this is port list tc:{port_list_tc} vf num:{num}")
        msg_center.info(f"this is vf return tc:{vf_return_tc}")
        tc_vf_port_list = vf_return_tc[0]
        tc_vf_ip_list = vf_return_tc[1]
        # 检查连通性
        for vf_ip in tc_vf_ip_list:
            ii = 0
            if self.nic_ping_test(vf_ip) is True:
                msg_center.info("ping {} success".format(vf_ip))
            else:
                msg_center.info("ping {} fail".format(tc_vf_ip_list))
                vf_ping_fial_list.append(tc_vf_port_list[ii])
                # vf ping不通时显示本对端vf的信息
                self.terminal_server.send_command(f"ip link show {port_list_sut[ii]}")
                self.terminal_client.send_command(f"ip link show {port_list_tc[ii]}")
                self.terminal_server.send_command(f"nmcli c show")
                self.terminal_client.send_command(f"nmcli c show")
                self.terminal_server.send_command(f"ip r | grep {port_list_sut[ii]}")
                self.terminal_client.send_command(f"ip r | grep {port_list_tc[ii]}")
            ii += 1
        if len(vf_ping_fial_list) == 0:
            msg_center.info("create sut and tc vf set ip pass,list as:")
            counter = 0
            n = 1
            for pf_port in port_list_sut:
                while counter < int(num) * n:
                    msg_center.info(
                        "sut_pf: {} [sut_vf_port: {} sut_vf_ip: {} tc_vf_port: {} tc_vf_ip: {}]" \
                            .format(pf_port, sut_vf_port_list[counter], sut_vf_ip_list[counter],
                                    tc_vf_port_list[counter], tc_vf_ip_list[counter]))
                    counter += 1
                n += 1
            return sut_vf_port_list, sut_vf_ip_list, tc_vf_port_list, tc_vf_ip_list
        else:
            msg_center.error("create sut and tc vf set ip fail,please check dmesg and set again")
            msg_center.error("link ping fail such: {}".format(vf_ping_fial_list))
            return False

    def nic_bind_network_interrupt(self, sut_port):
        """
        Description ：停止irqbalance和绑定CPU
        Examples ：nic_bind_network_interrupt(sut_port)
        :param sut_port: 本端网口名
        :return: True or False
        """
        # 定义一个空列表，承接中断号
        a_list = []
        check_num = 0
        msg_center.info("***************** nic_bind_network_interrupt start *****************")
        msg_center.info("***************** SUT {} *****************".format(sut_port))
        # 本端停止irqbalance
        self.terminal_server.send_command("systemctl stop irqbalance")
        # 获取本端numa节点、bus号
        numa_node = self.nic_taskset_check(sut_port)[1]
        nic_bus = self.nic_taskset_check(sut_port)[0]
        # 查找网卡中断起始号a，如果用网口名查不到信息，就用bus号查询
        a = self.terminal_server.send_command("awk '{print $1,$NF}' /proc/interrupts | grep -i %s | \
            awk -F ':' '{print$1}'" % sut_port)
        if not a:
            a = self.terminal_server.send_command("awk '{print $1,$NF}' /proc/interrupts | grep -i %s | \
            awk -F ':' '{print$1}'" % nic_bus)
        a = a.split()
        a_list.extend(a)
        # 查询网卡中断号数量num_b，如果用网口名查到的中断数量是0，则用bus查询
        num_b = int(self.terminal_server.send_command("awk '{print $1,$NF}' /proc/interrupts|grep -ic %s" % sut_port))
        if num_b == 0:
            num_b = int(
                self.terminal_server.send_command("awk '{print $1,$NF}' /proc/interrupts|grep -ic %s" % nic_bus))
        # 计算单个节点的CPU数目num_numa
        num_irq = int(self.terminal_server.send_command("lscpu |grep node%s | awk '{print$NF}'| \
            awk -F '-' '{print$1}'" % numa_node))
        num_numa_a = int(self.terminal_server.send_command("lscpu |grep '^CPU(s)' |awk '{print$NF}'"))
        # 计算numa的数目
        num_numa_b = int(self.terminal_server.send_command("lscpu |grep 'NUMA node(s)' |awk '{print$NF}'"))
        num_numa = int(num_numa_a / num_numa_b)
        # 绑中断
        for i in range(num_b):
            # 将中断号绑定在指定CPU上
            echo_num = i % num_numa + num_irq
            echo_irq = a_list[i]
            result_stat = self.terminal_server.send_command(
                "echo %d > /proc/irq/%s/smp_affinity_list" % (echo_num, echo_irq))
            # 检查每个中断是否绑定成功
            if result_stat[0] != 0:
                check_num += 1
                msg_center.info("echo %d > /proc/irq/%s/smp_affinity_list failed!" % (echo_num, echo_irq))
            # 查询irq_array并输出
            irq_array = self.terminal_server.send_command("cat /proc/irq/{}/smp_affinity_list".format(echo_irq))
            msg_center.info("[sut] {} irq is {} ".format(sut_port, irq_array))
        # 判断是否所有中断号绑定成功
        if check_num != 0:
            msg_center.error("Failed to bind the {} port to the interrupt ID.".format(sut_port))
            msg_center.info("***************** nic_bind_network_interrupt_tc end *****************")
            return False
        else:
            msg_center.info("***************** nic_bind_network_interrupt_tc end *****************")
            return True

    def nic_bind_network_interrupt_tc(self, tc_port):
        """
        Description ：停止irqbalance和绑定CPU
        Examples ：nic_bind_network_interrupt(tc_port, ip_tc)
        :param tc_port: 对端网口名，单个网口
        :return: True or False
        """
        # 定义一个空列表，承接中断号
        a_list = []
        msg_center.info("***************** nic_bind_network_interrupt_tc start *****************")
        msg_center.info("***************** TC {} *****************".format(tc_port))
        # 对端停止irqbalance
        self.terminal_client.send_command("systemctl stop irqbalance")
        # 获取对端numa节点
        bus_info_tc = self.terminal_client.send_command("ethtool -i %s |grep bus-info |awk '{print $2}'" % tc_port)
        numa_node_tc = self.terminal_client.send_command("cat /sys/bus/pci/devices/{}/numa_node".format(bus_info_tc))
        msg_center.info("[tc] get bus_info:{0}, numa_node:{1}".format(bus_info_tc, numa_node_tc))
        # 查找网卡中断起始号a，如果用网口名查不到信息，就用bus号查询
        a = self.terminal_client.send_command("awk '{print $1,$NF}' /proc/interrupts | grep -i %s | \
                awk -F ':' '{print$1}'" % tc_port)
        if not a:
            a = self.terminal_client.send_command("awk '{print $1,$NF}' /proc/interrupts | grep -i %s | \
                awk -F ':' '{print$1}'" % bus_info_tc)
        a = a.split()
        a_list.extend(a)
        # 查询网卡中断号数量num_b，如果用网口名查到的中断数量是0，则用bus查询
        num_b = int(self.terminal_client.send_command("awk '{print $1,$NF}' /proc/interrupts|grep -ic %s" % tc_port))
        if num_b == 0:
            num_b = int(
                self.terminal_client.send_command("awk '{print $1,$NF}' /proc/interrupts|grep -ic %s" % bus_info_tc))
        # num_irq:该node节点的起始CPU号，num_numa_a：所有numa node上的CPU总数
        num_irq = int(self.terminal_client.send_command("lscpu |grep node%s | awk '{print$NF}'| \
                awk -F '-' '{print$1}'" % numa_node_tc))
        num_numa_a = int(self.terminal_client.send_command("lscpu |grep '^CPU(s)' |awk '{print$NF}'"))
        # num_numa_b：numa node节点总数，num_numa：平均每个numa node上的CPU数量
        num_numa_b = int(self.terminal_client.send_command("lscpu |grep 'NUMA node(s)' |awk '{print$NF}'"))
        num_numa = int(num_numa_a / num_numa_b)
        # 绑中断
        for i in range(num_b):
            # 将中断号绑定在指定CPU上
            echo_num = i % num_numa + num_irq
            echo_irq = a_list[i]
            self.terminal_client.send_command("echo %d > /proc/irq/%s/smp_affinity_list" % (echo_num, echo_irq))
            # 查询irq_array
            irq_array = self.terminal_client.send_command("cat /proc/irq/{}/smp_affinity_list".format(echo_irq))
            # 输出信息
            msg_center.info("[tc] {} irq is {} ".format(tc_port, irq_array))
        msg_center.info("***************** nic_bind_network_interrupt_tc end *****************")
        return True

    def nic_check_env_network(self, tc_ip_list):
        """
        Description : 检查多网口网络连通性
        Examples ：nic_check_env_network(ip_list,ip_tc_ssh = "")
        :param tc_ip_list: 对端ip列表
        :return: True or False
        """
        # 初始化参数
        check_num = 0
        # 判断输入ip列表是否为空
        if not tc_ip_list:
            msg_center.error("enter port name failed!")
            return False
        else:
            for tc_ip in tc_ip_list:
                # 调用ping包函数
                ping_stat = self.terminal_server.send_command(f"ping -c 3 {tc_ip}| grep ' 0% packet loss'")
                # ping包后返回状态值为Ture，ping包成功，网络连通
                if len(ping_stat) != 0:
                    msg_center.info("{} is connected.".format(tc_ip))
                # ping包失败，输出本端对端的ip和网关
                else:
                    msg_center.error("{} is not connected.".format(tc_ip))
                    check_num = 1
            # ping包失败，输出本端对端的ip和网关
            if check_num != 0:
                ip_a = self.terminal_server.send_command("ip a")
                msg_center.info(ip_a)
                ip_route = self.terminal_server.send_command("ip route")
                msg_center.info(ip_route)
                tc_ip_a = self.terminal_client.send_command("ip a")
                msg_center.info(tc_ip_a)
                tc_ip_route = self.terminal_client.send_command("ip route")
                msg_center.info(tc_ip_route)
                return False
            return True

    def nic_ethtool_s(self, sut_port_name, rxq):
        """
        获取网口rxq收包数据
        :param sut_port_name: 入参，待检查数据网口
        :param rxq: 入参，待检查收包或发包字段
        :return: 数据收集的列表变量名
        """
        return_rxq_list = self.terminal_server.send_command(
            "ethtool -S {} | grep {} |grep pktnum|awk '{{print $NF}}'".format(sut_port_name, rxq)).split("\n")
        msg_center.info("port {} queue list:{}".format(sut_port_name, return_rxq_list))
        return return_rxq_list

    @staticmethod
    def nic_value_get_queue_on(rxq_list1, rxq_list2, single=True):
        """
        获取两收包数据列表中变化的队列号
        :param rxq_list1: 入参，收包数据列表1
        :param rxq_list2: 入参，收包数据列表2
        :param single: 入参，True表示单队列收包，False表示多队列收包
        :return: 有收包变化的队列号列表
        """
        return_queue_list = []
        if len(rxq_list1) == len(rxq_list2):
            for i in range(len(rxq_list1)):
                if int(rxq_list2[i]) - int(rxq_list1[i]) >= 200:
                    msg_center.info("queue is :{}".format(i))
                    return_queue_list.append(i)
            if single and len(return_queue_list) > 1:
                msg_center.error("rxq_list2 is not only one queue,please check it!!!")
                assert False
            elif len(return_queue_list) == 0:
                msg_center.error("rxq_list2 is not queue,please check network!!!")
                assert False
        else:
            msg_center.error("value1 num not equal to value2 num,please check it!!!")
            assert False

        return return_queue_list

    @staticmethod
    def nic_value_get_queue_list(rxq_list1, rxq_list2, set_value):
        """
        获取两收包数据列表中变化的队列号，判断收包队列个数
        :param rxq_list1: 入参，收包数据列表1
        :param rxq_list2: 入参，收包数据列表2
        :param set_value: 入参，收包队列个数
        :return: 有收包变化的队列号列表
        """
        return_queue_list = []
        set_value = int(set_value)
        if len(rxq_list1) == len(rxq_list2):
            for i in range(len(rxq_list1)):
                if int(rxq_list2[i]) - int(rxq_list1[i]) >= 200:
                    msg_center.info("queue is :{}".format(i))
                    return_queue_list.append(i)
            if len(return_queue_list) == set_value:
                msg_center.info(f"rxq_list2 queue receive is {set_value},test pass")
                return True
            else:
                msg_center.error(f"rxq_list2 queue receive is not {set_value},test fail")
                return False
        else:
            msg_center.error("value1 num not equal to value2 num,please check it!!!")
            return False

    @staticmethod
    def nic_get_hash_equal(rss_mesg, equal_num):
        """
        查询RSS重定向表指向队列，判断是否正确
        :param rss_mesg:  入参，hash队列的查询信息
        :param equal_num: 入参，RSS重定向表指向队列数
        :return: 返回对比后的结果（Ture False）
        """
        equal_num = int(equal_num)
        hash_get_list = []
        hsah_equal_list = re.findall(r"\d+", rss_mesg)
        if len(hsah_equal_list) == 9:
            hsah_equal_list = list(map(int, hsah_equal_list))
            equal_start = hsah_equal_list[0]
            equal_end = equal_start + 8
            equal_list = hsah_equal_list[1:]
            for i in range(equal_start, equal_end):
                j = i % equal_num
                hash_get_list.append(j)
            # 显示传入的RSS重定向表指向队列数预期结果的队列
            msg_center.info(f"hash equal {equal_num} hash_get_list: {hash_get_list}")
            if equal_list == hash_get_list:
                msg_center.info(f"equal_list is {equal_list},test pass")
                return True
            else:
                msg_center.error(f"equal_list is {equal_list},test fail")
                return False
        else:
            msg_center.error(f"rss_mesg is {rss_mesg},pleace check it!!!")
            return False

    def nic_analyse_pkt(self, sut_port_name):
        """
        nic/checksum 模块专用：解析ethtool -S的统计值，有错包则返回错包项，无错包时返回false
        """
        res_stats = dict()
        csum_stats = self.terminal_server.send_command(f"ethtool -S {sut_port_name} | grep l3l4_csum_err")
        for line in csum_stats.splitlines():
            lists = line.strip().split(": ")
            key = lists[0]
            value = int(lists[1])
            res_stats[key] = value
        for key in res_stats:
            if res_stats.get(key) != 0:
                return key, res_stats.get(key)
        msg_center.info("no error packets!")
        return False

    def nic_analyse_error_pkt(self, sut_port_name, error_type, test_round):
        """
        nic/checksum 模块专用：解析ethtool -S的错包值，并判断错包数是否符合预期
        test_round: 测试轮次，从1开始递增。每轮发包1000个。
        """
        res = self.nic_analyse_pkt(sut_port_name)
        if res == False:
            msg_center.error(f"{error_type} test failed!")
            assert False
        else:
            cksum_err_queue = res[0]
            cksum_err_cnt = res[1]
            if cksum_err_cnt >= 1000 * test_round and cksum_err_cnt <= 1000 * test_round + 20:
                msg_center.info(f"{error_type} test success! cksum_err_queue = {cksum_err_queue}, \
        cksum_err_cnt = {cksum_err_cnt}")
            else:
                msg_center.error(f"{error_type} test failed! cksum_err_queue = {cksum_err_queue}, \
        cksum_err_cnt = {cksum_err_cnt}")
                assert False

    def nic_tc_qdisc_set(self, network, tc_queue, prio_to_tc):
        """
        =====================================================================
        函 数 名：nic_tc_qdisc_set
        函数说明:设置各TC的队列和优先级
        参数说明：
        network：[str]网卡名称
        tc_queue：[dict]各TC对应的队列，格式{a:b}，其中a表示TC编号，b表示该TC下的queue总数。4TC举例： {0:16, 1:8, 2:4, 3:2}
        prio_to_tc：[dict]优先级对应的TC，格式{x:y}，其中x表示优先级，y表示TC编号。4TC举例：{0:0, 1:0, 2:1, 3:1, 4:2, 5:3, 6:3}
        如果TC编号为0，则该项可默认不写；如果所有内容都是0，则prio_to_tc定义为空{}传入即可。
        返  回  值: NULL
        注意事项： 使用本函数建议不要判断返回值，因为不管执行成功与否，返回值都为NULL
        使用实例：nic_tc_qdisc_set(Network, tc_queue, prio_to_tc)
        
        生成时间： 2021-4-19
        修改纪录：
        =====================================================================
        """
        # 初始化一个长度为8的，全为0组成的优先级队列
        prio_list = ["0"] * 8
        # 根据入参将对应位置的队列优先级进行修改
        for key in prio_to_tc.keys():
            prio_list[key] = str(prio_to_tc[key])
        prio_str = " ".join(prio_list)
        # 定义两个变量用于生成 "本tc队列数@起始队列号" 映射关系
        tc_count = 0
        tc_str = ""
        # 循环tc_queue字典，本tc队列数@起始队列号，本tc队列数由入参决定，起始队列号由前面所有的队列数相加得出
        for i in range(len(tc_queue)):
            tc_str += str(tc_queue[i]) + "@" + str(tc_count) + " "
            tc_count += tc_queue[i]
        tc_cmd = "tc qdisc add dev {0} root mqprio num_tc {1} map {2} queues {3}hw 1 mode channel".format(
            network, len(tc_queue), prio_str, tc_str)
        msg_center.info(tc_cmd)
        rst = self.terminal_server.send_command(tc_cmd)
        return rst

    def nic_tc_qdisc_get(self, network, tc_queue, prio_to_tc):
        """
        =====================================================================
        函 数 名：nic_tc_qdisc_get
        函数说明: 根据查询的队列数、队列优先级、队列映射关系与入参进行对比
        参数说明：参数意义与 nic_tc_qdisc_set 一致，所有参数都要传入
        返  回  值:错误码，True成功，False失败
        注意事项： 无
        使用实例：result = nic_tc_qdisc_get(Network, tc_queue, prio_to_tc)
        
        生成时间： 2021-4-19
        修改纪录：
        =====================================================================
        """
        tc_cmd = "tc qdisc show dev {}".format(network)
        rst = self.terminal_server.send_command(tc_cmd)
        # 从命令结果中获取tc num，保存在tc_num中,以及优先级队列所有的数字，保存在prio_list中
        s_re = re.search(r"tc\s(?P<tc_num>(\d+)).+map\s(?P<prio_list>([\d\s]+))", rst)
        # 从命令结果中获取所有"(数字:数字)"的组合
        f_re = re.findall(r"\((\d+:\d+)\)", rst)

        msg_center.info("get {} tc num: {}".format(network, s_re["tc_num"]))
        # 如果入参tc_queue长度与这里查询到的tc_num不一致则失败，返回1
        if len(tc_queue) != int(s_re["tc_num"]):
            msg_center.error("check {} tc num: {}, check failed".format(network, len(tc_queue)))
            return False

        # 将优先级队列list切割后获取前8位数字，与入参prio_to_tc进行对比
        prio_list = s_re["prio_list"].strip().split(" ")[:8]
        msg_center.info("get {} prio_list: {}".format(network, prio_list))
        # 每一位查询到一样的，则将该位置为0，最终查询队列若有不为0的数字，则表明对比失败
        for i in prio_to_tc:
            if prio_to_tc[i] == int(prio_list[i]):
                prio_list[i] = "0"
            else:
                # 查询结果不一致，返回失败
                msg_center.error(
                    "check {} prio_to_tc[{}]: {}, check failed".format(network, i, prio_to_tc[i]))
                return False
        if sorted(prio_list)[-1] != "0":
            # 存在不为0的数字，则对比有遗漏，失败
            msg_center.error("after check {} prio_list: {}, check failed".format(network, prio_list))
            return False

        # 设置两个变量，用于生成新的队列起始地址字典，例如{0:8，1:8, 2:8, 3:8}
        t_queue = {}
        count = 0
        msg_center.info("get {} t_queue from cmd: {}".format(network, f_re))
        # 将上面获取到的['0:15', '16:23', '24:27', '28:29']格式的结果转换成与入参一样格式
        for i in range(len(f_re)):
            end = f_re[i].split(":")[-1]
            t_queue[i] = int(end) + 1 - count
            count = int(end) + 1
        msg_center.info("get t_queue after transfer: {}".format(t_queue))
        # 从入参逐个获取与转换后的队列数字典进行对比，若匹配不上则失败
        for i in tc_queue:
            if tc_queue[i] != t_queue.get(i):
                msg_center.error(
                    "check {} tc_queue[{}]: {}, check failed".format(network, i, tc_queue[i]))
                return False
        return True

    def nic_tc_qdisc_analyse_pkt(self, network):
        """
        =====================================================================
        函 数 名：nic_tc_qdisc_analyse_pkt
        函数说明: 根据网口名查询报文统计，即命令：ethtool -S <ethx> |grep tx |grep pktnum_rcd
        参数说明：network：[str]网卡名称
        返  回  值:res_stats: [dict]txq队列报文统计
        注意事项： 无
        使用实例：result = nic_tc_qdisc_analyse_pkt(network)
        
        生成时间： 2021-4-20
        修改记录：
        =====================================================================
        """
        res_stats = dict()
        csum_stats = self.terminal_server.send_command(f"ethtool -S {network} |grep tx |grep pktnum_rcd")
        for line in csum_stats.splitlines():
            lists = line.strip().split(": ")
            key = lists[0]
            value = int(lists[1])
            res_stats[key] = value
        return res_stats

    def adq_test(self, tc_port_ip, adq_pri=-1, adq_port=5001, adq_type="server"):
        """
        =====================================================================
        函 数 名：adq_test
        函数说明: 本端起adq_client服务或者对端起adq_server服务
        参数说明：tc_port_ip：[str]对端网口ip ;adq_type：[str]启动adq类型;adq_pri:[int]报文优先级
        返  回  值:True or False
        注意事项： 无
        使用实例：result = adq_test("192.168.10.12")
        
        生成时间： 2021-4-28
        修改记录：
        =====================================================================
        """
        adq_dir = "/tmp/adq_tools/"
        # 判断本端没有/tmp/adq_tools/路径则创建该路径并且把adq_server和adq_client放到对应环境
        if not os.path.exists(adq_dir):
            self.terminal_server.send_command(f"mkdir -p {adq_dir}")
            self.terminal_server.send_command(f"cp {THIS_FILE_PATH}/../tools/nic_tools/adq* {adq_dir}")
            self.terminal_server.send_command(f"chmod -R 777 {adq_dir}")
            self.terminal_client.send_command(f"mkdir -p {adq_dir}")
            hns_global.client_scp.pull(adq_dir, adq_dir)
            self.terminal_client.send_command(f"chmod -R 777 {adq_dir}")
            time.sleep(2)
        # 启动需要的进程
        if adq_type == "server":
            self.terminal_client.send_command(f"{adq_dir}adq_server {tc_port_ip} {adq_port}")
            # 判断进程是否启动成功，只有server进程需要检查，client无法检查，只能通过收包结果判断
            if "adq_server" not in self.terminal_client.send_command(f"ps -ef | grep adq'"):
                msg_center.error(f"************************adq_server start fail")
                return False
            else:
                msg_center.info(f"**************************adq_server start success")
                return True
        elif adq_type == "client":
            self.terminal_server.send_command(f"{adq_dir}adq_client {tc_port_ip} {adq_port} {adq_pri}")
            time.sleep(2)
        return True

    def adq_pkt(self, sut_port, tc_port_ip, tc_queue, prio_to_tc, longtime_test=7, cycle_data=range(7)):
        """
        =====================================================================
        函 数 名：adq_pkt
        函数说明: 根据入参执行adq测试并判断结果
        参数说明：sut_port：[str]本端网卡名称；tc_port_ip：[str]本端网卡名称
        tc_queue：[dict]各TC对应的队列，格式{a:b}，其中a表示TC编号，b表示该TC下的queue总数。4TC举例： {0:16, 1:8, 2:4, 3:2}
        prio_to_tc：[dict]优先级对应的TC，格式{x:y}，其中x表示优先级，y表示TC编号。4TC举例：{0:0, 1:0, 2:1, 3:1, 4:2, 5:3, 6:3}
        如果TC编号为0，则该项可默认不写；如果所有内容都是0，则prio_to_tc定义为空{}传入即可。
        返  回  值:True or False
        注意事项： 无
        使用实例：adq_pkt(SUT_PORT_NAME, tc_port_ip, tc_queue, prio_to_tc)
        
        生成时间： 2021-4-28
        修改记录：
        =====================================================================
        """
        assert self.adq_test(tc_port_ip)
        default_dict = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0}
        pkt_before = self.nic_tc_qdisc_analyse_pkt(sut_port)
        pkt_before_const = dict()
        for i in pkt_before:
            pkt_before_const[i] = pkt_before.get(i)
        msg_center.info(f"pkt_before: {pkt_before}")
        for k in prio_to_tc.keys():
            default_dict[k] = prio_to_tc[k]
        prio_to_tc = default_dict
        # 每个pri对应的队列如{0:range(16),1:range(16,31),2:}
        pri_dict = dict()
        queue_start = 0
        tc_dict = dict()
        for i in tc_queue.keys():
            tc_dict[i] = range(queue_start, queue_start + int(tc_queue[i]))
            queue_start += int(tc_queue[i])
        for i in prio_to_tc:
            pri_dict[i] = tc_dict.get(prio_to_tc.get(i))
        msg_center.info(f"pri_dict: {pri_dict}")

        pkt_list = []
        # 将所有的会收到包的队列放在一个list里
        for j in cycle_data:
            pkt_list += list(pri_dict.get(j))
        pkt_list = list(set(pkt_list))

        # 存放收包大于4000的队列号和收包数量的位数
        longtime_pkt = []
        len_pkt_num = []
        for k in range(longtime_test):
            # 通过取余数获取优先级
            pri = k % 7
            # 长时间测试时可能不会循环所有优先级，比如会只执行4-7优先级，判断不是需要的优先级时直接continue
            if pri not in cycle_data:
                continue

            assert self.adq_test(tc_port_ip, adq_pri=pri, adq_type="client")
            time.sleep(2)
            # 查询测试后的收包队列和对应的收包数量
            pkt_after = self.nic_tc_qdisc_analyse_pkt(sut_port)
            msg_center.info(f"pri:{pri}, pkt_after: {pkt_after}")
            for key in pkt_after.keys():
                queue_num = int(re.findall(r'\d+', key)[0])
                # 获取 key队列本次与最开始的数量差值
                pkt_num = pkt_after.get(key) - pkt_before.get(key)
                pkt_num_longtime = pkt_after.get(key) - pkt_before_const.get(key)
                if pkt_num >= 40:
                    # 判断队列是否已经在待检查字典中
                    if queue_num not in pri_dict.get(pri):
                        msg_center.error(f"tx queue error! txq pktnum rcd:{queue_num}")
                        msg_center.error(f"pri:{pri},pri_dict:{pri_dict}")
                        assert False
                    if pkt_num_longtime >= 4000 and queue_num not in longtime_pkt:
                        longtime_pkt.append(queue_num)
                        len_pkt_num.append(len(str(pkt_num)))
            msg_center.info(f"\npri:{pri}, \nlongtime_pkt:{longtime_pkt}")
            msg_center.info(f"\ntest round: {k}")
            pkt_before = pkt_after
            if len(longtime_pkt) == len(pkt_list) and len(set(len_pkt_num)) <= 2:
                break
        if longtime_test > 7:
            if len(longtime_pkt) == len(pkt_list) and len(set(len_pkt_num)) <= 2:
                msg_center.info("long time test pass")
            else:
                msg_center.error(f"long time test pkt is fail {longtime_pkt}")
                assert False
        return True

    def nic_promisc_set(self, value: str, **kwargs) -> bool:
        """
        =====================================================================
        函 数 名：nic_promisc_set
        函数说明: 设置并查询混杂模式，PF/VF通用
        参数说明：
        value[str]:  "on"/"off"，promisc状态开关
        **kwargs:  可变入参，根据PF/VF取不同值
        返  回  值: True成功，False失败
        注意事项： 无
        使用实例：
        PF网口: nic_promisc_set("on", is_pf=True, pf_name="eth0")
        VF网口: nic_promisc_set("on", is_pf=False, pf_name="eth0", vf_name="eth0v0", vf_id=0)
        
        生成时间： 2021-5-19
        修改纪录：
        =====================================================================
        """
        value_to_set = value.lower()
        if value_to_set != "on" and value_to_set != "off":
            msg_center.error(f"input value error: {value}")
            return False
        # 获取用户输入并配置promisc
        is_pf = kwargs.get("is_pf")
        pf_name = kwargs.get("pf_name")
        vf_name = kwargs.get("vf_name")
        vf_id = kwargs.get("vf_id")
        if is_pf != True and is_pf != False:
            msg_center.error(f"input error: is_pf = {is_pf}")
            return False
        if is_pf == True:
            nic_name = pf_name
            set_result = knet.Eth(nic_name, terminal=self.terminal_server).config_promisc(value_to_set)
        else:
            nic_name = vf_name
            # 先使能trust
            knet.Eth(pf_name, terminal=self.terminal_server).config_vf_trust(vf_id, "on")
            set_result = knet.Eth(nic_name, terminal=self.terminal_server).config_promisc(value_to_set)
        if set_result == 0:
            msg_center.info(f"set {nic_name} promisc {value_to_set} success!")
            return True
        else:
            msg_center.error(f"set {nic_name} promisc {value_to_set} fail!")
            return False

    def nic_spoofchk_set(self, pf_name: str, vf_id: int, value: str) -> bool:
        """
        =====================================================================
        函 数 名：nic_spoofchk_set
        函数说明: 设置并查询欺诈检测，VF适用
        参数说明：
        pf_name[str]: pf网口名
        vf_id[int]:  vf编号，从0开始
        value[str]:  "on"/"off"，spoofchk状态开关
        返  回  值: True成功，False失败
        注意事项： 无
        使用实例：
        打开spoofchk： nic_spoofchk_set("ethx", 0, "on")
        关闭spoofchk： nic_spoofchk_set("ethx", 0, "off")
        
        生成时间： 2021-5-19
        修改纪录：
        =====================================================================
        """
        value_to_set = value.lower()
        if value_to_set != "on" and value_to_set != "off":
            msg_center.error(f"input value error: {value}")
            return False

        # 设置spoofchk
        self.terminal_server.send_command(f"ip link set {pf_name} vf {vf_id} spoofchk {value_to_set}")
        # 查询
        res = self.terminal_server.send_command(f"ip link show {pf_name}")
        if value_to_set == "on" and "spoof checking on" in res:
            msg_center.info(f"set & get {pf_name} spoofchk ON success!")
            return True
        elif value_to_set == "off" and "spoof checking off" in res:
            msg_center.info(f"set & get {pf_name} spoofchk OFF success!")
            return True
        else:
            msg_center.error(f"set & get spoofchk failed!! nic:{pf_name}, status to set:{value}")
            return False

    def nic_vf_vlan_set(self, pf_name: str, vf_id: int, vlan_id: int, tc: bool = False) -> bool:
        """
        =====================================================================
        函 数 名：nic_port_vlan_set
        函数说明: 设置port vlan（即QinQ），VF适用
        参数说明：
        pf_name[str]: pf网口名
        vf_id[int]:  vf编号，从0开始
        vlan_id[int]:  vlan_id，正数表示vlan_id，0表示删除，负数无效
        返  回  值: True成功，False失败
        注意事项： 无
        使用实例：
        设置port vlan（即QinQ）：nic_port_vlan_set("ethx", 0, 5)
        删除port vlan（即QinQ）：nic_port_vlan_set("ethx", 0, 0)
        
        生成时间： 2021-5-20
        修改纪录：
        =====================================================================
        """
        if vlan_id < 0:
            msg_center.error(f"input vlan_id error: {vlan_id}")
            return False
        elif vlan_id == 0:
            msg_center.info("delete port vlan!!!!")
        else:
            msg_center.info(f"set port vlan to {vlan_id}!")

        # 设置vlan_id
        cmd = f"ip link set dev {pf_name} vf {vf_id} vlan {vlan_id}"
        if tc:
            self.terminal_client.send_command(cmd)
        else:
            self.terminal_server.send_command(cmd)
        return True

    def get_random_port(self, port_type, num=1):
        """
        =====================================================================
        函 数 名：get_random_port
        函数说明: 指定网口类型，获取随机网口名、和对应的bus号
        参数说明：
        port_type[str]: 网口类型：fibre(光口)、tp(电口)、25G_fibre(25G)、100G_fibre(100G)、82599、i350、mlx、HI1822
        num：返回随机网口数量，默认返回一个网口
        返  回  值:
        port_name[str]: 随机网口名
        businfo[str]:   网口名对应的bus号
        注意事项： 无
        使用实例：
        获取随机电口：port_name, businfo = get_random_port("fibre")
        获取随机光口口：port_name, businfo = get_random_port("tp")
        
        生成时间： 2021-7-16
        修改纪录：
        =====================================================================
        """
        port_list = self.nic_get_sut_onboard_port_list(port_type)
        msg_center.info(f"获取到port_list:{port_list}")
        port_name_list = port_list[0]
        businfo_list = port_list[1]
        random_para = random.sample([i for i in range(len(port_name_list))], num)
        if num == 1:
            return port_name_list[random_para[0]], businfo_list[random_para[0]]
        else:
            return [port_name_list[i] for i in random_para], [businfo_list[i] for i in random_para]

    def nic_check_debugfs_ver(self):
        """
        =====================================================================
        函 数 名：nic_check_debugfs_ver
        函数说明: 获取debugfs版本
        参数说明：null
        返  回  值: debugfs_ver: [str] 取值“new”（cat方式） or "old"（echo xxx > cmd方式）
        注意事项： 调用本函数前是否mount不影响测试结果（即可以mount、也可以不mount，结果一样）。
        使用实例： res = nic_check_debugfs_ver()
        
        生成时间： 2021-9-13
        修改纪录：
        =====================================================================
        """
        # 随机获取一个网口的businfo
        port_type = random.choice(["fibre", "tp"])
        random_businfo = self.get_random_port(port_type)[1]
        self.terminal_server.send_command("dmesg -c > /dev/null")
        kernel_ver = f"/sys/kernel/debug/hns3/{random_businfo}"
        res = self.terminal_server.send_command(f"ls {kernel_ver}")
        self.terminal_server.send_command(f"echo queue map > {kernel_ver}/cmd")
        queue_info = self.terminal_server.send_command("dmesg")
        if "cmd" in res and "local queue id" in queue_info:
            debugfs_ver = "old"
        else:
            debugfs_ver = "new"
        msg_center.info(f"======= get debugfs ver: {debugfs_ver} =======")
        return debugfs_ver

    def vf_up_times_in_pf_link(self, pf_port, vf_port, link=''):
        """
        函 数 名：vf_up_times_in_pf_link
        函数说明: 当pf设置为up或down时，检查vf的启动时间
        参数 pf_port: [INT] str 输入的pf网口名,例：eno1
        参数 vf_port: [INT] str 输入的vf网口名，例：eno1v1
        参数 link: [INT] str 输入要查询的网卡状态，例：link='up',link='down'
        返回值: times [out] float 返回up或down所需时间
        """
        self.terminal_server.send_command("dmesg -C")
        cmd_send = f"ip link set {pf_port} {link}"
        self.terminal_server.send_command(cmd_send)
        time.sleep(5)
        if link == 'up':
            for i in range(10):
                cmd_link_up = f"dmesg -d |grep {vf_port} |grep 'link up' "
                if vf_port not in cmd_link_up:
                    time.sleep(1)
                else:
                    break
                if i == 9:
                    msg_center.error("pf port link up more then 10s failed")
                    return False
            cmd_up = f"dmesg -d |grep {vf_port} |grep 'link up' |awk -F'>' '{{print $1}}' |awk 'END{{print $NF}}'"
            times = self.terminal_server.send_command(cmd_up)
            msg_center.info(f"up_time is ------------>{times}")
            return float(times)
        elif link == 'down':
            cmd_down = f"dmesg -d |grep {vf_port} |grep 'link down' |awk -F'>' '{{print $1}}' |awk 'END{{print $NF}}'"
            times = self.terminal_server.send_command(cmd_down)
            msg_center.info(f"down_time is ------------>{times}")
            return float(times)
        else:
            msg_center.error("pf port link status error!")
            return False

    def nic_get_directly_ip_tc(self, port_name):
        """
        通过本端网口名，获取对端直连关系的ip地址和网口名
        :param port_name:传入的网口名
        :return:对端直连网口的ip和网口名组成的列表为值，传入的网口名为键组成的字典
        如：{"port_name":[tc_ip,tc_port_name]}
        """
        return_port_info = {}
        # 获取本端网口的网段
        this_ip = sys_base_info.fn_get_ip_by_port(port_name)
        if this_ip:
            ip_seg = ".".join(this_ip.split(".")[:-1])
        else:
            msg_center.error("{0} this port has no ip".format(port_name))
            return False
        # 通过网段获取对端ip
        tc_ip_commd = f"ip a | grep inet | grep '{ip_seg}.' | awk '{{print $2}}' | cut -d '/' -f 1"
        tc_ip = self.terminal_client.send_command(tc_ip_commd)
        return_port_info[port_name] = [tc_ip]
        # 获取对端网口名
        tc_port_name_commd = "ip a | grep %s |awk '{print $NF}'" % tc_ip
        tc_port_name = self.terminal_client.send_command(tc_port_name_commd)
        return_port_info.get(port_name).append(tc_port_name)
        return return_port_info

    def nic_del_vlan(self, tc=False):
        """
        删除本端或者对端所有vlan
        :return: 删除成功返回True，失败返回False
        """
        # 获取需要删除的vlan
        cmd = "ip a | grep ^[[:digit:]]|grep '@'|egrep -v 'sit0|NONE' |awk -F':' '{print $2}'|awk -F'@' '{print $1}'"
        # 将ssh返回的字符串有换行符分割成列表
        if tc:
            vlan_list_tmp = self.terminal_client.send_command(cmd).split("\n")
        else:
            vlan_list_tmp = self.terminal_server.send_command(cmd).split("\n")
        vlan_list = [i for i in vlan_list_tmp if i != '']
        msg_center.info("need to delete {} ".format(vlan_list))
        if len(vlan_list) == 0:
            msg_center.info("no vlan need be deleted")
            return True
        for vlan_name in vlan_list:
            del_vlan_commd = "ip link delete {}".format(vlan_name)
            if tc:
                self.terminal_client.send_command(del_vlan_commd)
            else:
                self.terminal_server.send_command(del_vlan_commd)
        # 将ssh返回的字符串有换行符分割成列表
        if tc:
            vlan_list_tmp = self.terminal_client.send_command(cmd).split("\n")
        else:
            vlan_list_tmp = self.terminal_server.send_command(cmd).split("\n")
        vlan_list = [i for i in vlan_list_tmp if i != '']
        # 判断删除是否成功
        if len(vlan_list) != 0:
            msg_center.error("vlan delete fail")
            return False
        else:
            msg_center.info("vlan delete success")
            return True

    def nic_link_check_time(self, nic_name, timeout_value=5, tc=False):
        """
        5s后判断link status是否为yes,及speed重新获,默认判断5s
        取到,如没有sleep 1重新检查,最长等待时间为timeout_value
        """
        for t in range(timeout_value):
            # 查看网卡speed只取数字部分，link status
            if tc:
                speed = self.terminal_client.send_command(
                    "ethtool %s |awk '/Speed/{print $2}'|tr -cd '0-9'" % nic_name)
                link_stat = self.terminal_client.send_command("ethtool %s |awk '/Link dete/{print $3}'" % nic_name)
            else:
                speed = self.terminal_server.send_command(
                    "ethtool %s |awk '/Speed/{print $2}'|tr -cd '0-9'" % nic_name)
                link_stat = self.terminal_server.send_command("ethtool %s |awk '/Link dete/{print $3}'" % nic_name)
            if speed > "0" and link_stat == 'yes':
                msg_center.info("the {0} link is up,time {1} sec".format(nic_name, t + 1))
                return True
            time.sleep(1)
        msg_center.error(f"Failed to check the network port status, timeout:{timeout_value}")
        return False

    def nic_get_ipv6_list(self, port_list, tc=False):
        """
        需要传入对端的网口列表，返回的结果存入到字典ipv6_list中
        :param port_list: 传入需要查询的网口列表
        :param tc:默认查询本端的，查询对端的入参tc=True
        :return:
        """
        ipv6_list = {}
        for port_temp in port_list:
            # 远程登陆成功之后，按照网口名找出对应的ipv6地址
            if tc:
                check_ipv6 = self.terminal_client.send_command("ip -6 a show dev %s  | grep 'global'| grep 'inet6' | \
                                               awk '{print $2}'| cut -d '/' -f1" % port_temp)
            else:
                check_ipv6 = self.terminal_server.send_command("ip -6 a show dev %s  | grep 'global'| grep 'inet6' | \
                                               awk '{print $2}'| cut -d '/' -f1" % port_temp)
            # 将查询的结果存入字典中
            if check_ipv6:
                ipv6_list[port_temp] = check_ipv6
            else:
                msg_center.error("Failed to obtain the IPv6 address,please check the environment")
                return False
        return ipv6_list

    def nic_check_flr_done(self, port_name, time_value=30, flr_times=1):
        """
        检查FLR后，有没有完全FLR结束，避免并发FLR
        :param flr_times: 查询第几次的FLR。默认第一次
        :param port_name: 检查的网口
        :param time_value: 预期超时时间
        :return:
        """
        # 开始前检查dmesg的FLR信息判断是否完成FLR
        cmd = f"dmesg |grep -A 5 -i 'Reset done'|grep '{port_name}: link up'|wc -l"
        for times_data in range(time_value):
            # 开始后检查dmesg的FLR信息判断是否完成FLR，检查失败则sleep 1秒继续检查，直到超过预期时间
            flr_after = self.terminal_server.send_command(cmd)
            if int(flr_after) == flr_times:
                msg_center.info(f"the {flr_times} time FLR reset OK, {port_name} up time is {times_data}")
                return True
            else:
                time.sleep(1)
        msg_center.error(f"the {flr_times} time FLR reset fail, {port_name} checking {time_value} secs up fail")
        return False

    @staticmethod
    def ping_test(handle, tc_ip, ping=True):
        """
        ping包检查网络状态
        :param handle：SSH连接的句柄
        :param tc_ip：ping的ip
        :param ping：ping包预期结果。True：ping通返回True，失败返回False；False：ping通返回False，失败返回True
        """
        # 调用ping包函数
        ping_stat = handle.send_command(f"ping -c 3 {tc_ip}")
        # ping包后返回状态值为Ture，ping包失败，网络不通
        if ping == True:
            # 没有丢包
            if " 0% packet loss" in ping_stat:
                return True
            # ping包失败，输出本端对端的ip和网关
            else:
                msg_center.error("{} is connected. Disable check fail!".format(tc_ip))
                return False
        elif ping == False:
            # ping不通
            if "100% packet loss" in ping_stat:
                return True
            # ping包成功，输出本端对端的ip和网关
            else:
                msg_center.error("{} is connected. Disable check fail!".format(tc_ip))
                return False
        else:
            msg_center.error("ping 参数错误")
            return False

    def nic_stand_alone_get_sut_onboard_port_list(self, port_type):
        """
        单机环境获取符合要求的网口列表
        :param port_type:网口类型：fibre(光口)、tp(电口)、82599、i350、mlx、HI1822
        :return: port_list：网口名列表，bus_info：bus号列表
        """
        # 将入参全部转为小写，统一格式
        global ip_segment
        port_type = port_type.lower()
        port_name_list = []
        port_businfo_list = []
        port_type_list = ["tp", "fibre", "i350", "82599", "mlx", "hi1822", "x550"]
        port_list_temp = []
        port_driver = {"i350": "igb", "82599": "ixgbe", "mlx": "mlx5_core", "hi1822": "hinic", "x550": "ixgbe"}
        # 判断入参是否符合规范
        if port_type not in port_type_list:
            return False
        cmd = "ip a |grep -i state |awk '{print$2}'|tr -d :"
        port_list_temp_all = self.terminal_server.send_command(cmd, disable_show_and_log=True).split()
        port_list_temp_all.remove("lo")
        if port_type in ["tp", "fibre"]:
            for port_name in port_list_temp_all:
                cmd = "ethtool -i {} | grep 'driver: hns'".format(port_name)
                res = self.terminal_server.send_command(cmd, disable_show_and_log=True)
                if 'driver: hns' in res:
                    port_list_temp.append(port_name)
            for port_name in port_list_temp:
                port_ethtool = self.terminal_server.send_command("ethtool {}".format(port_name),
                                                                 disable_show_and_log=True)
                # 遍历所有网口，筛选出符合要求的网口
                if port_type == "tp":
                    if "TP" in port_ethtool:
                        port_name_list.append(port_name)
                if port_type == "fibre":
                    # 普通光口不支持100000baseCR/Full和25000baseCR/Full
                    if "FIBRE" in port_ethtool:
                        port_name_list.append(port_name)
        else:
            for port_name in port_list_temp_all:
                port_ethtool = self.terminal_server.send_command("ethtool {}".format(port_name),
                                                                 disable_show_and_log=True)

                port_ethtool_i = self.terminal_server.send_command("ethtool -i {}".format(port_name),
                                                                   disable_show_and_log=True)
                if port_type not in ["82599", "x550"]:
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i:
                        port_name_list.append(port_name)
                elif port_type == "82599":
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i and "FIBRE" in port_ethtool:
                        port_name_list.append(port_name)
                elif port_type == "x550":
                    if "driver: {}".format(port_driver.get(port_type)) in port_ethtool_i and "TP" in port_ethtool:
                        port_name_list.append(port_name)
        for port_name in port_name_list:
            # 遍历每个网口获取其bus号
            cmd = "ethtool -i %s | grep 'bus-info' | awk '{print $NF}' | sed 's/ //g'" % port_name
            port_businfo = self.terminal_server.send_command(cmd, disable_show_and_log=True)
            port_businfo_list.append(port_businfo)
        return port_name_list, port_businfo_list

    def get_stand_alone_random_port(self, port_type, num=1):
        """
        =====================================================================
        函 数 名：get_stand_alone_random_port
        函数说明: 指定网口类型，获取随机网口名、和对应的bus号
        参数说明：
        port_type[str]: 网口类型：fibre(光口)、tp(电口)、82599、i350、mlx、HI1822
        num：返回随机网口数量，默认返回一个网口
        返  回  值:
        port_name[str]: 随机网口名
        businfo[str]:   网口名对应的bus号
        注意事项： 无
        使用实例：
        获取随机电口：port_name, businfo = get_stand_alone_random_port("fibre")
        获取随机光口口：port_name, businfo = get_stand_alone_random_port("tp")
        修改纪录：
        =====================================================================
        """
        port_list = self.nic_stand_alone_get_sut_onboard_port_list(port_type)
        port_name_list = port_list[0]
        businfo_list = port_list[1]
        random_para = random.sample([i for i in range(len(port_name_list))], num)
        if num == 1:
            return port_name_list[random_para[0]], businfo_list[random_para[0]]
        else:
            return [port_name_list[i] for i in random_para], [businfo_list[i] for i in random_para]

    def get_adaptive(self, port_name, adaptive_mode, tc=False):
        """
        获取网口的adaptive-tx和adaptive-rx的状态
        :param port_name: 传入需要查询的网口
        :param adaptive_mode: 传入需要查询的adaptive
        :param tc:默认查询本端的，查询对端的入参tc=True
        :return:
        """
        if tc:
            rx_adaptive = self.terminal_client.send_command(f"ethtool -c {port_name}|grep Adaptive").split(" ")[2]
            tx_adaptive = self.terminal_client.send_command(f"ethtool -c {port_name}|grep Adaptive").split(" ")[-1]
        else:
            rx_adaptive = self.terminal_server.send_command(f"ethtool -c {port_name}|grep Adaptive").split(" ")[2]
            tx_adaptive = self.terminal_server.send_command(f"ethtool -c {port_name}|grep Adaptive").split(" ")[-1]
        if adaptive_mode == "adaptive-rx":
            return rx_adaptive
        else:
            return tx_adaptive

    def get_usecs(self, port_name, usecs_mode, tc=False):
        """
        获取网口的rx-usecs和tx-usecs的值
        :param port_name: 传入需要查询的网口
        :param usecs_mode: 传入需要查询的usecs参数
        :param tc:默认查询本端的，查询对端的入参tc=True
        :return (INT):usecs的值
        """
        if tc:
            usecs = self.terminal_client.send_command(f"ethtool -c {port_name}|grep {usecs_mode}|head -1").split(" ")[
                -1]
        else:
            usecs = self.terminal_server.send_command(f"ethtool -c {port_name}|grep {usecs_mode}|head -1").split(" ")[
                -1]
        return int(usecs)

    def set_adaptive(self, port_name, adaptive_mode, adaptive_type, tc=False):
        """
        设置网口的adaptive-tx或adaptive-rx的状态
        :param port_name: 传入需要设置的网口
        :param adaptive_mode: 传入需要设置的adaptive
        :param adaptive_type: 传入需要设置的adaptive的状态
        :param tc:默认查询本端的，查询对端的入参tc=True
        :return:
        """
        if tc:
            self.terminal_client.send_command(f"ethtool -C {port_name} {adaptive_mode} {adaptive_type}")
            adaptive = Hns3Util.get_adaptive(self, port_name, adaptive_mode, tc=True)
            if adaptive != adaptive_type:
                return False
        else:
            self.terminal_server.send_command(f"ethtool -C {port_name} {adaptive_mode} {adaptive_type}")
            adaptive = Hns3Util.get_adaptive(self, port_name, adaptive_mode, tc=False)
            if adaptive != adaptive_type:
                return False
        return True

    def set_usecs(self, port_name, usecs_mode, usecs_value, tc=False):
        """
        设置网口的rx-usecs或tx-usecs的值
        :param port_name: 传入需要设置的网口
        :param usecs_mode: 传入需要设置的usecs
        :param usecs_value(INT): 传入需要设置的usecs的值
        :param tc:默认查询本端的，查询对端的入参tc=True
        :return:
        """
        if tc:
            self.terminal_client.send_command(f"ethtool -C {port_name} {usecs_mode} {usecs_value}")
            rx_value = Hns3Util.get_usecs(self, port_name, usecs_mode, tc=True)
            if rx_value != usecs_value:
                return False
        else:
            self.terminal_server.send_command(f"ethtool -C {port_name} {usecs_mode} {usecs_value}")
            rx_value = Hns3Util.get_usecs(self, port_name, usecs_mode, tc=False)
            if rx_value != usecs_value:
                return False
        return True

    @staticmethod
    def nic_get_promisc(handler, port_name):
        """
        查询网口的promisc状态
        :param handler: 传入句柄
        :param port_name: 传入需要查询的网口
        :return:True为打开，Flase为关闭
        """
        res = handler.send_command(f"ifconfig {port_name}|grep -iw PROMISC")
        return True if res else False

    @staticmethod
    def nic_set_multipleip(handler, port_name, ip_list):
        """
        网口上增加多个ip
        :param handler: 传入句柄
        :param port_name: 传入需要增加ip的网口
        :param ip_list: 传入需要增加的ip列表
        :return:True为添加成功，Flase为添加失败
        """
        for ip in ip_list:
            handler.send_command(f"ip addr add {ip}/24 dev {port_name}")
            handler.send_command(f"ip link set {port_name} up")
            res = handler.send_command(f"ip a |grep {port_name}")
            if ip not in res:
                msg_center.error(f"Failed to set ip {ip}")
                return False
        return True

    @staticmethod
    def nic_del_ip(handler, port_name, ip_list):
        """
        删除网口多余的ip
        :param handler: 传入句柄
        :param port_name: 传入需要删除ip的网口
        :param ip_list: 传入需要删除的ip列表
        :return:True为删除成功，Flase为删除失败
        """
        for ip in ip_list:
            handler.send_command(f"ip addr del {ip}/24 dev {port_name}")
            res = handler.send_command(f"ip a|grep {port_name}")
            if ip in res:
                msg_center.error(f"Failed to delete ip {ip}")
                return False
        return True

    def down_up(self, port_name, up=True, tc=False):
        """
        用于网口down和up的函数（目前只适配了ubuntu，其他系统直接pass略过）
        :param port_name: 网口名
        :param up: 为True则up操作，否则down操作
        :param tc: 为Flase本端执行，否则对端执行
        :return:
        """
        os_type = sys_base_info.fn_get_os_name()
        if os_type == "ubuntu":
            if up:
                command = f"ifconfig {port_name} up"
            else:
                command = f"ifconfig {port_name} down"
            if tc:
                self.terminal_client.send_command(command)
            else:
                self.terminal_server.send_command(command)
            time.sleep(2)
        elif os_type == "openeuler" or os_type == "centos":
            if up:
                command1 = f"nmcli c up {port_name}"
                command2 = f"ifconfig {port_name} up"
            else:
                command1 = f"nmcli c down {port_name}"
                command2 = f"ifconfig {port_name} down"
            if tc:
                self.terminal_client.send_command(command1)
                time.sleep(1)
                self.terminal_client.send_command(command2)
            else:
                self.terminal_server.send_command(command1)
                time.sleep(1)
                self.terminal_server.send_command(command2)
            time.sleep(2)
        else:
            pass

    @staticmethod
    def tran_ipv4(sim_ipv4):
        """
        用于将传入的ipv4地址转换成报文格式的字符串
        :param sim_ipv4: ipv4
        :return:" ".join(ip_hex)
        """
        ip_hex = []
        tmplist = sim_ipv4.split(".")
        for tmp in tmplist:
            ip_hex.append(hex(int(tmp)).split("0x")[1].zfill(2))
        return " ".join(ip_hex)

    @staticmethod
    def tran_ipv6(sim_ipv6):
        """
        用于将传入的ipv6地址转换成报文格式的字符串
        :param sim_ipv6: ipv6
        :return:ipv6str
        """
        ip_list = IP(sim_ipv6, make_net=True).strFullsize().lower().split(":")
        ipstr_list = []
        for ip in ip_list:
            ipstr_list.append(ip[:2])
            ipstr_list.append(ip[2:])
        return " ".join(ipstr_list)

    def get_sctp_cksum(self, **kwargs):
        """
        获取固定格式的报文净荷数据
        参数说明: NA
        :param src_ip         源ip
        :param src_port       源端口
        :param dst_ip         目的ip
        :param dst_port       目的端口
        :param protol         ipv4 or ipv6,默认ipv4
        :return:具体报文
        """
        src_ip = kwargs.get("src_ip", configs_network.REMOTE_IPV6_IP[0])
        dst_ip = kwargs.get("dst_ip", configs_network.LOCAL_IPV6_IP[0])
        protol = kwargs.get("protol", True)
        if protol:
            src_ipstr = self.tran_ipv6(src_ip)
            dst_ipstr = self.tran_ipv6(dst_ip)
            sctp_cksum_list = configs_network.IPV6_SCTP_CKSUM_OK.split()
            sctp_cksum_top = " ".join(sctp_cksum_list[:10])
            src_port = kwargs.get("src_port", " ".join(sctp_cksum_list[42:44]))
            dst_port = kwargs.get("dst_port", " ".join(sctp_cksum_list[44:46]))
            sctp_cksum_end = " ".join(sctp_cksum_list[46:])
        else:
            src_ipstr = self.tran_ipv4(src_ip)
            dst_ipstr = self.tran_ipv4(dst_ip)
            sctp_cksum_list = configs_network.IPV4_SCTP_CKSUM_OK.split()
            sctp_cksum_top = " ".join(sctp_cksum_list[:14])
            src_port = kwargs.get("src_port", " ".join(sctp_cksum_list[22:24]))
            dst_port = kwargs.get("dst_port", " ".join(sctp_cksum_list[24:26]))
            sctp_cksum_end = " ".join(sctp_cksum_list[26:])
        complete_packet = f"{sctp_cksum_top} {src_ipstr} {dst_ipstr} {src_port} {dst_port} {sctp_cksum_end}"
        msg_center.info(f"ipv6:407,ipv4:347;该报文长度为：{len(complete_packet)}")
        return complete_packet

    @staticmethod
    def self_test(port_name, handler, test_mode, num=1):
        """
        查看网口环回检测是否通过
        传入需要自检测的网口和检测模式
        命令：ethtool -t ethx offline / online /不指定参数
        :param port_name: 入参，待检测的网口
        :param handler:入参，句柄
        :param test_mode: 入参，检测模式 “”，“online”，“offline”
        :param num :入参，执行检测次数，默认为1
        :return: bool
        """
        for i in range(num):
            para_list = ['App', 'serial', 'parallel']
            cmd = f"ethtool -t {port_name} {test_mode}>msg.log"
            handler.send_command(cmd)
            time.sleep(3)
            for para in para_list:
                ret = handler.send_command(f"cat msg.log |grep -i {para}").split()[-1]
                if int(ret) != 0:
                    msg_center.error('Self test failed!')
                    handler.send_command(f"rm -f msg.log")
                    return False
            ret = handler.send_command(f"cat msg.log")
            if "PASS" not in ret:
                msg_center.error('Self test failed!')
                handler.send_command(f"rm -f msg.log")
                return False
            handler.send_command(f"rm -f msg.log")
        return True

    def vf_trust_on_off(self, nic_name: str, vf_id: int, trust_status: str):
        """
        内核态开关vf混杂trust
        传入需要开关trust的网口名字、vf_id和开关状态
        :param nic_name: 入参，网口名
        :param vf_id: 入参，vf对应id，pf的第一个vf则id为0
        :param trust_status: 入参，开关状态 “on”、“off”
        :return: bool
        """
        trust_status = trust_status.lower()
        self.terminal_server.send_command(f"ip link set {nic_name} vf {vf_id} trust {trust_status}")
        trust_ret = self.terminal_server.send_command(f"ip link show {nic_name} | grep 'vf {vf_id}'")
        if f"trust {trust_status}" not in trust_ret.lower():
            msg_center.error(f"Kernel state check trust withch {trust_status} fail! trust_ret:{trust_ret}")
            return False
        return True


def __save_iface_name__(iface, terminal, bdf_map_iface: dict):
    """
    =====================================================================
    函数说明: 根据速率存储网口名到不同的列表中
    修改时间: 2021/12/16 10:57:34
    作    者: lwx567203
    =====================================================================
    """
    port_list = {
        "server": {
            "1000": hns_config.LOCAL_ETH_G_LIST,
            "10000": hns_config.LOCAL_ETH_XG_LIST,
            "25000": hns_config.LOCAL_ETH_LG_LIST,
            "100000": hns_config.LOCAL_ETH_CG_LIST,
            "200000": hns_config.LOCAL_ETH_200G_LIST,
            "100": hns_config.LOCAL_ETH_100M_LIST
        },
        "client": {
            "1000": hns_config.REMOTE_ETH_G_LIST,
            "10000": hns_config.REMOTE_ETH_XG_LIST,
            "25000": hns_config.REMOTE_ETH_LG_LIST,
            "100000": hns_config.REMOTE_ETH_CG_LIST,
            "200000": hns_config.REMOTE_ETH_200G_LIST,
            "100": hns_config.REMOTE_ETH_100M_LIST
        }
    }
    msg_center.info(f"{terminal}端获取{iface}的速率")
    speed = attr.query_speed_port(iface, terminal=terminal)
    iface_list = port_list.get(terminal, {}).get(speed, [])
    iface_list.append(iface)

    bus_info = ethtool.get_iface_bdf(iface, terminal=terminal)
    if bus_info not in bdf_map_iface:
        bdf_map_iface[bus_info] = iface

    if terminal == "client":
        return True

    if bus_info in hns_config.TSG_BDFS:
        msg_center.info(f"保存{terminal}端获取{iface}及其bdf号")
        hns_config.TSG_IFACES[iface] = hns_config.TSG_BDFS.get(bus_info)
    return True


def _get_specified_iface(terminal):
    """
    ============================================
    函数说明: 获取网口名
    修改时间: 2023-01-14 15:36:12
    作   者: lwx567203
    ============================================
    """
    ifaces = getattr(hns_config, f"{terminal}_ifaces", [])
    bdfs = getattr(hns_config, f"{terminal}_bdfs", [])

    if not bdfs:
        return ifaces

    ifaces = []
    for bdf in bdfs:
        ifaces.append(ethtool.get_eth_name(bdf, terminal=terminal))
    setattr(hns_config, f"{terminal}_ifaces", ifaces)
    return ifaces


def init_env(terminal):
    """
    =====================================================================
    函数说明: 清除vf和vlan
    修改时间: 2021/12/16 09:18:46
    作    者: lwx567203
    =====================================================================
    """
    hns_ko.insmod_hns_ko(terminal=terminal, roce_flage=0)
    hns_ko.rmmod_roce()
    hns_ko.insmod_vfio_ko(terminal=terminal)
    ifaces = _get_specified_iface(terminal)
    if ifaces:
        for iface in ifaces:
            conf.delete_vf(network=iface, terminal=terminal)
    else:
        conf.delete_vf(network="all", terminal=terminal)
    remove_all_vlan(terminal=terminal)
    add_tcpdump_user(terminal)
    assign_cpufreq(terminal=terminal)

    handler = comm.get_terminal_handler(terminal)
    # 因为docker会加很多规则，这里是为了清除这些规则
    handler.send_command("which iptables")
    if handler.information:
        handler.send_command("iptables -F FORWARD; iptables -A FORWARD -j ACCEPT")

    # evb关闭防火墙，否则iperf不通
    handler.send_command("which firewall-cmd")
    if handler.information:
        handler.send_command("firewall-cmd --state")
        if handler.information.strip() == "running":
            handler.send_command("systemctl stop firewalld.service")

    # 获取远端内存页大小
    handler.send_command("which getconf")
    if handler.information:
        handler.send_command("getconf PAGESIZE")
        try:
            hns_config.PAGESIZE[terminal] = int(handler.information.strip())
        except Exception as error:
            msg_center.error(error)
            hns_config.PAGESIZE[terminal] = 4096
        else:
            pass
        finally:
            pass

    work_ifaces = _get_specified_iface(terminal)
    if not work_ifaces:
        handler.send_command(f"ip a | grep {handler.hostip} | awk '{{printf$NF}}'")
        ssh_iface = handler.information
        handler.send_command(f'ls -v /sys/class/net/ |grep -vE "lo|sit0|{ssh_iface}"')
        work_ifaces = handler.information.splitlines()
        msg_center.info(f"{terminal} work ifaces: {work_ifaces}")

    work_ifaces_hns3 = []
    for iface in work_ifaces:
        handler.send_command(f"{hns_config.ETHTOOL} -i {iface} | grep driver | awk '{{printf$NF}}'")
        if handler.information.strip().lower() != "hns3":
            continue
        conf.ifconfig_basic(iface, "0.0.0.0 up", terminal=terminal)
        conf.clean_ip(iface, iptype="-6", terminal=terminal)
        work_ifaces_hns3.append(iface)
    time.sleep(7)
    port_list = {
        "server": [
            hns_config.LOCAL_ETH_G_LIST,
            hns_config.LOCAL_ETH_XG_LIST,
            hns_config.LOCAL_ETH_LG_LIST,
            hns_config.LOCAL_ETH_CG_LIST,
            hns_config.LOCAL_ETH_200G_LIST,
            hns_config.LOCAL_ETH_100M_LIST
        ],
        "client": [
            hns_config.REMOTE_ETH_G_LIST,
            hns_config.REMOTE_ETH_XG_LIST,
            hns_config.REMOTE_ETH_LG_LIST,
            hns_config.REMOTE_ETH_CG_LIST,
            hns_config.REMOTE_ETH_200G_LIST,
            hns_config.REMOTE_ETH_100M_LIST
        ]
    }
    # 清掉各个速率的网口列表，防止多次调用本函数时，在__save_iface_name__函数多次往速率列表叠加相同的网口
    for portlist in port_list.get(terminal, []):
        portlist.clear()
    hns_config.TSG_IFACES.clear()
    hns_config.BDF_MAP_IFACE[terminal] = {}
    for iface in work_ifaces_hns3:
        __save_iface_name__(iface, terminal, hns_config.BDF_MAP_IFACE[terminal])


def init_net_port_list():
    """
    #!!==================================================================================
    #  方法名字: init_net_port_list方法
    #  方法说明: 获取双端业务网口名称
    #  参数说明: 无
    #  方法返回: 无
    #  方法
    #  生成日期: 2020-10-14
    #  修改记录: 增加是否在tesgine运行的逻辑判断
    #!!==================================================================================
    """
    threads = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    server_init = threads.submit(init_env, "server")
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        init_env("client")
    concurrent.futures.wait([server_init])
    threads.shutdown()


def get_different_speed_ports():
    """
    获取不同速率的网口生成一个全局变量的列表
    获取新的测试网口序列，从NETPROTLIST测试网口序列中选取每种速率/类型各一个网口
    新测试网口序列变量名为DiffSpeedPortList
    :return:
    """
    server_ifaces = [
        hns_config.LOCAL_ETH_G_LIST,
        hns_config.LOCAL_ETH_XG_LIST,
        hns_config.LOCAL_ETH_LG_LIST,
        hns_config.LOCAL_ETH_CG_LIST,
        hns_config.LOCAL_ETH_200G_LIST,
        hns_config.LOCAL_ETH_100M_LIST
    ]

    client_ifaces = [
        hns_config.REMOTE_ETH_G_LIST,
        hns_config.REMOTE_ETH_XG_LIST,
        hns_config.REMOTE_ETH_LG_LIST,
        hns_config.REMOTE_ETH_CG_LIST,
        hns_config.REMOTE_ETH_200G_LIST,
        hns_config.REMOTE_ETH_100M_LIST
    ]

    hns_config.ALL_LOCAL_NETWORK_LIST_ISO.clear()
    hns_config.ALL_REMOTE_NETWORK_LIST_ISO.clear()
    hns_config.LOCAL_DiffSpeedPortList.clear()
    hns_config.REMOTE_DiffSpeedPortList.clear()

    for ifaces in server_ifaces:
        hns_config.ALL_LOCAL_NETWORK_LIST_ISO.extend(ifaces)
        hns_config.LOCAL_DiffSpeedPortList.extend(ifaces[:1])

    for ifaces in client_ifaces:
        hns_config.ALL_REMOTE_NETWORK_LIST_ISO.extend(ifaces)
        hns_config.REMOTE_DiffSpeedPortList.extend(ifaces[:1])
    msg_center.info(f"ALL_LOCAL_NETWORK_LIST_ISO is: {hns_config.ALL_LOCAL_NETWORK_LIST_ISO}")
    msg_center.info(f"ALL_REMOTE_NETWORK_LIST_ISO is: {hns_config.ALL_REMOTE_NETWORK_LIST_ISO}")
    msg_center.info(f"TESGINE_PORT_MAP is: {hns_config.TSG_IFACES}")
    msg_center.info(f"LOCAL_DiffSpeedPortList is: {hns_config.LOCAL_DiffSpeedPortList}")
    msg_center.info(f"REMOTE_DiffSpeedPortList is: {hns_config.REMOTE_DiffSpeedPortList}")
    if hns_config.ENVIRONMENT == 'tesgine':
        msg_center.info(f"TSG_BDFS is: {hns_config.TSG_BDFS}")
        msg_center.info(f"TSG_IFACES is: {hns_config.TSG_IFACES}")


def _check_iface_num():
    """
    ============================================
    函数说明: 检查是否有网口
    修改时间: 2023-02-24 16:36:53
    作   者: lwx567203
    ============================================
    """
    if not hns_config.LOCAL_DiffSpeedPortList:
        pytest.exit("本端没有可用网口")
    if hns_config.ENVIRONMENT == "client" and not hns_config.REMOTE_DiffSpeedPortList:
        pytest.exit("对端没有可用网口")
    if hns_config.ENVIRONMENT == "tesgine" and not hns_config.TSG_IFACES:
        pytest.exit("没有可用的tesgine端口")


def reset_hns_info(iface):
    """
    初始化网口列表
    :return:
    """
    server_iface_ip = [
        (hns_config.LOCAL_ETH_G_LIST, hns_config.LOCAL_TP_IP),
        (hns_config.LOCAL_ETH_XG_LIST, hns_config.LOCAL_10G_IP),
        (hns_config.LOCAL_ETH_LG_LIST, hns_config.LOCAL_25G_IP),
        (hns_config.LOCAL_ETH_CG_LIST, hns_config.LOCAL_100G_IP),
        (hns_config.LOCAL_ETH_200G_LIST, hns_config.LOCAL_200G_IP),
        (hns_config.LOCAL_ETH_100M_LIST, hns_config.LOCAL_100M_IP)
    ]
    client_iface_ip = [
        (hns_config.REMOTE_ETH_G_LIST, hns_config.REMOTE_TP_IP),
        (hns_config.REMOTE_ETH_XG_LIST, hns_config.REMOTE_10G_IP),
        (hns_config.REMOTE_ETH_LG_LIST, hns_config.REMOTE_25G_IP),
        (hns_config.REMOTE_ETH_CG_LIST, hns_config.REMOTE_100G_IP),
        (hns_config.REMOTE_ETH_200G_LIST, hns_config.REMOTE_200G_IP),
        (hns_config.REMOTE_ETH_100M_LIST, hns_config.REMOTE_100M_IP)
    ]
    for index, server_items in enumerate(server_iface_ip):
        if not server_items[0]:
            continue
        if iface not in server_items[0]:
            continue
        ip_index = server_items[0].index(iface)
        client_items = client_iface_ip[index]
        # 两端网口个数不相等，且client端小于server端，停止遍历，返回FAILURE_CODE
        if ip_index + 1 > len(client_items[0]) and hns_config.ENVIRONMENT == "client":
            return FAILURE_CODE

        hns_config.LOCAL_NETWORK_IP = server_items[1][ip_index]
        hns_config.REMOTE_NETWORK_IP = client_items[1][ip_index]
        if not client_items[0]:
            break
        hns_config.REMOTE_NETWORK = client_items[0][ip_index]
        break
    return SUCCESS_CODE


def all_hns_port(terminal="server"):
    """
    删除本端所有的vf设备
    @param
    @return:失败：1；成功，0
    """
    all_port = []
    handler = comm.get_terminal_handler(terminal=terminal)
    handler.send_command("ls -v /sys/class/net/ |grep -v \"sit0\"|grep -v \"lo\"")
    list_net = handler.information.split("\n")
    for iface in list_net:
        # 过滤非HNS3网口
        command = f"ethtool -i {iface} | grep -iE 'driver' | awk '{{printf$NF\" \"}}'"
        handler.send_command(command)
        if handler.information != "hns3":
            continue
        # 过滤VF
        handler.send_command(f"ls /sys/class/net/{iface}/device/ | grep -i physfn")
        if handler.information.lower() not in ("", None):
            continue
        # 过滤pxe口
        handler.send_command(f"ifconfig {iface} | grep {handler.hostip}")
        if handler.information != "":
            continue
        all_port.append(iface)

    # 上下电/重启后up tesgine网口，若所接tegsine速率改变则需要修改, 当前适配server端对接一个tesgine网口的情况
    if hns_config.TSG_BDFS == {}:
        msg_center.info("未传入tesgine信息")
    else:
        msg_center.info("已传入tesgine信息，识别为tesgine测试环境，检测网口是否正常up")
        for iface in all_port:
            bus_info = ethtool.get_iface_bdf(iface, terminal=terminal)
            if bus_info == list(hns_config.TSG_BDFS.keys())[-1]:
                status = handler.send_command(
                    "ethtool %s |grep 'Link detected'|awk '{print $NF}'" % iface)
                if status == "yes":
                    msg_center.info(f"check {iface} up ok")
                else:
                    handler.send_command(
                        f"{hns_config.ETHTOOL} -s {iface} autoneg off speed 25000 duplex full")
                    handler.send_command(
                        f"{hns_config.ETHTOOL} --set-fec {iface} encoding auto")
                    handler.send_command(f"ifconfig {iface} up")
                    time.sleep(5)
                    continue

    msg_center.info(f"获取到的网口为{all_port}")
    return all_port


def assign_cpufreq(terminal="server"):
    """
    =====================================================================
    函数说明: NA
    修改时间: 2021/12/16 15:13:04
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    handler.send_command("uname -r | awk -F'.' '{print $2}'")
    if int(handler.information) < 9:
        return True
    handler.send_command("ls -v /sys/devices/system/cpu/cpufreq/ | grep policy")
    for policy in handler.information.splitlines():
        handler.send_command(f"echo performance > /sys/devices/system/cpu/cpufreq/{policy}/scaling_governor")
    return True


def clean_env_config(terminal="server"):
    """
    ============================================
    函数说明: 清除环境配置
    修改时间: 2023-03-01 11:16:34
    作   者: lwx567203
    ============================================
    """
    ifaces = {"server": hns_config.ALL_LOCAL_NETWORK_LIST_ISO,
              "client": hns_config.ALL_REMOTE_NETWORK_LIST_ISO}.get(terminal, [])
    ethtool.clean_rss_config(terminal=terminal, iface=ifaces)


def config_tesgine_port(iface):
    """
    =========================================cd ===
    函数说明: 配置tesgine端口
    修改时间: 2023-03-01 10:57:36
    作   者: lwx567203
    ============================================
    """
    if hns_config.ENVIRONMENT != 'tesgine':
        return SUCCESS_CODE

    port = hns_config.TSG_IFACES.get(iface, 0)
    if not port:
        return SUCCESS_CODE

    src_mac = f"00:{port:02x}:{random.randint(0, 255):02x}:{random.randint(0, 255):02x}:00:00"
    kwargs = dict(dut_ip=hns_config.LOCAL_NETWORK_IP, local_ip=hns_config.REMOTE_NETWORK_IP, src_mac=src_mac)
    ssh.tesgine.set_arp(port, **kwargs)

    ethtool.check_port_up(iface)

    result = conf.ping(iface, None, hns_config.REMOTE_NETWORK_IP, loss=True)
    if result != SUCCESS_CODE:
        pytest.exit(f"{iface}与tesgine端口{port}不通")

    hns_config.TESGINE_MACS[port] = src_mac
    hns_config.TESGINE_IPS[port] = hns_config.REMOTE_NETWORK_IP

    if not hns_config.TSG_SRC_MAC:
        hns_config.TSG_SRC_MAC = src_mac
    if not hns_config.TESGINE_IP:
        hns_config.TESGINE_IP = hns_config.REMOTE_NETWORK_IP


def basic_config():
    """
    基础配置
    :return:
    """
    init_net_port_list()
    get_different_speed_ports()
    _check_iface_num()
    for network in hns_config.ALL_LOCAL_NETWORK_LIST_ISO:
        # 其中一端没有相应网口，跳过本次循环
        if reset_hns_info(network) != SUCCESS_CODE:
            continue
        conf.ifconfig_basic(network, "mtu 1500", terminal="server")
        conf.set_ip(local_eth=network, local_ip=hns_config.LOCAL_NETWORK_IP)
        # 2023/03/10: Nezha项目修改mac地址
        conf.set_last_two_mac(network, terminal="server")

        config_tesgine_port(network)

        if hns_config.ENVIRONMENT == 'client':
            conf.ifconfig_basic(hns_config.REMOTE_NETWORK, "mtu 1500", terminal="client")
            conf.set_ip(remote_eth=hns_config.REMOTE_NETWORK, remote_ip=hns_config.REMOTE_NETWORK_IP)
            # 2023/03/10: Nezha项目修改mac地址
            conf.set_last_two_mac(hns_config.REMOTE_NETWORK, terminal="client")

    threads = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    server_init = threads.submit(clean_env_config, "server")
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        clean_env_config("client")
    concurrent.futures.wait([server_init])
    threads.shutdown()


def add_tcpdump_user(terminal):
    """
    =====================================================================
    函数名称 : add_tcpdump_user
    函数说明 :
    参数说明 :
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    handler.send_command("id tcpdump")
    if handler.ret_code == SUCCESS_CODE:
        return SUCCESS_CODE
    handler.send_command("busybox adduser tcpdump -D")
    if "command not found" in handler.information:
        handler.send_command("adduser tcpdump")
    return SUCCESS_CODE


def remove_all_vlan(terminal="server"):
    """
    删除本端所有的vlan设备
    @param
    @return:失败:1；成功:0
    """
    ifaces = {
        "server": hns_config.server_ifaces,
        "client": hns_config.client_ifaces
    }.get(terminal, [])
    if not ifaces:
        info = comm.exec_command(terminal, "ls -v /sys/class/net/ | grep -Ev 'lo|sit0|\\.'")
        ifaces = info.splitlines()
    for iface in ifaces:
        comm.delete_vlan(iface, terminal=terminal)


def kill_all_process(terminal="server"):
    """
    用例执行前删除发包进程
    """
    comm.kill_process('iperf', terminal=terminal)
    comm.kill_process('ptp4l', terminal=terminal)
    comm.kill_process('mz', terminal=terminal)
