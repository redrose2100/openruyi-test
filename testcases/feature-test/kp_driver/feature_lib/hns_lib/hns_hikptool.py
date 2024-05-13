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


import re

from common_lib.base_lib.base_config import SUCCESS_CODE, FAILURE_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_test_case_frame import FrameEngine
from common_lib.testengine_lib.engine_utils import check_result
from common_lib.base_lib.base_wait_time import wait_time
from feature_lib.hns_lib import hns_util
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_ko
from feature_lib.hns_lib import hns_eth_attributes
from feature_lib.hns_lib import hns_config_ethtool
from feature_lib.hns_lib.tesgine import hns_tesgine
from test_config.feature_config.hns_config import hns_config
from test_config.feature_config.hns_config.hns_config import global_param as ssh


class HikpToolTest(object):
    """dfx工具"""

    def __init__(self):
        pass

    @staticmethod
    def send_pkt(iface, **kwargs):
        """
        ============================================
        函数说明: 发送报文
        修改时间: 2022-08-23 16:34:53
        作   者: lwx567203
        opstions:
        -q  --queue_id                queue_id %d. default = 0, input must be decimal.
        -t  --type                    %s arp/tcp/tcp_dscp/pause/pause_err/pfc/pfc_err
                                      ipv4/ipv4_loose_option/ipv4_route_option/ipv4_tcp_option
                                      ipv6/ipv6_route/sctp4/sctp6/udp/ipv6_udp/ipv6_tcp_option
                                      ipv6_vxlan_tcp/ipv6_vxlan_udp/geneve_tcp/geneve_udp
                                      nvgre_tcp/nvgre_udp/vxlan_tcp/vxlan_udp, default = arp
        -l  --len                     %d default = 128 ipv4 = 68, ipv6 = 68
                                      sctp4 = 50, sctp6 = 70. input must be decimal.
        -bd  --bd_num                  %d bd num from 1 to 18
        -n  --num                     %d pkt num: default = 1. input must be decimal.
        -m  --mss                     %d default = 1400, input must be decimal.
        -dmac  --dest_mac                %s default = 0xFFFFFFFFFFFF, input must be decimal.
        -dip  --dest_ip                 %s input must be decimal.
        -v  --vlan_tag                %d vlan tag, such as 0x81000001, input must be decimal
                                      type = vlan_tag >> 16
                                      priority = ((vlan_tag & 0xffff) >> 5)
                                      vlan_id = (vlan_tag & 0x0fff)
        -w  --wait_all                wait all pkt send, Be careful to use this
        -c  --create_thread           cereate new thread, no param
                                      send tid = (queue_id / 2) % 16
        -d  --destroy_thread          stop thread
        -M  --multi_queue             %d send pkt for multi-queue begin with value of (-q)
                                      input must be decimal.
        -D  --dscp                    change DESC of TOS, default = 0, input must be decimal.
        -T  --pause_time              set pause time, 0~0xffff, input must be decimal.
        -P  --priority_map            set priority mapping, input must be decimal.
                                       bi0~bit7 for pri0~pri7
        -E  --eth_type                set ether type for pause, input must be decimal.
                                      34824(0x8808) or error
        -C  --pause_opcode            set pause opcode for pause, input must be decimal.
        -l3CS  --l3checksum              0x0/0xf/0xffff/0xffffffff.
        -CS  --checksum                0x0/0xf/0xffff/0xffffffff.
                                      set checksum.default = 0x0,
                                      ipv4:0xffff(2-byte),
                                      sctp:0xffffffff(4-byte)
        -O  --payload                 0/f.set payload.default= 0
        -V6  --ipv6_addr               set inet6_addr,
                                      default = 0000:0000:0000:0000:0000:0000:0000:0000
        -ol  --offload                 1 to set offload.default= 0
        -f  --fraglist                1 to set fraglist.default= 0
        ============================================
        """
        options = {
            "q": "queue_id", "t": "type", "l": "len", "bd": "bd_num", "n": "num", "m": "mss",
            "dmac": "dest_mac", "dip": "dest_ip", "v": "vlan_tag", "w": "wait_all", "c": "create_thread",
            "d": "destroy_thread", "M": "multi_queue", "D": "dscp", "T": "pause_time", "P": "priority_map",
            "E": "eth_type", "C": "pause_opcode", "l3CS": "l3checksum", "CS": "checksum", "O": "payload",
            "V6": "ipv6_addr", "ol": "offload", "f": "fraglist",
        }

        terminal = kwargs.get("terminal", "server")
        output = kwargs.get("output", None)
        back = kwargs.get("back", False)
        kwargs.pop("terminal", "no such key to pop")
        kwargs.pop("output", "no such key to pop")
        kwargs.pop("back", "no such key to pop")

        command = f"{hns_config.HIKPTOOLTEST} pkt -i {iface}"
        for key, value in kwargs.items():
            if key in options.keys():
                command = f"{command} -{key} {value}"
            elif key in options.values():
                command = f"{command} --{key} {value}"
            else:
                pass

        if output:
            command = f"{command} >> {output} 2>&1"
        if back:
            command = f"{command} &"

        result = hns_common.exec_command(terminal, command)
        return result

    @staticmethod
    def get_register_addr(network, ras_addr, terminal="server"):
        """
        =====================================================================
          函数名称 : get_register_addr
          函数说明 : 获取寄存器地址
          参数说明 : network:
                   addr_bit_dict: 寄存器及注错bit的字典
        =====================================================================
        """
        if isinstance(ras_addr, int):
            ras_addr = hex(ras_addr)
        cmd = f"{hns_config.HIKPTOOLTEST} reg -i {network} -a {ras_addr}"
        result = hns_common.exec_command(terminal, cmd)
        value = result.strip().split()[-1]
        try:
            value = int(value, 16)
        except ValueError:
            value = 0xffffffffffffff
        finally:
            pass
        return hex(value)

    @staticmethod
    def hikptool_err_ras(network, kvargs, terminal="server"):
        """
        =====================================================================
          函数名称 : hikptool_err_ras
          函数说明 : 使用hikptool工具注入RAS错误
          参数说明 :
                    network:
                    addr_bit_dict: 寄存器及注错bit的字典
        =====================================================================
        """
        for ras_addr, ras_bit in kvargs.items():
            if str(ras_addr).isdigit():
                ras_addr = hex(ras_addr)
            cmd = f"{hns_config.HIKPTOOLTEST} reg -i {network} -a {ras_addr} -v {ras_bit}"
            result = hns_common.exec_command(terminal, cmd)
            if result != "" and not result.count("Run ioctl failed"):
                return FAILURE_CODE
        return SUCCESS_CODE

    def set_register_addr(self, network, addr, value, terminal="server"):
        """
        =====================================================================
          函数名称 : set_register_addr
          函数说明 : 配置寄存器地址
          参数说明 :
        =====================================================================
        """
        if isinstance(addr, int):
            addr = hex(addr)
        if isinstance(value, int):
            value = hex(value)
        cmd = f"{hns_config.HIKPTOOLTEST} reg -i {network} -a {addr} -v {value}"
        hns_common.exec_command(terminal, cmd)
        rg_value = self.get_register_addr(network, addr, terminal=terminal)
        if int(rg_value, 16) == int(value, 16):
            msg_center.info("修改寄存器地址成功！")
            return SUCCESS_CODE
        msg_center.info("修改寄存器地址失败！")
        return FAILURE_CODE

    @staticmethod
    def hikptool_get_inter(network, terminal="server"):
        """
        =====================================================================
          函数名称 : hikptool_get_inter
          函数说明 : 使用hikptooltest查看网口中断亲和性
          参数说明 : network:
        =====================================================================
        """
        hns_common.clear_dmesg_log(terminal=terminal)
        cmd = f"{hns_config.HIKPTOOLTEST} ext -i {network} -t 0"
        hns_common.exec_command(terminal, cmd)
        dmesg_info = hns_common.exec_command(terminal, f"dmesg -c")
        inter_dict = {}
        for key, value in zip(re.findall(r"irq\s\d+", dmesg_info), re.findall(r"affinity:\s\d+", dmesg_info)):
            inter_dict[key.split(" ")[-1]] = value.split(" ")[-1]
        return inter_dict

    def hikptool_set_inter(self, network, inter_num, terminal="server"):
        """
        =====================================================================
          函数名称 : hikptool_set_inter
          函数说明 : 使用hikptooltest配置网口中断亲和性
          参数说明 :
                    network:
                    inter_num: 中断亲和性所在CPU，16进制数
        =====================================================================
        """
        if isinstance(inter_num, int):
            inter_num = hex(inter_num)
        cmd = f"{hns_config.HIKPTOOLTEST} ext -i {network} -m {inter_num}"
        hns_common.exec_command(terminal, cmd)
        inter_dict = self.hikptool_get_inter(network, terminal=terminal)
        # 判断是否是十六进制数
        inter_num_list = []
        for inter in re.findall(r"[^x]", inter_num):
            if re.findall(r"[g-z]", inter):
                inter_num_list.append(inter)
        for cpu_num in inter_dict.values():
            if "0x" not in inter_num or len(inter_num_list) != 0:
                msg_center.error("配置网口中断亲和性参数异常！")
                return FAILURE_CODE
            else:
                if "0x" + cpu_num != inter_num:
                    msg_center.error("配置网口中断亲和性失败！")
                    return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def get_iface_ext_info(iface, status, terminal="server"):
        """
        ============================================
        函数说明: 查询网口的环回信息
        修改时间: 2023-02-28 14:23:42
        作   者: lwx567203
        ============================================
        """
        cmd = f"{hns_config.HIKPTOOLTEST} ext -i {iface} -t {status}"
        info = hns_common.exec_command(terminal, cmd)
        result = re.findall("(\\w+)\\s?[:=]\\s?\[?(\\d+)\]?", info)
        return dict(result)

    def set_iface_torus(self, iface, enable=0, mac_id=0, terminal="server"):
        """
        ============================================
        函数说明: 配置网口二层转发
        修改时间: 2023-02-28 14:44:10
        作   者: lwx567203
        ============================================
        """
        cmd = f"{hns_config.HIKPTOOLTEST} ext -i {iface} -t 32 -te {enable} -tmi {mac_id}"
        hns_common.exec_command(terminal, cmd)
        result = self.get_iface_ext_info(iface, 31, terminal=terminal)
        if (result.get("enable"), result.get("mac_id")) != (str(enable), str(mac_id)):
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def get_ets_config(iface, terminal="srever"):
        """
        ============================================
        函数说明: 获取ets的配置
        修改时间: 2023-03-03 17:13:14
        作   者: lwx567203
        ============================================
        """
        info = hns_common.exec_command(terminal=terminal, command=f"{hns_config.HIKPTOOLTEST} ets -i {iface}")
        result = dict(re.findall("(.*):\\s+(.*)", info))
        result[f"{iface} ets state"] = {"enable": 1, "disable": 0}.get(result.get(f"{iface} ets state"), 0)
        result["up2tc"] = re.sub(" +", "", result.get("up2tc", ""))
        result["percent"] = re.sub(" +", ",", result.get("percent", ""))
        result["strict"] = re.sub(" +", "", result.get("strict", ""))
        return result

    def set_ets_config(self, iface, enable=0, up2tc="00000000", percent="100,0,0,0,0,0,0,0", strict="01111111", terminal="srever"):
        """
        ============================================
        函数说明: 配置ets
        修改时间: 2023-03-03 17:18:22
        作   者: lwx567203
        ============================================
        """
        cmd = f"{hns_config.HIKPTOOLTEST} ets -i {iface} -e {enable} -t {up2tc} -p {percent} -s {strict}"
        hns_common.exec_command(terminal=terminal, command=cmd)
        result = self.get_ets_config(iface, terminal=terminal)
        if result.get(f"{iface} ets state") != enable:
            return FAILURE_CODE
        if result.get("up2tc") != up2tc:
            return FAILURE_CODE
        if result.get("percent") != percent:
            return FAILURE_CODE
        if result.get("strict") != strict:
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def get_pfc_config(iface, terminal="srever"):
        """
        ============================================
        函数说明: 获取ets的配置
        修改时间: 2023-03-03 17:13:14
        作   者: lwx567203
        ============================================
        """
        info = hns_common.exec_command(terminal=terminal, command=f"{hns_config.HIKPTOOLTEST} pfc -i {iface}")
        result = dict(re.findall("(.*):\\s+(.*)", info))
        result[f"{iface} ets state"] = {"enable": 1, "disable": 0}.get(result.get(f"{iface} ets state"), 0)
        result["pfcup"] = re.sub(" +", "", result.get("pfcup", ""))
        return result


