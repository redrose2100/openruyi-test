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
import os

import test_config.global_config.global_config as global_config
from common_lib.base_lib.base_config import SUCCESS_CODE, FAILURE_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_global import engine_global as eg
from common_lib.base_lib.base_wait_time import wait_time
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.hns_config import hns_config
from feature_lib.hns_lib import hns_config_basic
from feature_lib.hns_lib.tesgine.tesgine_lib import TesGine



def __get_config__():
    """
    =====================================================================
    函数说明: 获取tesgine的配置
    修改时间: 2021/12/17 09:56:26
    作    者: lwx567203
    =====================================================================
    """
    yaml = project_lib.get_lava_device_ip_address()
    return yaml.get("tesgine")


def connect_tsg(tsg_info, try_time=3):
    """
    =====================================================================
    函数说明: 连接tesgine
    :param try_time     尝试次数
    函数返回: tsg_handler
    修改时间: 2022/03/25 09:59:33
    作    者: lwx567203
    =====================================================================
    """
    for index in range(try_time):
        try:
            handler = TesGine(tsg_ip=tsg_info.get("ip", "127.0.0.1"))
        except ValueError as error:
            msg_center.error(error)
            msg_center.warning(f"第{index+1}次连接tesgine失败")
            handler = None
        else:
            break
        finally:
            pass
    return handler


def connect():
    """
    =====================================================================
    函数说明: 连接tesgine
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/15 16:15:54
    作    者: lwx567203
    =====================================================================
    """
    msg_center.info("与tesgine建立连接")
    if eg.project.mock_mark:
        hns_config.TSG_BDFS = hns_config.MOCK_TSG_BDFS
        return SUCCESS_CODE
    tsg_info = __get_config__()

    tsg_handler = connect_tsg(tsg_info)
    if not tsg_handler:
        msg_center.error(f"连接到tesgine {tsg_info.get('ip')} 失败")
        return FAILURE_CODE

    for bdf, port in tsg_info.items():
        if bdf == "ip":
            continue
        try:
            port = int(port)
        except ValueError as error:
            msg_center.error(error)
            continue
        else:
            if port not in range(1, 49):
                continue
        finally:
            pass
        hns_config.TSG_BDFS[bdf] = port
        msg_center.info(f"bdf is {bdf},port is {hns_config.TSG_BDFS[bdf]}")
    if not hns_config.TSG_BDFS:
        msg_center.error(f"tesgine {tsg_info.get('ip')}没有可以连接的端口")
        return FAILURE_CODE
    if not tsg_handler.connect_tsg(ports=hns_config.TSG_BDFS.values()):
        msg_center.error(f"连接到tesgine {tsg_info.get('ip')} 端口 {port} 失败")
        return FAILURE_CODE
    ssh.tesgine = tsg_handler
    return SUCCESS_CODE


def disconnect():
    """
    =====================================================================
    函数说明: 断开tesgine的连接
    修改时间: 2021/12/17 10:18:55
    作    者: lwx567203
    =====================================================================
    """
    msg_center.info("断开tesgine连接")
    if eg.project.mock_mark:
        return SUCCESS_CODE
    if not isinstance(ssh.tesgine, TesGine):
        return SUCCESS_CODE
    for port in hns_config.TSG_BDFS.values():
        ssh.tesgine.disconnect(port)
    ssh.tesgine = None
    return SUCCESS_CODE


