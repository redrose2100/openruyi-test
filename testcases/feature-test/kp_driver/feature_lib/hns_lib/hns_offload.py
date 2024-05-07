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


import random
import re
import IPy

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_global import engine_global as eg
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config import hns_config
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from feature_lib.hns_lib import hns_config_basic as hns_bas
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_config_ethtool as hns_ethtool
from test_config.global_config import global_config
from common_lib.base_lib.base_wait_time import wait_time


def check_csum(file_name, **kwargs):
    """
    功能描述: 验证报文的checksum
    参数说明: NA
    修改时间: 2021/12/13 14:45:16
    """
    pro_type = kwargs.get("pro_type", "tcp")
    terminal = kwargs.get("terminal", "server")
    count = kwargs.get("count", 100)
    key_dict = {"tcp": ["incorrect", "\(correct"],
                "udp": ["bad udp cksum", "udp sum ok"]}
    tx_status = kwargs.get("tx_status", "on")
    filter_cmd = kwargs.get("filter_cmd", "-venl 2>&1")
    disable_log = kwargs.get("disable_log", True)
    info = hns_common.tcpdump_parses(file_name, terminal=terminal, filter_cmd=filter_cmd, disable_log=disable_log)
    cksum_incorrect = re.findall(key_dict.get(pro_type)[0], info)
    cksum_correct = re.findall(key_dict.get(pro_type)[1], info)
    if tx_status == "on":
        if terminal == "server" and (len(cksum_correct) != 0 or len(cksum_incorrect) < count * 0.9):
            msg_center.error(f"TX {tx_status}时，checksum校验失败！")
            return FAILURE_CODE
        if terminal == "client" and (len(cksum_incorrect) != 0 or len(cksum_correct) < count * 0.9):
            msg_center.error(f"TX {tx_status}时，checksum校验失败！")
            return FAILURE_CODE
    elif tx_status == "off":
        if len(cksum_incorrect) != 0 or len(cksum_correct) < count * 0.9:
            msg_center.error(f"TX {tx_status}时，checksum校验失败！")
            return FAILURE_CODE
    else:
        msg_center.error("TX状态输入错误（off/on）！")
        return FAILURE_CODE
    return SUCCESS_CODE


