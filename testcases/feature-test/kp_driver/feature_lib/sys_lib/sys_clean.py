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

import re
import time
import os

from feature_lib.sys_lib.sys_util import SysUtil as sys_base_info
from test_config.feature_config.dpdk_config.dpdk_config import dpdk_config
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config import lava_global


class SysClean:
    """
    系统恢复环境公共函数库
    """

    @staticmethod
    def fn_get_ip_config(env_name):
        ip_dict = {
            "double_nic": {
                "hns_TP_0": "192.168.20.11",
                "hns_TP_1": "192.168.30.11",
                "hns_TP_2": "192.168.60.11",
                "hns_TP_3": "192.168.70.11",
                "hns_FP_0": "192.168.10.11",
                "hns_FP_1": "192.168.50.11",
                "hns_FP_2": "192.168.80.11",
                "hns_FP_3": "192.168.90.11",
                "82599_1": "192.168.40.11",
            },
            "double_roce": {
                "hns_TP_0": "192.168.20.11",
                "hns_TP_1": "192.168.30.11",
                "hns_TP_2": "192.168.60.11",
                "hns_TP_3": "192.168.70.11",
                "hns_FP_0": "192.168.10.11",
                "hns_FP_1": "192.168.50.11",
                "hns_FP_2": "192.168.80.11",
                "hns_FP_3": "192.168.90.11",
                "82599_1": "192.168.40.11",
            },
            "double_dpdk": {
                "hns_TP_0": "192.168.20.11",
                "hns_TP_1": "192.168.30.11",
                "hns_TP_2": "192.168.60.11",
                "hns_TP_3": "192.168.70.11",
                "hns_FP_0": "192.168.10.11",
                "hns_FP_1": "192.168.50.11",
                "hns_FP_2": "192.168.80.11",
                "hns_FP_3": "192.168.90.11",
                "mlx_0": "192.168.100.11",
                "mlx_1": "192.168.110.11",
                "82599_1": "192.168.40.11",
            },
            "double_nic_cp": {
                "hns_TP_0": "192.168.20.12",
                "hns_TP_1": "192.168.30.12",
                "hns_TP_2": "192.168.60.12",
                "hns_TP_3": "192.168.70.12",
                "hns_FP_0": "192.168.10.12",
                "hns_FP_1": "192.168.50.12",
                "hns_FP_2": "192.168.80.12",
                "hns_FP_3": "192.168.90.12",
                "82599_1": "192.168.40.12",
            },
            "double_dpdk_cp": {
                "hns_TP_0": "192.168.20.12",
                "hns_TP_1": "192.168.30.12",
                "hns_TP_2": "192.168.60.12",
                "hns_TP_3": "192.168.70.12",
                "hns_FP_0": "192.168.10.12",
                "hns_FP_1": "192.168.50.12",
                "hns_FP_2": "192.168.80.12",
                "hns_FP_3": "192.168.90.12",
                "mlx_0": "192.168.100.12",
                "mlx_1": "192.168.110.12",
                "82599_1": "192.168.40.12",
            },
            "double_roce_cp": {
                "hns_TP_0": "192.168.20.12",
                "hns_TP_1": "192.168.30.12",
                "hns_TP_2": "192.168.60.12",
                "hns_TP_3": "192.168.70.12",
                "hns_FP_0": "192.168.10.12",
                "hns_FP_1": "192.168.50.12",
                "hns_FP_3": "192.168.90.12",
                "82599_1": "192.168.40.12",
                "mlx_1": "192.168.80.12"
            },
            "double_pcie": {
                "hns_TP_0": "192.168.20.11",
                "hns_TP_1": "192.168.30.11",
                "hns_FP_0": "192.168.40.11",
                "hns_FP_1": "192.168.50.11",
                "82599_0": "192.168.10.11",
                "82599_1": "192.168.60.11",
                "x550_0": "192.168.70.11",
                "x550_1": "192.168.80.11",
                "mlx_0": "192.168.100.11",
                "mlx_1": "192.168.90.11",
                "i350_0": "192.168.110.11",
                "i350_1": "192.168.120.11",
                "i350_2": "192.168.130.11",
                "i350_3": "192.168.140.11",
            },
            "double_pcie_cp": {
                "hns_TP_0": "192.168.20.12",
                "hns_TP_1": "192.168.30.12",
                "hns_FP_0": "192.168.40.12",
                "hns_FP_1": "192.168.50.12",
                "82599_0": "192.168.10.12",
                "82599_1": "192.168.60.12",
                "x550_0": "192.168.70.12",
                "x550_1": "192.168.80.12",
                "mlx_0": "192.168.100.12",
                "mlx_1": "192.168.90.12",
                "i350_0": "192.168.110.12",
                "i350_1": "192.168.120.12",
                "i350_2": "192.168.130.12",
                "i350_3": "192.168.140.12",
            },
            "double_x6000": {
                "hns_TP_0": "192.168.10.11",
                "hns_TP_1": "192.168.20.11",
                "hns_FP_0": "192.168.30.11",
                "82599_1": "192.168.40.11"
            },
            "double_x6000_cp": {
                "hns_TP_0": "192.168.10.12",
                "hns_TP_1": "192.168.20.12",
                "hns_FP_0": "192.168.30.12",
                "82599_1": "192.168.40.12"
            },
            "double_dfx": {
                "hns_TP_0": "192.168.20.11",
                "hns_FP_0": "192.168.50.11",
                "hns_FP_1": "192.168.10.11",
                "82599_1": "192.168.40.11"
            },
            "double_dfx_cp": {
                "hns_TP_0": "192.168.20.12",
                "hns_FP_0": "192.168.50.12",
                "hns_FP_1": "192.168.10.12",
                "82599_0": "192.168.40.12"
            }
        }
        ip_config = ip_dict.get(env_name, '')
        return ip_config

    @staticmethod
    def fn_analys_ip_a(ip_a):
        # 以{网口名:IP}字典形式
        port_ip_dict = dict()

        start_tag = True
        cur_port = ""
        for i in ip_a.splitlines():
            net_port = re.findall(r"^\d+\:\s*([^\:]+)\:", i)
            if net_port:
                if start_tag == False:
                    port_ip_dict[cur_port] = ""
                else:
                    start_tag = False
                cur_port = net_port[0]
                continue
            if start_tag == False:
                net_ip = re.findall(r"inet\s*([\d\.]+)\/", i)
                if not net_ip:
                    continue
                start_tag = True
                port_ip_dict[cur_port] = net_ip[0]
        if start_tag == False:
            port_ip_dict[cur_port] = ""

        msg_center.debug("analyse port:ip:\n%s" % port_ip_dict)
        return port_ip_dict

    def fn_get_net_info(self):
        # 获取本端ip a信息
        ip_a = lava_global.feature_global.server_ssh.send_command("ip a", disable_show_and_log=True)
        msg_center.info("-------------获取本端网口ip信息-------------:\n%s" % ip_a)
        ip_a = self.fn_analys_ip_a(ip_a)
        # 获取对端ip a信息
        ip_a_cp = lava_global.feature_global.client_ssh.send_command("ip a", disable_show_and_log=True)
        msg_center.info("-------------获取对端网口ip信息-------------:\n%s" % ip_a_cp)
        ip_a_cp = self.fn_analys_ip_a(ip_a_cp)
        # 以{网口名:IP}字典形式，返回两端的ip a信息
        return ip_a, ip_a_cp

    @staticmethod
    def get_port_ethtool(port_name, tc=False):
        cmd = "ethtool {}".format(port_name)
        if tc:
            port_ethtool = lava_global.feature_global.client_ssh.send_command(cmd, disable_show_and_log=True).strip()
        else:
            port_ethtool = lava_global.feature_global.server_ssh.send_command(cmd, disable_show_and_log=True).strip()
        ethtool_dic = {}
        last_key = ""
        for i in port_ethtool.split("\n")[1:]:
            if ":" in i:
                this_dic = i.strip().split(":")
                ethtool_dic[this_dic[0].strip()] = this_dic[1].strip()
                last_key = this_dic
            else:
                ethtool_dic[last_key[0]] += ", " + i.strip()

        msg_center.debug("input cmd: ethtool {}".format(port_name))
        for i in ethtool_dic:
            msg_center.debug(i + " : " + ethtool_dic.get(i))
        msg_center.debug("###############################")
        return ethtool_dic

    @staticmethod
    def get_port_ethtool_i(port_name, tc=False):
        cmd = "ethtool -i {}".format(port_name)
        if tc:
            port_ethtool = lava_global.feature_global.client_ssh.send_command(cmd, disable_show_and_log=True).strip()
        else:
            port_ethtool = lava_global.feature_global.server_ssh.send_command(cmd, disable_show_and_log=True).strip()
        ethtool_dic = {}
        for i in port_ethtool.split("\n"):
            if ":" in i:
                this_dic = i.strip().split(":")
                ethtool_dic[this_dic[0].strip()] = ":".join(this_dic[1:]).strip()

        msg_center.debug("input cmd: ethtool -i {}".format(port_name))
        for i in ethtool_dic:
            msg_center.debug(i + " : " + ethtool_dic.get(i))
        msg_center.debug("###############################")
        return ethtool_dic

    def get_port_dic(self, port_list, tc=False):
        """
        通过驱动类型、光电口类型，区分网卡不同分组，为其重新编号，与网卡IP配置表的关系对应
        当前网卡有hns_TP、hns_FP、82599、i350、x550、mlx
        若同一类型卡插了多张，则编号递增：
        如两张82599网卡，网口编号分别为82599_0~82599_3，0、1为同一张网卡，2、3为同一张网卡
        :param tc: 对端执行则为True
        :param port_list: ["eno0", "enp0]
        :return: {"eno0":"hns_TP_0","enp0":"82599_0" }
        """
        port_dic = {}
        port_list = sorted(port_list)

        # 将外置网卡添加到list，当遇到同类型卡插了多张的时候，用于编号递增
        other_port = []
        for i in port_list:
            if "vir" in i or "docker" in i or '@NONE' in i or "lo" in i:
                continue
            elif "@" in i:
                other_port.append(i)
                continue
            # 获取ethtool和ethtool -i信息，返回字典，根据字段名获取需要的端口、速率、驱动信息
            port_ethtool = self.get_port_ethtool(i, tc=tc)
            port_type = port_ethtool.get("Supported ports", "").strip("[]").strip()
            port_width = port_ethtool.get("Supported link modes", "")
            port_driver = self.get_port_ethtool_i(i, tc=tc).get("driver", "")
            port_bus = self.get_port_ethtool_i(i, tc=tc).get("bus-info", "")

            msg_center.debug(i + ": " + port_type + ", " + port_driver + ", " + port_width)
            if port_driver == "hns3":
                if not str(port_bus.strip().split(":")[-1]).startswith("00"):
                    other_port.append(i)
                # 板载电口
                elif port_type == "TP":
                    port_dic[i] = "hns_TP_" + str(port_bus.strip()[-1])
                # 板载光口
                elif port_type == "FIBRE":
                    port_dic[i] = "hns_FP_" + str(port_bus.strip()[-1])
                else:
                    other_port.append(i)
            elif port_driver == "ixgbe":
                # x550
                if port_type == "TP":
                    port_dic[i] = "x550_" + str(port_bus.strip()[-1])
                # 82599
                elif port_type == "FIBRE":
                    port_dic[i] = "82599_" + str(port_bus.strip()[-1])
                else:
                    other_port.append(i)
            # mlx
            elif port_driver == "mlx5_core":
                port_dic[i] = "mlx_" + str(port_bus.strip()[-1])
            # i350
            elif port_driver == "igb":
                port_dic[i] = "i350_" + str(port_bus.strip()[-1])
            # 1822
            elif port_driver == "hinic":
                port_dic[i] = "1822_" + str(port_bus.strip()[-1])
            else:
                other_port.append(i)
        return port_dic, other_port

    def fn_check_ip_exist(self, ip_a, ip_config, tc=False):
        """
        对比当前和预期的两端ip，返回异常网口信息，ip丢失、ip不通等
        :param ip_a:
        :param ip_config:
        :param tc:
        :return:
        """
        # port_dic={"eno1":"hns_tp_0"}，记录ip a中捞取到的有效网口
        # other_port，去掉无效网口和有效网口后的其他网口，用于下一步从中捞取vf、vlan等
        port_dic, other_port = self.get_port_dic(list(ip_a.keys()), tc=tc)
        err_net = []
        succ_net = []
        port_ip_config = dict()
        for i in port_dic:
            if port_dic.get(i) not in ip_config.keys():
                other_port.append(i)
            else:
                port_ip_config[i] = ip_config.get(port_dic.get(i))
                if port_ip_config.get(i) != ip_a.get(i):
                    err_net.append(i)
                else:
                    succ_net.append(i)
        return err_net, succ_net, other_port, port_ip_config

    @staticmethod
    def fn_check_other_port(other_port, tc=False):
        # vlan
        vlan_list = []
        # vf
        vf_list = []
        for i in other_port:
            if "@" in i:
                vlan_list.append(i)
            else:
                # 判断是否是VF口
                cmd = f"ls /sys/class/net/{i}/device/physfn/net"
                if tc:
                    vf_check = lava_global.feature_global.client_ssh.send_command(cmd)
                    ret_check = lava_global.feature_global.client_ssh.ret_code
                else:
                    vf_check = lava_global.feature_global.server_ssh.send_command(cmd)
                    ret_check = lava_global.feature_global.server_ssh.ret_code
                if ret_check == 0 and vf_check.strip() not in vf_list:
                    vf_list.append(vf_check.strip())
        return vlan_list, vf_list

    @staticmethod
    def fn_get_port_from_ip(ip_a, ip):
        for dict_port, dict_ip in ip_a.items():
            ip_split = ip.split('.')
            if len(ip_split) < 4:
                return False
            ip_segment = ip_split[0] + '.' + ip_split[1] + '.' + ip_split[2]
            if ip_segment in dict_ip:
                msg_center.debug("ip %s is matched with %s in other server" % (ip, dict_port))
                return dict_port
        msg_center.warning(f"{ip_a} not found {ip}")
        return False

    def fn_check_err_port(self, err_net, succ_net, port_dict, err_net_cp, succ_net_cp, port_dict_cp):
        for i in err_net_cp:
            local_port = self.fn_get_port_from_ip(port_dict, port_dict_cp[i])
            if local_port not in err_net and local_port in port_dict.keys():
                msg_center.debug("err_net append %s" % local_port)
                err_net.append(local_port)
            if local_port in succ_net:
                succ_net.remove(local_port)
        if len(err_net) == len(err_net_cp):
            return
        for i in err_net:
            remote_port = self.fn_get_port_from_ip(port_dict_cp, port_dict[i])
            if remote_port not in err_net_cp and remote_port in port_dict_cp.keys():
                msg_center.debug("err_net_cp append %s" % remote_port)
                err_net_cp.append(remote_port)
            if remote_port in succ_net_cp:
                succ_net_cp.remove(remote_port)

    def fn_ping_test(self, err_net, err_net_cp, succ_net, succ_net_cp, sut_ip_dict, tc_ip_dict):
        """
        err_net：本端有问题的网口列表
        err_net_cp：对端有问题的网口列表
        检查当前所有网口是否能ping通，如不通则执行一些恢复的操作
        """
        pass_nic_list = []
        fail_nic_list = []
        for i in range(3):
            for tc_port, tc_ip in tc_ip_dict.items():
                if tc_port in succ_net_cp:
                    cmd = f"ping -c 2 {tc_ip} > {tc_ip}.log"
                    lava_global.feature_global.server_ssh.send_command(f"echo '{cmd}' >> nic_check.sh",
                                                                       disable_show_and_log=True)
            lava_global.feature_global.server_ssh.send_command("bash nic_check.sh", disable_show_and_log=True)
            lava_global.feature_global.server_ssh.send_command("rm -f nic_check.sh", disable_show_and_log=True)
            for tc_port, ping_ip in tc_ip_dict.items():
                nic_result = lava_global.feature_global.server_ssh.send_command(f"cat {ping_ip}.log",
                                                                                disable_show_and_log=True)
                if " 0% packet loss" in nic_result:
                    if ping_ip not in pass_nic_list:
                        pass_nic_list.append(ping_ip)
                else:
                    if ping_ip not in fail_nic_list:
                        fail_nic_list.append(ping_ip)
                    if ping_ip in pass_nic_list:
                        pass_nic_list.remove(ping_ip)
                lava_global.feature_global.server_ssh.send_command(f"rm -f {ping_ip}.log", disable_show_and_log=True)
            if len(fail_nic_list) == 0:
                break
            else:
                time.sleep(2)

        for fail_nic in fail_nic_list:
            sut_port = self.fn_get_port_from_ip(sut_ip_dict, fail_nic)
            tc_port = self.fn_get_port_from_ip(tc_ip_dict, fail_nic)
            if sut_port in succ_net:
                err_net.append(sut_port)
                err_net_cp.append(tc_port)
                succ_net.remove(sut_port)
                succ_net_cp.remove(tc_port)
        return pass_nic_list

    @staticmethod
    def fn_net_up_down(port, os_name, up=False, tc=False):
        if up:
            if os_name in ["ubuntu"]:
                command = f"ip link set {port} up"
            else:
                command = f"ifup {port}"
        else:
            if os_name in ["ubuntu"]:
                command = f"ip link set {port} down"
            else:
                command = f"ifdown {port}"
        if tc:
            lava_global.feature_global.client_ssh.send_command(command)
        else:
            lava_global.feature_global.server_ssh.send_command(command)

    def fn_net_restore(self, os_name, os_name_cp, err_net, err_net_cp, pass_nic_list):
        # 对异常网口进行up down
        ssh_ip = pass_nic_list[0]
        # 对异常网口进行down up
        if len(err_net) == len(err_net_cp):
            for err_index in range(len(err_net)):
                err_port = err_net[err_index]
                err_port_cp = err_net_cp[err_index]
                self.fn_net_up_down(err_port, os_name)
                self.fn_net_up_down(err_port_cp, os_name_cp, tc=True)
                time.sleep(3)
                self.fn_net_up_down(err_port, os_name, up=True)
                self.fn_net_up_down(err_port_cp, os_name_cp, up=True, tc=True)
        else:
            msg_center.error(f"sut error net:{err_net},tc error net:{err_net_cp},function is error")

    @staticmethod
    def fn_rm_vlan(os_name, vlan_list, tc=False):
        """
        清除本端或对端多余的vlan
        :param vlan_list :传入多余的vlan网口列表
        :return 清除成功返回TRUE,清理失败返回FALSE
        """
        # 设置标志位，用于判断有多少个网口清除失败
        sign = 0
        # 判断本端和对端传入其他vlan网口是否为空
        if len(vlan_list) == 0:
            msg_center.info("No vlan port exists.don't need clear")
            return True
        else:
            for tmp_port in vlan_list:
                # 判断是否是vlan口
                vlan_port = tmp_port.split('@')[0]
                cmd = f"ethtool -i {vlan_port} |grep driver |grep -io vlan"
                if tc:
                    check_driver = lava_global.feature_global.client_ssh.send_command(cmd)
                else:
                    check_driver = lava_global.feature_global.server_ssh.send_command(cmd)
                if check_driver.lower() == "vlan":
                    msg_center.info(f"{tmp_port} is VLAN port")
                    cmd_del_vlan = f"ip link delete {vlan_port}"
                    if os_name in ["openeuler"]:
                        cmd = "nmcli c show | grep %s | awk '{print $1}'" % vlan_port
                        if tc:
                            vlan_name = lava_global.feature_global.client_ssh.send_command(cmd)
                        else:
                            vlan_name = lava_global.feature_global.server_ssh.send_command(cmd)
                        if vlan_name.strip() != "":
                            cmd = f"nmcli c delete {vlan_name}"
                            if tc:
                                lava_global.feature_global.client_ssh.send_command(cmd)
                            else:
                                lava_global.feature_global.client_ssh.send_command(cmd)
                        else:
                            # 删除vlan口
                            if tc:
                                lava_global.feature_global.client_ssh.send_command(cmd_del_vlan)
                            else:
                                lava_global.feature_global.server_ssh.send_command(cmd_del_vlan)
                    else:
                        # 删除vlan口
                        if tc:
                            lava_global.feature_global.client_ssh.send_command(cmd_del_vlan)
                        else:
                            lava_global.feature_global.server_ssh.send_command(cmd_del_vlan)
                    # 检查是否删除成功
                    cmd = f"ip a |grep -o {vlan_port}"
                    check_result = lava_global.feature_global.server_ssh.send_command(cmd)
                    if vlan_port in check_result:
                        msg_center.error(f"{vlan_port} vlan port delete fail, need to further check")
                        sign += 1
                else:
                    msg_center.info(f"{tmp_port} is not VLAN port, need to further check")
            if sign > 0:
                return False
            return True

    @staticmethod
    def fn_rm_vf(vf_list, tc=False):
        """
        清除本端或对端多余的vf
        :param vf_list :传入多余的vf网口列表
        :return 清除成功返回TRUE,清理失败返回FALSE
        """
        # 设置标志位，用于判断有多少个网口清除失败
        sign = 0
        # 判断本端和对端传入其他vlan网口是否为空
        if len(vf_list) == 0:
            msg_center.info("No VF port exists.don't need clear")
            return True
        else:
            for tmp_port in vf_list:
                cmd = f"echo 0 >/sys/class/net/{tmp_port}/device/sriov_numvfs"
                if tc:
                    lava_global.feature_global.client_ssh.send_command(cmd)
                else:
                    lava_global.feature_global.server_ssh.send_command(cmd)
                # 检查是否删除成功
                cmd = f"ip a |grep -o {tmp_port}"
                if tc:
                    check_result = lava_global.feature_global.client_ssh.send_command(cmd)
                else:
                    check_result = lava_global.feature_global.server_ssh.send_command(cmd)
                if tmp_port in check_result:
                    msg_center.error(f"{tmp_port} vf port delete fail, need to further check")
                    sign += 1
            if sign > 0:
                return False
            return True

    @staticmethod
    def fn_check_vfio_port():
        """
        检查本对端是否有网口绑在vfio上
        :return vfio_bus_list :本端绑在vfio上的口，vfio_bus_list_cp :对端绑在vfio上的口
        """
        vfio_bus_list = []
        vfio_bus_list_cp = []
        if os.path.exists(dpdk_config.dpdk_devbind):
            vfio_info = lava_global.feature_global.server_ssh.send_command(
                f"{dpdk_config.dpdk_devbind} -s | grep 'drv=vfio-pci'")
            cmd = f"{dpdk_config.dpdk_devbind} -s | grep 'drv=vfio-pci'"
            vfio_info_cp = lava_global.feature_global.client_ssh.send_command(cmd)
            if len(vfio_info) != 0:
                for vfio_line in vfio_info.split("/r"):
                    vfio_bus = vfio_line.split()[0]
                    vfio_bus_list.append(vfio_bus)
                    msg_center.error(f"sut vfio port bus {vfio_bus_list}")
            if len(vfio_info_cp) != 0:
                for vfio_line_cp in vfio_info_cp.split("/r"):
                    vfio_bus_cp = vfio_line_cp.split()[0]
                    vfio_bus_list_cp.append(vfio_bus_cp)
                    msg_center.error(f"tc vfio port bus {vfio_bus_list_cp}")
        return vfio_bus_list, vfio_bus_list_cp

    @staticmethod
    def dpdk_check_nic_status(nic_bus_info, tc=False, dpdk_v=dpdk_config.dpdk_version):
        """
        函数功能：检查nic绑定的驱动，请调用者务必保证入参格式合法
        参数说明：nic_bus_info：【字符串】，网口bus_info
        dpdk_config.dpdk_version：【字符串】，dpdk版本号，冗余参数
        返回值：0--绑定到igb_uio
        1--绑定到vfio_pci
        2--绑定到其他驱动
        4--错误
        调用示范：dpdk_check_nic_status("0000:7d:00.0", "dpdk-20.02")
        """
        cmd = f"{dpdk_config.dpdk_devbind} -s |grep -i {nic_bus_info}"
        if tc:
            ret = lava_global.feature_global.client_ssh.send_command(cmd)
        else:
            ret = lava_global.feature_global.server_ssh.send_command(cmd)
        if "drv=igb_uio" in ret:
            bind_status = 0
            msg_center.info(f"bus_info:{nic_bus_info} bind to igb_uio")
        elif "drv=vfio-pci" in ret:
            bind_status = 1
            msg_center.info(f"bus_info:{nic_bus_info} bind to vfio-pci")
        elif "drv=hns3" in ret:
            bind_status = 2
            msg_center.info(f"bus_info:{nic_bus_info} bind to hns3")
        else:
            bind_status = 4
            msg_center.error("error: unknown driver!")
        return bind_status

    def dpdk_nic_bind_driver(self, nic_bus_info, driver_type, tc=False):
        """
        Description: 将网口绑到dpdk驱动，支持本端或对端操作
        :param nic_bus_info: 网口bus号
        :param driver_type: 驱动名支持：vfio-pci，hns，以及igb_uio
        :param sut_tc: "sut" 或者 "tc"
        :return: True or False
        Examples: dpdk_nic_bind_driver("0000:7d:00.1", "vfio-pci", "sut")
        """
        cmd = f"{dpdk_config.dpdk_devbind} -b {driver_type} {nic_bus_info}"
        if tc:
            lava_global.feature_global.client_ssh.send_command(cmd)
        else:
            lava_global.feature_global.server_ssh.send_command(cmd)
        ret = self.dpdk_check_nic_status(nic_bus_info, tc, dpdk_config.dpdk_version)
        if driver_type == "igb_uio" and ret != 0:
            msg_center.error(f"本端网口绑{driver_type}失败")
            return False
        elif driver_type == "vfio-pci" and ret != 1:
            msg_center.error(f"本端网口绑{driver_type}失败")
            return False
        elif ret == 4:
            msg_center.error("本端非法驱动!")
            return False
        else:
            msg_center.info(f"本端网口绑{driver_type}成功")
            return True

    def fn_restore_dpdk(self, vfio_bus_list, vfio_bus_list_cp):
        """
        检查并恢复本对端是否有网口绑在vfio上
        :return 清除成功返回TRUE,清理失败返回FALSE
        """
        if len(vfio_bus_list) != 0:
            for sut_dpdk in vfio_bus_list:
                self.dpdk_nic_bind_driver(sut_dpdk, "hns3")
        if len(vfio_bus_list_cp) != 0:
            for tc_dpdk in vfio_bus_list_cp:
                self.dpdk_nic_bind_driver(tc_dpdk, "hns3", tc=True)
        vfio_bus_list_check, vfio_bus_list_cp_check = self.fn_check_vfio_port()
        if len(vfio_bus_list_check) == 0 and len(vfio_bus_list_cp_check) == 0:
            msg_center.info(f"dpdk restore is succ")
            return True
        else:
            msg_center.error(f"dpdk restore is fail")
            msg_center.error(f"sut dpdk {vfio_bus_list_check}, tc dpdk {vfio_bus_list_cp_check}")
            return False

    def fn_nic_environment_check(self):
        msg_center.info("-------- 开始检查环境 --------")
        # 检查结果标志位，默认True，若为False，说明检查失败
        env_status = True
        # 临时文件，在失败时候保存检查失败结果，提供给shell脚本获取检查结果用
        log_file = "/tmp/fn_nic_environment_check"
        lava_global.feature_global.server_ssh.send_command(f"rm -f {log_file}")

        # 获取当前环境类型
        env_type, env_type_cp = sys_base_info.fn_get_env_type()
        msg_center.info("本端环境类型: %s，对端环境类型: %s" % (env_type, env_type_cp))
        # 单机、等不需要检查的环境添加进来
        no_check_env = ["double_pcie", "double_pcie_cp"]
        # 在待检查的环境类型范围外则直接退出
        if env_type in no_check_env or env_type == "":
            msg_center.info("当前单板不需要检查环境！")
            return True

        # 获取双端os名
        os_name = sys_base_info.fn_get_os_name()
        msg_center.info("本端OS类型: %s" % os_name)
        os_name_cp = sys_base_info.fn_get_os_name(tc=True)
        msg_center.info("对端OS类型: %s" % os_name_cp)
        # 在待检查的os范围外则直接退出
        if os_name in ["uos"]:
            msg_center.info("当前单板是uos系统，不需要检查环境！")
            return True

        # 获取预期的{网口:ip}键值对
        ip_config = self.fn_get_ip_config(env_type)
        ip_config_cp = self.fn_get_ip_config(env_type_cp)
        msg_center.debug("本端ip信息: \n%s " % ip_config)
        msg_center.debug("对端ip信息: \n%s " % ip_config_cp)
        if ip_config == "" or ip_config_cp == "":
            msg_center.warning("当前单板不需要检查环境！")
            return True
        # 获取两端的ip a信息，以{网口名:IP}字典形式返回
        sut_config_ip = []
        for sut_nic_config, sut_ip_config in ip_config.items():
            sut_config_ip.append(sut_ip_config)
        for times in range(3):
            # 判断网口信息是否有丢失, 直接对比
            ip_a, ip_a_cp = self.fn_get_net_info()
            err_net, succ_net, other_port, port_dict = self.fn_check_ip_exist(ip_a, ip_config)
            msg_center.info("本端异常网口信息: %s" % err_net)
            msg_center.debug("本端正常网口信息: %s" % succ_net)
            msg_center.debug("本端 other_port（非常规网卡）信息: %s" % other_port)
            msg_center.debug("本端 port_dict 信息: %s" % port_dict)
            err_net_cp, succ_net_cp, other_port_cp, port_dict_cp = self.fn_check_ip_exist(ip_a_cp, ip_config_cp,
                                                                                          tc=True)
            msg_center.info("对端异常网口信息: %s" % err_net_cp)
            msg_center.debug("对端正常网口信息: %s" % succ_net_cp)
            msg_center.debug("对端 other_port（非常规网卡）信息: %s" % other_port_cp)
            msg_center.debug("对端 port_dict 信息: %s" % port_dict_cp)
            if len(err_net) == 0 and len(err_net_cp) == 0:
                break
            else:
                msg_center.info(f"本端异常网口信息:{err_net},对端异常网口信息:{err_net_cp}")
                msg_center.info("本端或者对端网口异常！")
                time.sleep(2)

        self.fn_check_err_port(err_net, succ_net, port_dict, err_net_cp, succ_net_cp, port_dict_cp)
        msg_center.info("ip信息校验后，本端异常网口信息: %s" % err_net)
        msg_center.debug("ip信息校验后，本端正常网口信息: %s" % succ_net)
        msg_center.info("ip信息校验后，对端异常网口信息: %s" % err_net_cp)
        msg_center.debug("ip信息校验后，对端正常网口信息: %s" % succ_net_cp)
        msg_center.info("本端 other_port（非常规网卡）信息: %s" % other_port)
        msg_center.info("对端 other_port（非常规网卡）信息: %s" % other_port_cp)
        # 加一个ping的函数
        pass_nic_list = self.fn_ping_test(err_net, err_net_cp, succ_net, succ_net_cp, port_dict, port_dict_cp)
        if len(err_net) != 0 or len(err_net_cp) != 0:
            msg_center.warning("ping测试失败，以下网口ping不通：")
            msg_center.warning("本端网口: %s" % err_net)
            msg_center.warning("对端网口: %s" % err_net_cp)
            env_status = False

        # 检查vlan、vf等遗留
        vlan_list, vf_list = self.fn_check_other_port(other_port)
        vlan_list_cp, vf_list_cp = self.fn_check_other_port(other_port_cp, tc=True)
        if len(vlan_list) != 0 or len(vlan_list_cp) != 0:
            msg_center.warning("vlan检测失败，当前环境存在vlan：")
            msg_center.warning("本端存在以下vlan: %s" % vlan_list)
            msg_center.warning("对端存在以下vlan: %s" % vlan_list_cp)
            env_status = False

        if len(vf_list) != 0 or len(vf_list_cp) != 0:
            msg_center.warning("vf检测失败，当前环境存在vf：")
            msg_center.warning("本端存在以下vf: %s" % vf_list)
            msg_center.warning("对端存在以下vf: %s" % vf_list_cp)
            env_status = False

        vfio_bus_list, vfio_bus_list_cp = self.fn_check_vfio_port()
        if len(vfio_bus_list) != 0 or len(vfio_bus_list_cp) != 0:
            msg_center.warning("dpdk 检测失败，当前环境存在dpdk端口（设备）：")
            msg_center.warning("本端存在以下dpdk端口（设备）: %s" % vfio_bus_list)
            msg_center.warning("对端存在以下dpdk端口（设备）: %s" % vfio_bus_list_cp)
            env_status = False

        msg_center.info("-------- 环境检测结束 --------")
        if not env_status:
            lava_global.feature_global.server_ssh.send_command(f"echo 1 > {log_file}")
            return [os_name, os_name_cp, err_net, err_net_cp, pass_nic_list, vlan_list, vlan_list_cp, vf_list,
                    vf_list_cp,
                    vfio_bus_list, vfio_bus_list_cp]
        return env_status

    def fn_env_check_after_test(self):
        check_rst = self.fn_nic_environment_check()
        if type(check_rst) != bool:
            msg_center.info("环境检测失败，当前环境存在残留的配置未清除!!!")
            assert False
        else:
            msg_center.info("环境检测通过，当前环境OK!!!")

    def fn_nic_environment_clean(self):
        check_rst = self.fn_nic_environment_check()
        if type(check_rst) == bool:
            msg_center.info("当前环境OK，无需清理!!!")
            return True
        [os_name, os_name_cp, err_net, err_net_cp, pass_nic_list, vlan_list, vlan_list_cp, vf_list, vf_list_cp,
         vfio_bus_list, vfio_bus_list_cp] = check_rst
        self.fn_restore_dpdk(vfio_bus_list, vfio_bus_list_cp)
        self.fn_net_restore(os_name, os_name_cp, err_net, err_net_cp, pass_nic_list)
        self.fn_rm_vlan(os_name, vlan_list)
        self.fn_rm_vlan(os_name_cp, vlan_list_cp, tc=True)
        self.fn_rm_vf(vf_list)
        self.fn_rm_vf(vf_list_cp, tc=True)
        msg_center.info("环境清理完毕！！！")
        return False