def start_capture(port):
    """
    =====================================================================
    函数说明: 开启抓包
    修改时间: 2021/12/17 10:59:12
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    cap_ports = [int(port)]
    if port == "all":
        cap_ports = [int(port) for port in hns_config.TSG_BDFS.values()]
    for portid in cap_ports:
        ssh.tesgine.start_capture(portid)
    return SUCCESS_CODE


def stop_capture(port, filename=None):
    """
    =====================================================================
    函数说明: 停止抓包并保存到本地
    修改时间: 2021/12/17 11:04:59
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    cap_ports = [int(port)]
    if port == "all":
        cap_ports = [int(port) for port in hns_config.TSG_BDFS.values()]
    for portid in cap_ports:
        ssh.tesgine.stop_capture(portid)
        if not filename:
            filename = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_tesgine_port_{portid}.pcap"
        capture_name = f"{eg.project.base_dir_path}/{eg.pytest.case_name}_port_{portid}.pcap"
        ssh.tesgine.save_capture(portid, capture_name)
        if os.system(f"ls {capture_name}") != 0:
            msg_center.error("没有抓到包")
            return FAILURE_CODE
        cmd = f"tshark -r {capture_name} -w {filename}"
        os.system(cmd)
        msg_center.info(f"抓到的包为{filename}")
        hns_config.PCAPFILES.append(filename)
        os.remove(capture_name)
    return SUCCESS_CODE


def set_send_mode(port, **kwargs):
    """
    =====================================================================
    函数说明: 设置发包模式
    修改时间: 2021/12/20 16:34:28
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    if global_config.lava_global.run_env_type in [1]:
        default_percent = 4
    elif global_config.lava_global.bios_version.lower() == hns_config.NEZHA_BIOS.lower():
        default_percent = 0.01
    else:
        default_percent = 1
    speed = kwargs.get("speed", default_percent)
    count = kwargs.get("count", 100)
    mode = kwargs.get("mode", "single_burst")
    if mode.lower() == "continue":
        return ssh.tesgine.send_mode_continue(port, speed)
    elif mode.lower() == "multi":
        return ssh.tesgine.send_mode_multiburst(port, **kwargs)
    return ssh.tesgine.send_mode_single(port, count, speed)


def __send_once_pkts__(port, seconds=5, **kwargs):
    """
    =====================================================================
    函数说明: NA
    修改时间: 2021/12/17 11:16:17
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    set_send_mode(port, **kwargs)
    if ssh.tesgine.start_stream(port) is False:
        msg_center.error(f"tesgine的{port}发包失败")
        return FAILURE_CODE
    wait_time(seconds)
    if ssh.tesgine.stop_stream(port) is False:
        msg_center.error(f"tesgine的{port}端口停止发包失败")
        ssh.tesgine.stop_stream(port)
        return FAILURE_CODE
    return SUCCESS_CODE


def send_once_pkts(port, seconds:int=5, capture:bool=False, **kwargs):
    """
    =====================================================================
    函数说明: 发送一次报文
    :param port         发包端口，为all时表示所有端口
    :param seconds      发包时长，默认5秒
    :param capture      是否抓包，默认不抓包，抓包后保存在日志目录，文件文件名称为:用例名称_tesgine_port_端口.pcap
    :param send_mode    发包模式，可选single_burst和continue，默认single_burst
    :param count        发包个数，仅在single_burst模式下有效
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/17 11:48:01
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        hns_config.TSG_SEND_PKTS = kwargs.get("count", 100)
        return SUCCESS_CODE
    if port not in list(hns_config.TSG_BDFS.values()) + ["all"]:
        msg_center.error(f"端口{port}不在tesgine的使用范围")
        return FAILURE_CODE
    if capture is True:
        start_capture(port)
    result = __send_once_pkts__(port, seconds, **kwargs)
    if capture is True:
        stop_capture(port)
    return result


def send_multi_pkts(port, seconds:int=5, capture:bool=False, **kwargs):
    """
    =====================================================================
    函数说明: 发送一次报文
    :param port         发包端口，为all时表示所有端口
    :param seconds      发包时长，默认5秒
    :param capture      是否抓包，默认不抓包，抓包后保存在日志目录，文件文件名称为:用例名称_tesgine_port_端口.pcap
    函数返回: None
    应用举例: NA
    修改时间: 2022/5/17 11:48:01
    作    者: lwx638710
    =====================================================================
    """
    if eg.project.mock_mark:
        hns_config.TSG_SEND_PKTS = kwargs.get("count", 100)
        return SUCCESS_CODE
    if port not in list(hns_config.TSG_BDFS.values()) + ["all"]:
        msg_center.error(f"端口{port}不在tesgine的使用范围")
        return FAILURE_CODE
    if capture is True:
        start_capture(port)
    set_send_mode(port, mode="multi", **kwargs)
    if ssh.tesgine.start_stream(port) is False:
        msg_center.error(f"tesgine的{port}发包失败")
        return FAILURE_CODE
    time.sleep(seconds)
    if ssh.tesgine.stop_stream(port) is False:
        msg_center.error(f"tesgine的{port}端口停止发包失败")
        ssh.tesgine.stop_stream(port)
        return FAILURE_CODE
    if capture is True:
        stop_capture(port)
    return SUCCESS_CODE


def continue_send_pkts(port:int, start:bool=True, speed:float=1):
    """
    =====================================================================
    函数说明: 持续发送报文
    :param start    开始发送，
    :param stop     停止发送
    :param speed    发包速率，默认1%
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/20 11:28:36
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    if start:
        set_send_mode(port, mode="continue", speed=speed)
        return ssh.tesgine.start_stream(port)
    return ssh.tesgine.stop_stream(port)