class HikpTool(object):
    """dfx工具"""

    def __init__(self):
        pass

    @staticmethod
    def get_promisc_entries(network, **kwargs):
        """
        =====================================================================
        函数说明： 查询设备混杂表项
        参数说明： network:网口名称
        作   者： ywx925178
        #!!=====================================================================
        """
        terminal = kwargs.get("terminal", "server")
        bdf = hns_config_ethtool.get_iface_bdf(network)
        ret_str = hns_common.exec_command(terminal, f"{hns_config.HIKPTOOL} nic_ppp -i {bdf} -du promisc")
        promisc_list = []
        all_promisc_list = []
        promisc_dict = {}
        device = re.findall(r"pf|vf\d", ret_str)
        for status in re.findall(r"\s\d", ret_str):
            all_promisc_list.append(status.strip())
        for i in range(0, len(all_promisc_list), 3):
            promisc_list.append(all_promisc_list[i:i + 3])
        for index, dev in enumerate(device):
            promisc_dict[dev] = promisc_list[index]
        return promisc_dict


def query_hns3_network(network, terminal="server"):
    """
    =====================================================================
      函数名称 : querying_network_devices
      函数说明 : 查询是否为HNS3网口设备
      参数说明 : network:网口名
      
    =====================================================================
    """
    cmd = f"{hns_config.HIKPTOOLTEST} ext -i {network} -t 3"
    result = hns_common.exec_command(terminal, cmd)
    if result == "netdev match success.":
        return SUCCESS_CODE
    else:
        return FAILURE_CODE