def tunnel_offload_tso(iface, dev_name, dev_type, min_id, max_id, local_ip, remote_ip,
                        count, local_genip, remote_genip, udp, tso_switchs, tx_switchs,
                        mtu_size, mtu_max, mtu_min):
    """
    功能描述: 隧道报文tso分片验证
    参数说明: NA
    修改时间: 2021/12/13 14:45:16
    """
    msg_center.info("添加隧道设备")
    dev_id = random.randint(min_id, max_id + 1)
    other = "udpcsum"
    if global_config.lava_global.run_env_type == 1 and IPy.IP(local_ip).version() == 4:
        other = "noudpcsum"
    if global_config.lava_global.run_env_type == 1 and IPy.IP(local_ip).version() == 6:
        other = "udp6zerocsumtx udp6zerocsumrx"
    comm_dict = {"vxlan_localip": local_genip, "vxlan_remoteip": remote_genip, "other": other}
    comm_dict_c = {"vxlan_localip": local_genip, "vxlan_remoteip": remote_genip, "other": other, "terminal": "client"}
    server_dict, client_dict = comm_dict, comm_dict_c
    if "vxlan" in dev_name:
        server_dict = {**comm_dict, "local_net": iface}
        client_dict = {**comm_dict, "local_net": hns_config.REMOTE_NETWORK, "terminal": "client"}
    hns_bas.iplink_add(dev_name, dev_type, dev_id, remote_ip, **server_dict)
    hns_bas.iplink_add(dev_name, dev_type, dev_id, local_ip, **client_dict)
    wait_time(5)
    retcode = hns_bas.ping(dev_name, dev_name, remote_genip)
    if retcode != SUCCESS_CODE:
        msg_center.error("ping 对端设备失败")
        return FAILURE_CODE

    msg_center.info("关闭对端gro")
    hns_ethtool.set_offload(hns_config.REMOTE_NETWORK, "gro", "off", "generic-receive-offload", terminal="client")
    hns_ethtool.set_offload(hns_config.REMOTE_NETWORK, "rx-gro-hw", "off", "rx-gro-hw", terminal="client")
    hns_ethtool.set_offload(dev_name, "gro", "off", "generic-receive-offload", terminal="client")
    hns_ethtool.set_offload(dev_name, "rx-gro-hw", "off", "rx-gro-hw", terminal="client")

    for tso_switch, tx_switch in zip(tso_switchs, tx_switchs):
        hns_ethtool.set_offload(iface, "tso", tso_switch, "tcp-segmentation-offload")
        hns_ethtool.set_offload(iface, "tx", tx_switch, "tx-checksumming")

        iptype = 4
        if IPy.IP(local_genip).version() == 6:
            iptype = 6
        hns_common.iperf(mode="-s", udp=udp, ip_type=iptype, terminal="client")

        msg_center.info("配置 mtu")
        mtu = random.randint(mtu_min, mtu_max)
        hns_bas.ifconfig_basic(iface, f"mtu {mtu}")
        hns_bas.ifconfig_basic(hns_config.REMOTE_NETWORK, f"mtu {mtu}", terminal="client")
        hns_bas.ifconfig_basic(dev_name, f"mtu {mtu - mtu_size}")
        hns_bas.ifconfig_basic(dev_name, f"mtu {mtu - mtu_size}", terminal="client")

        msg_center.info("开启抓包")
        local_name = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_tso_{tso_switch}_mtu_{mtu}_local.pcap"
        remote_name = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_tso_{tso_switch}_mtu_{mtu}_remote.pcap"
        hns_common.tcpdump_captrue(iface, count=count, filter_cmd="udp", captrue_dire="out", filename=local_name)
        hns_common.tcpdump_captrue(hns_config.REMOTE_NETWORK, count=count, filter_cmd="udp",
                                   captrue_dire="in", filename=remote_name, terminal="client")

        hns_common.iperf(mode="-c", host=remote_genip, udp=udp, ip_type=iptype, back=False)

        local_info = hns_common.tcpdump_parses(remote_name, grep_cmd="length", terminal="client")
        len_list = re.findall("length (.*?): \(", local_info)
        # 外层ip头长度
        header_len = 20
        if IPy.IP(local_ip).version() == 6:
            header_len = 40
        # 总长度 = 里层mtu +以太头 + vxlan头 + udp头 + ip头 + 以太头
        expect_len = (mtu - mtu_size) + 14 + 8 + 8 + header_len + 14
        if sorted(list(map(int, len_list)))[-1] != expect_len:
            msg_center.error(f"检查抓包大小失败，预期结果抓到的是小包，实际抓包{sorted(list(map(int, len_list)))[-1]}，"
                             f"预期抓包{expect_len}")
            return FAILURE_CODE

        remote_info = hns_common.tcpdump_parses(local_name, grep_cmd="length")
        len_list = re.findall("length (.*?): \(", remote_info)
        if tso_switch == "on":
            if sorted(list(map(int, len_list)))[-1] <= expect_len:
                msg_center.error("检查抓包大小失败，预期结果抓到的是大包")
                return FAILURE_CODE
        else:
            if sorted(list(map(int, len_list)))[-1] != expect_len:
                msg_center.error("检查抓包大小失败，预期结果抓到的是小包")
                return FAILURE_CODE
        pro_type = "tcp"
        if udp:
            pro_type = "udp"
        ret_code1 = check_csum(local_name, pro_type=pro_type, terminal="server", count=count, tx_status=tx_switch)
        ret_code2 = check_csum(remote_name, pro_type=pro_type, terminal="client", count=count, tx_status=tx_switch)
        if ret_code1 + ret_code2 != SUCCESS_CODE:
            return FAILURE_CODE
    msg_center.info("测试成功")
    return SUCCESS_CODE