def get_statis(port, **kwargs):
    """
    =====================================================================
    函数说明: 获取tesgine的统计
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/17 11:32:26
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return {"tx_pkts": hns_config.TSG_SEND_PKTS}
    if port not in hns_config.TSG_BDFS.values():
        msg_center.error(f"端口{port}不在tesgine的使用范围")
        return FAILURE_CODE
    return ssh.tesgine.get_stats(port, **kwargs)


def addstream(port, flow, **kwargs):
    """
    =====================================================================
    函数说明: 添加流
    :param port     tesgine端口
    :param flow     流类型，支持ipv4, ipv4_frag, tcpv4, udpv4, ipv6, ipv6_frag, tcpv6, udpv6, lldp,
                    ipv4vxlan, ipv4vxlangpe, ipv4vxlangpe_oam, ipv4geneve, ipv4nvgre, ipv6vxlan,
                    ipv6vxlangpe, ipv6vxlangpe_oam, ipv6geneve, ipv6nvgre, ipv4_icmp_req, ipv4_icmp_rep,
                    ipv6_icmp6, ipv4_icmp, ipv4_igmp1, ipv4_igmp2, ipv4_igmp3q, ipv4_igmp3r, sctpv4,
                    sctpv6, ipv6_icmp6_request, ipv6_icmp6_reply
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/20 09:36:43
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    flows = ['ethernet2', 'ipv4', 'ipv4_frag', 'tcpv4', 'udpv4', 'ipv6', 'ipv6_frag', 'tcpv6', 'udpv6', 'lldp',
            'ipv4vxlan', 'ipv4vxlangpe', 'ipv4vxlangpe_oam', 'ipv4geneve', 'ipv4nvgre', 'ipv6vxlan',
            'ipv6vxlangpe', 'ipv6vxlangpe_oam', 'ipv6geneve', 'ipv6nvgre', 'ipv4_icmp_req',
            'ipv4_icmp_rep', 'ipv6_icmp6', 'ipv4_icmp', 'ipv4_igmp1', 'ipv4_igmp2',
            'ipv4_igmp3q', 'ipv4_igmp3r', 'sctpv4', 'sctpv6', 'ipv6_icmp6_request', 'ipv6_icmp6_reply',
            'ipv4geneve_oam', 'ipv6geneve_oam', 'dhcp', "pfc", "pause"]
    if flow.lower() not in flows:
        msg_center.warning("未知的流类型，使用默认的ipv4流")
        flow = "ipv4"
    if flow.lower() in flows:
        if not kwargs.get("src_mac"):
            kwargs["src_mac"] = hns_config.TESGINE_MACS.get(port, "ff:ff:ff:ff:ff:ff")
        dst_ip = hns_config.LOCAL_NETWORK_IP
        if "v6" in flow.lower():
            dst_ip = hns_config.LOCAL_IPV6_IP[0]
        if not kwargs.get("src_ip"):
            ssh.tesgine.src_ip[port] = hns_config_basic.get_same_network_addr(dst_ip)
            kwargs["src_ip"] = ssh.tesgine.src_ip.get(port)
        if not kwargs.get("dst_ip"):
            kwargs["dst_ip"] = dst_ip
        if isinstance(kwargs.get("vlan", None), (int, str)):
            kwargs["vlan"] = {"vid": kwargs.get("vlan")}
    return ssh.tesgine.create_stream(port, flow, **kwargs)