def clean_statis(network, terminal="server"):
    """
    =====================================================================
      函数名称 : clean_statis
      函数说明 : 清除网口统计
      参数说明 : network:网口名
      
    =====================================================================
    """
    cmd = f"{hns_config.HIKPTOOLTEST} ext -i {network} -t 8"
    result = hns_common.exec_command(terminal, cmd)
    if result:
        return FAILURE_CODE
    return SUCCESS_CODE


def ppp_du_mac(self, iface, in_port=-1, terminal="server"):
    """
    =====================================================================
    函数说明: 查询mac信息
    函数返回: (uc_mas, mc_macs)
    修改时间: 2022/03/10 09:52:17
    作    者: lwx567203
    =====================================================================
    """
    result = self.run(f"{hns_config.KP_UTOOL} ppp -i {iface} -du mac", terminal=terminal)
    data = re.split("Multicast tab|UM_MC_RDATA", result, flags=re.I)
    pattern = re.compile("[0-9a-fA-F]{2}(?::[0-9a-fA-F]{2}){5}")
    if in_port >= 0:
        pattern = re.compile(f"([0-9a-fA-F]{{2}}(?::[0-9a-fA-F]{{2}}){{5}})\\s+\\|\\s+\\d+\\s+\\|\\s+{in_port}\\s+\\|")
    try:
        uc_macs = pattern.findall(data[0])
        mc_macs = pattern.findall(data[1])
    except Exception as error:
        msg_center.error(error)
        uc_macs, mc_macs = [], []
    else:
        pass
    finally:
        pass
    return uc_macs, mc_macs