def tunnel_offload_ip(iface, dev_name, dev_type, min_id, max_id, local_ip, remote_ip,
                      count, local_genip, remote_genip, udp, mtu_size, mtu_max, mtu_min, payloadlen):
    """
    功能描述: 隧道报文分片验证
    参数说明: NA
    修改时间: 2021/12/13 14:45:16
    """
    msg_center.info("添加隧道设备")
    dev_id = random.randint(min_id, max_id + 1)
    other = "udpcsum"
    if global_config.lava_global.run_env_type == 1 and IPy.IP(local_ip).version() == 4:
        other = "noudpcsum"
    if global_config.lava_global.run_env_type == 1 and IPy.IP(local_ip).version() == 6:
        other = "udp6zerocsumtx udp6zerocsumrx"
    comm_dict = {"vxlan_localip": local_genip, "vxlan_remoteip": remote_genip, "other": other}
    comm_dict_c = {"vxlan_localip": local_genip, "vxlan_remoteip": remote_genip, "other": other, "terminal": "client"}
    server_dict, client_dict = comm_dict, comm_dict_c
    if "vxlan" in dev_name:
        server_dict = {**comm_dict, "local_net": iface}
        client_dict = {**comm_dict, "local_net": hns_config.REMOTE_NETWORK, "terminal": "client"}
    hns_bas.iplink_add(dev_name, dev_type, dev_id, remote_ip, **server_dict)
    hns_bas.iplink_add(dev_name, dev_type, dev_id, local_ip, **client_dict)
    wait_time(5)
    retcode = hns_bas.ping(dev_name, dev_name, remote_genip)
    if retcode != SUCCESS_CODE:
        msg_center.error("ping 对端设备失败")
        return FAILURE_CODE

    msg_center.info("关闭对端gro")
    hns_ethtool.set_offload(hns_config.REMOTE_NETWORK, "gro", "off", "generic-receive-offload", terminal="client")
    hns_ethtool.set_offload(dev_name, "gro", "off", "generic-receive-offload", terminal="client")

    iptype = 4
    # 里层ip头长度
    inner_len = 20
    if IPy.IP(local_genip).version() == 6:
        iptype = 6
        inner_len = 40
    # 外层ip头长度
    outer_len = 20
    if IPy.IP(local_ip).version() == 6:
        outer_len = 40
    hns_common.iperf(mode="-s", udp=udp, ip_type=iptype, terminal="client")

    msg_center.info("配置 mtu")
    mtu = random.randint(mtu_min, mtu_max)
    hns_bas.ifconfig_basic(iface, f"mtu {mtu}")
    hns_bas.ifconfig_basic(hns_config.REMOTE_NETWORK, f"mtu {mtu}", terminal="client")
    hns_bas.ifconfig_basic(dev_name, f"mtu {mtu - mtu_size}")
    hns_bas.ifconfig_basic(dev_name, f"mtu {mtu - mtu_size}", terminal="client")

    msg_center.info("开启抓包")
    local_name = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_ip_mtu_{mtu}_local.pcap"
    remote_name = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_ip_mtu_{mtu}_remote.pcap"
    hns_common.tcpdump_captrue(iface, count=count, filter_cmd="udp", captrue_dire="out", filename=local_name)
    hns_common.tcpdump_captrue(hns_config.REMOTE_NETWORK, count=count, filter_cmd="udp",
                               captrue_dire="in", filename=remote_name, terminal="client")

    hns_common.iperf(mode="-c", host=remote_genip, udp=udp, other=f"-l {payloadlen}", ip_type=iptype, back=False)

    info = hns_common.tcpdump_parses(remote_name, grep_cmd="length", terminal="client")
    len_list = re.findall("length (.*?): \(", info)
    # 里层四层头+payload长度为8的整数倍，加上ip头的长度不超过里层mtu，所以里层长度为
    inner_len = (mtu - mtu_size - inner_len) // 8 * 8 + inner_len
    # 总长度为里层长度 + 以太头 + vxlan头 + udp头 + ip头 + 以太头
    expect_len = inner_len + 14 + 8 + 8 + outer_len + 14
    if sorted(list(map(int, len_list)))[-1] != expect_len:
        msg_center.error("检查抓包大小失败，预期结果抓到的是小包")
        return FAILURE_CODE

    info = hns_common.tcpdump_parses(local_name, grep_cmd="length")
    len_list = re.findall("length (.*?): \(", info)
    if sorted(list(map(int, len_list)))[-1] != expect_len:
        msg_center.error("检查抓包大小失败，预期结果抓到的是小包")
        return FAILURE_CODE
    msg_center.info("测试成功")
    return SUCCESS_CODE





