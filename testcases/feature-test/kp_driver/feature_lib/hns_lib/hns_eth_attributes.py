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


import time

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_global import engine_global as eg
from test_config.global_config import global_config
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from feature_lib.hns_lib import hns_common as comm
from feature_lib.hns_lib import hns_config_ethtool as hns_ethtool
from kp_devinfo.device.eth import EthDevice
from kp_devinfo.debugfs.eth import EthDebugfs


def query_speed_port(network, terminal="server"):
    """
    查询网口的速率
    :param network: 网口
    :param handler
    :return: 网口的速率值，整数类型
    """
    i_handler = comm.get_instance_object(network, terminal)
    return i_handler.get_speed()


def get_rx_tx_pack(network, attr="packets", terminal="server"):
    """
    查询本地网口的收发包
    :param local_network: 本地网口
    :return: 返回一个字典 rx_packets, tx_packets, rx_errors, tx_errors, rx_dropped, tx_dropped
    """
    handler = comm.get_terminal_handler(terminal)
    dev_attr = EthDevice(dev_name=network, terminal=handler).statistics
    packdict = {}
    if attr.lower() in ("rx", "packets", "rx_packets", "all"):
        packdict["rx_packets"] = int(dev_attr.rx_packets)
    if attr.lower() in ("tx", "packets", "tx_packets", "all"):
        packdict["tx_packets"] = int(dev_attr.tx_packets)

    if attr.lower() in ("rx", "errors", "rx_errors", "all"):
        packdict["rx_errors"] = int(dev_attr.rx_errors)
    if attr.lower() in ("tx", "errors", "tx_errors", "all"):
        packdict["tx_errors"] = int(dev_attr.tx_errors)

    if attr.lower() in ("rx", "dropped", "rx_dropped", "all"):
        packdict["rx_dropped"] = int(dev_attr.rx_dropped)
    if attr.lower() in ("tx", "dropped", "tx_dropped", "all"):
        packdict["tx_dropped"] = int(dev_attr.tx_dropped)

    if attr.lower() in ("rx", "bytes", "rx_bytes", "all"):
        packdict["rx_bytes"] = int(dev_attr.rx_bytes)
    if attr.lower() in ("tx", "bytes", "tx_bytes", "all"):
        packdict["tx_bytes"] = int(dev_attr.tx_bytes)
    return packdict


def get_send_and_receive_pack_num(pre_pack, aft_pack):
    """
    传入根据query_tx_rx_pack函数获得的发包前及发包后的statistics值列表/数字
    返回发包后-发包前的结果
    :param pre_pack：发包前的statistics值列表/数字
    :param aft_pack：发包后的statistics值列表/数字
    :return: 0或者1
    """
    if isinstance(pre_pack, int) and isinstance(aft_pack, int):
        return aft_pack - pre_pack
    if isinstance(pre_pack, list) and isinstance(aft_pack, list):
        return sum([aft_pack[i] - j for i, j in enumerate(pre_pack)])
    if isinstance(pre_pack, dict) and isinstance(aft_pack, dict):
        return dict([(key, aft_pack.get(key, 0) - value) for key, value in pre_pack.items()])


def get_iface_mac(iface: str, terminal="server"):
    """
    功能描述: 获取网口的mac地址
    参数说明:
        :param iface    网口名
        :param terminal 终端(server|client)
    返回值: mac
    修改时间: 2021/07/05 15:56:15
    作    者: lwx567203
    """
    i_handler = comm.get_instance_object(iface, terminal)
    return i_handler.get_mac()


def dump_mac(iface, mac_t="unicast", terminal="server", **kwargs):
    """
    =====================================================================
    函数说明: dump网口mac列表
    作    者: lwx567203
    =====================================================================
    """
    status = kwargs.get("status", "")
    handler = comm.get_terminal_handler(terminal)
    bus_info = hns_ethtool.get_iface_bdf(iface, terminal=terminal)
    if mac_t == "unicast":
        mac_info = EthDebugfs(pci_bdf=bus_info, terminal=handler).mac_list.uc
    elif mac_t == "multicast":
        mac_info = EthDebugfs(pci_bdf=bus_info, terminal=handler).mac_list.mc
    if not status:
        mac_list = [info[1] for info in mac_info]
    else:
        mac_list = [info[1] for info in mac_info if info[-1] == status.upper()]
    return mac_list


def query_througout(network, **kargs):
    """
    :param network:网口名称
    :param speed_exp:预期带宽（检查流量是否恢复）
    :return:成功或者失败
    """
    time.sleep(8)
    if global_config.lava_global.run_env_type in [2, 3]:
        pack_list_1 = get_rx_tx_pack(network)
        time.sleep(5)
        pack_list_2 = get_rx_tx_pack(network)
        tx_packets = pack_list_2.get("tx_packets") - pack_list_1.get("tx_packets")
        rx_packets = pack_list_2.get("rx_packets") - pack_list_1.get("rx_packets")
        if tx_packets < 100 or rx_packets < 100:
            time.sleep(3)
            pack_list_2 = get_rx_tx_pack(network)
            tx_packets = pack_list_2.get("tx_packets") - pack_list_1.get("tx_packets")
            rx_packets = pack_list_2.get("rx_packets") - pack_list_1.get("rx_packets")
            if tx_packets < 100 or rx_packets < 100:
                msg_center.error("流量恢复异常")
                return FAILURE_CODE
    else:
        port_speed = query_speed_port(network)
        bandwith_exp = int(port_speed) * 0.5
        logfile_default = "%s/iperf_%s.log" % (eg.project.base_dir_path, eg.pytest.case_name)
        speed_exp = kargs.get("expect", bandwith_exp)
        logfile = kargs.get("logfile", logfile_default)
        cmd = "tail -1 %s|awk '{print $(NF-1)}'" % logfile
        ssh.server.send_command(cmd)
        retinfo = ssh.server.information
        if int(float(retinfo)) < speed_exp:
            msg_center.error("流量恢复异常")
            return FAILURE_CODE
    return SUCCESS_CODE


def get_sriov_totalvfs(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取pf下vf的function个数
    修改时间: 2022/04/02 15:13:17
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    sriov_totalvfs = EthDevice(dev_name=iface, terminal=handler).device.sriov_totalvfs
    if not sriov_totalvfs.strip():
        return 0
    return int(sriov_totalvfs)