def remove_stream(port, name=None):
    """
    =====================================================================
    函数说明: 删除流
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/20 15:48:03
    作    者: lwx567203
    =====================================================================
    """
    if eg.project.mock_mark:
        return SUCCESS_CODE
    return ssh.tesgine.remove_stream(port=port, stream=name)


def create_stream_by_dict(port, pkt_dict: dict):
    """
    =====================================================================
    函数说明: 以字典模式添加流
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/20 15:48:03
    作    者: lwx567203
    =====================================================================
    """
    if pkt_dict.get("TsuId") == 0:
        pkt_dict.update(dict(TsuId=ssh.tesgine.tsuid, RxTsuId=ssh.tesgine.tsuid))
    if pkt_dict.get("PortId") == 0:
        pkt_dict.update(dict(PortId=port, RxPortId=port))
    dst_ip = hns_config.LOCAL_NETWORK_IP
    if "v6" in pkt_dict.get("Name").lower():
        dst_ip = hns_config.LOCAL_IPV6_IP[0]
    ssh.tesgine.src_ip[port] = hns_config_basic.get_same_network_addr(dst_ip)
    return ssh.tesgine.create_stream_by_dict(pkt_dict)


def enable_stream(port=None, name=None, flag=True, atport=False):
    """
    =====================================================================
    函数说明: 是否使能流
    :param port     端口
    :param name     流名称
    :param flag     使能状态
    :param atport   应用到所有端口
    应用举例: NA
    修改时间: 2022/01/29 11:10:49
    作    者: lwx567203
    =====================================================================
    """
    return ssh.tesgine.enable_stream(port, name, flag, atport)


def edit_ethernet_link_data(port, **kwargs):
    """
    =====================================================================
    函数说明: 修改tesgine端口的link配置
    修改时间: 2022/1/28 16:48:03
    作    者: lwx567203
    =====================================================================
    """
    return ssh.tesgine.set_arp(port, **kwargs)


def modify_raw_stream(name, **kwargs):
    """
    =====================================================================
    函数说明: NA
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2022/02/07 18:25:21
    作    者: lwx567203
    =====================================================================
    """
    return ssh.tesgine.modify_raw_stream(name, **kwargs)


def save_config(file: str):
    """
    #!!=====================================================================
    # 函数说明：将配置好的tsgine信息保存到指定路径的文件中
    # 参数说明：
    #   file 带绝对路径的文件名
    # 返  回  值：True 保存成功 False 保存失败
    # 使用实例：tsg.save_config(file="/home/lixuan/tsg123.tes")
    # 对应命令：无
    #
    # 
    # 生成时间：20220323
    # 修改纪录：================================================================
    """
    return ssh.tesgine.save_config(file)


def get_ethernet_link_data(port=0, param=""):
    """
    ============================================
    函数说明: 获取tesgine链路信息
    修改时间: 2023-02-28 16:16:42
    作   者: lwx567203
    ============================================
    """
    return ssh.tesgine.get_ethernet_link_data(port, param)
