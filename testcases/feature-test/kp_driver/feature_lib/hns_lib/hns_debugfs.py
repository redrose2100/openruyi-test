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
import IPy
from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_global import engine_global as eg
from test_config.global_config import global_config
from kp_devinfo.debugfs import eth
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_config_ethtool
from kp_devinfo.debugfs.eth import EthDebugfs
from test_config.feature_config.hns_config import hns_config


def get_debugfs_handler(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取设备的句柄
    修改时间: 2022/01/06 14:50:21
    作    者: lwx567203
    =====================================================================
    """
    if hns_config.H_DEBUGFS.get(iface) is None:
        handler = hns_common.get_terminal_handler(terminal)
        bdf = hns_config_ethtool.get_iface_bdf(iface, terminal=terminal)
        hns_config.H_DEBUGFS[iface] = eth.EthDebugfs(bdf, terminal=handler)
    return hns_config.H_DEBUGFS.get(iface)


def get_iface_devinfo(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的devinfo
    修改时间: 2022/01/06 14:44:29
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.dev_info


def get_loopback(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的loopback信息
    修改时间: 2022/01/06 14:44:29
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.loopback


def get_iface_mac_id(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口的mac_id
    修改时间: 2022/04/14 11:07:05
    作    者: lwx567203
    =====================================================================
    """
    loopback = get_loopback(iface, terminal=terminal)
    return int(loopback.get("mac id", 0))


def get_even_mac_id(iface, terminal="server"):
    """
    ============================================
    函数说明: 获取事件mac id
    修改时间: 2023-06-26 10:44:36
    作   者: lwx567203
    ============================================
    """
    mac_id = get_iface_mac_id(iface, terminal)
    if mac_id % 2 == 0:
        return int(mac_id // 2)
    return -1


def get_tx_queue_info(iface, terminal="server", set_tx_buf=False):
    """
    =====================================================================
    函数说明: 读取网口的tx_queue_info
    修改时间: 2022/01/06 15:19:40
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    queue_info = handler.queue.tx_queue_info
    if not set_tx_buf:
        return queue_info
    try:
        index = queue_info.index(["tx", "spare", "buffer", "info"])
    except ValueError as error:
        msg_center.error(error)
        return []
    else:
        tx_spare_buf_info = queue_info[index + 1:]
    finally:
        pass
    return tx_spare_buf_info


def get_umv_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口的uvm_info
    修改时间: 2022/03/09 15:37:51
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.umv_info


def get_umv_size(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口的单播mac规格
    修改时间: 2022/03/09 15:40:35
    作    者: lwx567203
    =====================================================================
    """
    umv_info = get_umv_info(iface, terminal=terminal)
    try:
        priv_umv_size = int(umv_info.get("priv_umv_size", 0))
        share_umv_size = int(umv_info.get("share_umv_size", 0))
    except ValueError as error:
        msg_center.error(error)
        mac_size = 0
    else:
        mac_size = priv_umv_size + share_umv_size
    finally:
        pass
    return mac_size


def get_tm_priority(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口tm_priority信息
    修改时间: 2022/04/22 16:48:00
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.tm.tm_priority


def get_tm_qset(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口tm_qset信息
    修改时间: 2022/05/31 14:44:34
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.tm.tm_qset


def get_fd_count(iface: str, terminal="server", func_id=None):
    """
    功能描述: 获取qb规则命中数量
    参数说明:
        :param iface    网口名
        :param terminal 终端(server|client)
    修改时间: 2021/07/08 16:49:03
    作    者: lwx567203
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    result = handler.fd.fd_counter
    if func_id is None:
        return result
    hit_times = {}
    for item in result:
        hit_times[item[0]] = int(item[1])
    return hit_times.get(func_id, 0)


def parser_fd_tcam_info(fd_tcam):
    """
    =====================================================================
    函数说明: 解析fd tcam的信息
    修改时间: 2022/06/01 10:49:35
    作    者: lwx567203
    =====================================================================
    """
    fd_tcam_info = {}
    for line in fd_tcam.strip().split("read result tcam key "):
        info_dict = {}
        if line == "":
            continue
        items = line.splitlines()
        key = items[0].replace(":", "")
        values = "".join(reversed(items[1:]))
        info_dict["value"] = values
        length = len(values)
        info_dict["vni"] = int(values[length - 4:], 16)
        info_dict["dst"] = ":".join(re.findall(".{1,2}", values[length - 18:length - 6]))
        info_dict["src"] = ":".join(re.findall(".{1,2}", values[length - 30:length - 18]))
        info_dict["vlan"] = int(values[length - 34:length - 30], 16)
        info_dict["proto"] = hex(int(values[length - 38:length - 34], 16))
        # 1630上此处有个in_l2_rsv, 占4个字符
        if global_config.lava_global.run_env_type == 3:
            length -= 4
        info_dict["tos"] = int(values[length - 40:length - 38], 16)
        info_dict["tclass"] = int(values[length - 40:length - 38], 16)
        info_dict["l4proto"] = int(values[length - 42:length - 40], 16)
        info_dict["src-ip"] = IPy.intToIp(int(values[length - 50:length - 42], 16), 4)
        info_dict["dst-ip"] = IPy.intToIp(int(values[length - 58:length - 50], 16), 4)
        info_dict["l2rsv"] = hex(int(values[length - 38:length - 34], 16))
        info_dict["l3rsv"] = hex(int(values[length - 62:length - 58], 16))
        info_dict["l4rsv"] = hex(int(values[length - 78:length - 74], 16))
        fd_tcam_info[key] = info_dict
    return fd_tcam_info


def get_fd_tcam(iface: str, terminal="server", parser=False):
    """
    =====================================================================
    函数说明: 获取规则信息fd_tcam
    修改时间: 2022/06/01 11:59:27
    作    者: lwx567203
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    fd_tcam = handler.fd.fd_tcam
    if not parser:
        return fd_tcam
    return parser_fd_tcam_info(fd_tcam)


def get_rule_content(iface: str, terminal="server"):
    """
    功能描述: 检查网口是否有qb规则存在
    参数说明:
        :param iface    网口名
        :param terminal 终端(server|client)
    返回值：content
    修改时间: 2021/07/05 11:15:20
    作    者: lwx567203
    """
    handler = hns_common.get_terminal_handler(terminal)
    tcam = get_fd_tcam(iface, terminal=terminal)
    a = tcam.split("tcam key y(1):")[1].split('\n')[::-1]
    print(a)
    # 获取mac地址字段
    handler.send_command(
        "cat {}/{}_tcam| grep 'read result tcam key y' -A 3 | tail -n 3".format(eg.project.base_dir_path,
                                                                                eg.pytest.case_name))
    mac_filed = "".join(handler.stdout.strip().split("\n")[::-1])
    msg_center.info(mac_filed)
    return mac_filed.lower()


def check_rule_count(iface: str, terminal="server", count=0):
    """
    功能描述: 检查规则数量
    参数说明:
        :param iface    网口名
        :param terminal 终端(server|client)
        :param count    规则数量
    返回值：True|False
    修改时间: 2021/07/05 17:15:30
    作    者: lwx567203
    """
    handler = hns_common.get_terminal_handler(terminal)
    tcam = get_fd_tcam(iface, terminal=terminal)
    count = len(tcam.split("read result tcam key y"))
    if count != int(handler.stdout):
        msg_center.error("%s生成的规则数量不符合预期", iface)
        return FAILURE_CODE
    msg_center.info("%s生成的规则数量符合预期", iface)
    return SUCCESS_CODE


def get_reg_info(iface: str, reg_mod: str, terminal="server"):
    """
    功能描述: 获取qb规则命中数量
    参数说明:
        :param iface    网口名
        :reg_mod 寄存器模块 (bios_common、dcb、igu_egu、mac、ncsi、ppp、rcb、rpu、rtc、ssu、tqp)
        :param terminal 终端(server|client)
    修改时间: 2022/04/01 16:49:03
    作    者: lwx638710
    """
    handler = hns_common.get_terminal_handler(terminal)
    reg_mod_list = ['bios_common', 'dcb', 'igu_egu', 'mac', 'ncsi', 'ppp', 'rcb', 'rpu', 'rtc', 'ssu', 'tqp']
    if reg_mod not in reg_mod_list:
        msg_center.error(f"不存在模块{reg_mod}！！")
        return FAILURE_CODE
    bus_info = hns_config_ethtool.get_iface_bdf(iface, terminal=terminal)
    debugfs_reg = getattr(EthDebugfs(pci_bdf=bus_info, terminal=handler).reg, reg_mod)
    return debugfs_reg


def get_tm_nodes(iface=None, bdf=None, terminal="server"):
    """
    =====================================================================
    函数说明: 获取tm_node信息
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2022/04/02 15:29:36
    作    者: lwx567203
    =====================================================================
    """
    if not bdf:
        bdf = hns_config_ethtool.get_iface_bdf(iface)
    info = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/tm/tm_nodes")
    tm_nodes_info = {}
    items = re.findall("(\\w+)\\s+(\\d+)\\s+(\\d+)", info)
    for item in items:
        tm_nodes_info.setdefault(item[0], dict(base_id=int(item[1]), max_num=int(item[2])))
    return tm_nodes_info


def get_pagepool_info(iface=None, bdf=None, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口的page pool信息
    修改时间: 2022/04/18 17:06:33
    作    者: lwx567203
    =====================================================================
    """
    if not bdf:
        bdf = hns_config_ethtool.get_iface_bdf(iface)
    info = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/page_pool_info")
    page_info = {}
    items = re.findall("(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s+(\\d+)\\s(.*)", info)
    for item in items:
        datas = {}
        datas.update({"allocate_cnt": item[1], "free_cnt": item[2], "pool_size": item[3]})
        datas.update({"order": item[4], "numa_id": item[5], "max_len": item[6].strip()})
        page_info.update({item[0]: datas})
    return page_info


def get_vlan_config(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的vlan过滤状态
    修改时间: 2022/01/06 14:44:29
    作    者: wwx605675
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.vlan_config


def get_imp_info(iface, terminal="server", analyze=True):
    """
    =====================================================================
    函数说明: 读取网口的imp_info
    修改时间: 2022/01/06 14:44:29
    作    者: wwx605675
    =====================================================================
    """
    if analyze == True:
        handler = get_debugfs_handler(iface, terminal=terminal)
        return handler.imp_info
    bdf = hns_config_ethtool.get_iface_bdf(iface)
    info = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/imp_info")
    return info


def get_ncl_config(iface, terminal="server", analyze=True, show_log=False):
    """
    =====================================================================
    函数说明: 读取网口的ncl_config
    修改时间: 2022/01/06 14:44:29
    作    者: wwx605675
    =====================================================================
    """
    if analyze == True:
        handler = get_debugfs_handler(iface, terminal=terminal)
        return handler.ncl_config
    bdf = hns_config_ethtool.get_iface_bdf(iface)
    info = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/ncl_config",
                                   disable_show_and_log=show_log)
    return info


def get_mng_tbl(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的mng_tbl
    修改时间: 2022/01/06 14:44:29
    作    者: wwx605675
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.mng_tbl


def get_qos_dscp_map(iface=None, bdf=None, terminal="server"):
    """
    ============================================
    函数说明: 获取dscp的映射
    修改时间: 2022-08-11 14:35:29
    作   者: lwx567203
    ============================================
    """
    if not bdf:
        bdf = hns_config_ethtool.get_iface_bdf(iface)
    result = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/tm/qos_dscp_map")
    mode = re.findall("tc map mode:\\s+(\\w+)", result)[0]
    map_ = re.findall("(\\d+)\\s+(\\d+)\\s+(\\d+)", result)
    dscp_prio = {}
    for items in map_:
        dscp_prio[items[0]] = {"prio": items[1], "tc": items[2]}
    dscp_map = {"mode": mode, "dscp": dscp_prio}
    return dscp_map


def get_wol_info(iface=None, bdf=None, terminal="server"):
    """
    ============================================
    函数说明: 获取wol的信息
    修改时间: 2022-12-02 15:41:23
    作   者: lwx567203
    ============================================
    """
    if not bdf:
        bdf = hns_config_ethtool.get_iface_bdf(iface)
    result = hns_common.exec_command(terminal, f"cat {hns_config.DEBUG_DIR_HNS}/{bdf}/wol_info")
    wol_info = {}
    key = ""
    for line in result.splitlines():
        if "supported" in line.lower():
            key = "supported"
            wol_info[key] = []
            continue
        if "current" in line.lower():
            key = "current"
            wol_info[key] = []
            continue
        wol_info.get(key, []).append(line.strip())
    return wol_info


def get_coalesce_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的coalesce_info信息
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.coalesce_info


def get_interrupt_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的interrupt_info信息
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.interrupt_info


def get_mac_tnl_status(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的mac_tnl_status信息
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.mac_tnl_status


def get_ptp_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的ptp_info信息
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.ptp_info


def get_tm_info(iface: str, tm_mod: str, terminal="server"):
    """
    功能描述: 获取tm/下的各个接口debug信息
    参数说明:
    iface    网口名
    tm_mod   寄存器模块 (qos_buf_cfg、qos_dscp_map、qos_pause_cfg、qos_pri_map、tc_sch_info、tm_map、tm_pg、tm_port、
    tm_priority、tm_qset、tm_nodes)
    terminal 终端(server|client)
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    """
    handler = hns_common.get_terminal_handler(terminal)
    tm_mod_list = ['qos_buf_cfg', 'qos_dscp_map', 'qos_pause_cfg', 'qos_pri_map', 'tc_sch_info',
                   'tm_map', 'tm_pg', 'tm_port', 'tm_priority', 'tm_qset']
    if global_config.lava_global.run_env_type != 1:
        tm_mod_list.append("tm_nodes")
    if tm_mod not in tm_mod_list:
        msg_center.error(f"不存在模块{tm_mod}！！")
        return FAILURE_CODE
    bus_info = hns_config_ethtool.get_iface_bdf(iface, terminal=terminal)
    if tm_mod == "qos_dscp_map":
        debugfs_tm = get_qos_dscp_map(iface, terminal=terminal)
    elif tm_mod == "tm_nodes":
        debugfs_tm = get_tm_nodes(iface, terminal=terminal)
    else:
        debugfs_tm = getattr(EthDebugfs(pci_bdf=bus_info, terminal=handler).tm, tm_mod)
    return debugfs_tm


def get_serv_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的ptp_info信息
    修改时间: 2022/11/16 10:44:29
    作    者: ywx925178
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.service_task_info


def get_ssu(iface, terminal="server"):
    """
    ============================================
    函数说明: 获取网口的ssu信息
    修改时间: 2023-03-02 11:35:16
    作   者: lwx567203
    ============================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.reg.ssu


def get_qos_pause_cfg(iface, terminal="server"):
    """
    ============================================
    函数说明: 获取pasue配置信息
    修改时间: 2023-04-06 14:14:53
    作   者: lwx567203
    ============================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.tm.qos_pause_cfg


def get_queue_map(bdf, queue, terminal="server"):
    """
    ============================================
    函数说明: 获取队列的queue map信息
    参数说明：
    bdf: bus-info信息
    queue: 要获取的对应queue的map信息
    作   者: dwx1206993
    ============================================
    """
    queue_map_dict = {}

    queue_map_info = hns_common.exec_command(command=f'cat {hns_config.DEBUG_DIR_HNS}/{bdf}/queue/queue_map',
                                             terminal=terminal)
    info_list = re.split("\n", queue_map_info)
    local_queue_id_index = info_list[0].split().index('local_queue_id')
    local_global_id_index = info_list[0].split().index('global_queue_id')
    vector_id_index = info_list[0].split().index('vector_id')

    local_id = info_list[1:][queue].split()[local_queue_id_index]
    global_id = info_list[1:][queue].split()[local_global_id_index]
    vector_id = info_list[1:][queue].split()[vector_id_index]

    queue_map_dict['local_queue_id'] = local_id
    queue_map_dict['global_queue_id'] = global_id
    queue_map_dict['vector_id'] = vector_id
    msg_center.info(f'队列{queue}的queue_map信息：{queue_map_dict}')

    return queue_map_dict


def dump_queue_map(iface, bdf, inters, terminal="server", global_qid_start=0):
    """
    函数说明：检查队列和中断映射信息正确
    参数说明：
    iface：网口名
    bdf: 网口bus-info信息
    inters: 中断个数
    """
    current_queue = hns_config_ethtool.get_queue_info(iface, terminal=terminal)
    msg_center.info('获取中断信息')
    info = hns_common.exec_command(command=f'cat /proc/interrupts | grep {bdf}-TxRx', terminal=terminal)
    interrupt_list = re.findall('(\d+): ', info)
    msg_center.info('判断vector id是否对应为中断号')
    num = current_queue // inters
    num1 = current_queue % inters
    min_q = 0
    for i in range(num):
        max_q = min_q + inters
        i = 0
        for queue in range(min_q, max_q):
            queue_map_dict = get_queue_map(bdf, queue, terminal=terminal)
            vector_id = queue_map_dict.get('vector_id')
            if int(vector_id) != int(interrupt_list[i]):
                msg_center.error(f'queue{queue}中的vector id与中断不符')
                return FAILURE_CODE
            i += 1
        min_q = max_q
    if num1 != 0:
        i = 0
        for queue in range(current_queue):
            queue_map_dict = get_queue_map(bdf, queue, terminal=terminal)
            vector_id = queue_map_dict.get('vector_id')
            if num * inters <= queue < current_queue:
                if int(vector_id) != int(interrupt_list[i]):
                    msg_center.error(f'queue{queue}中的vector id与中断不符')
                    return FAILURE_CODE
                i += 1

    msg_center.info('判断local queue id，global_queue_id是否对应为队列号')
    gid = global_qid_start
    for queue in range(current_queue):
        queue_map_dict = get_queue_map(bdf, queue, terminal=terminal)
        local_id = queue_map_dict.get('local_queue_id')
        global_id = queue_map_dict.get('global_queue_id')
        if int(local_id) != queue:
            msg_center.error(f'queue{queue}中的local queue id错误')
            return FAILURE_CODE
        if int(global_id) != gid:
            msg_center.error(f'queue{queue}中的global queue id错误')
            return FAILURE_CODE
        gid += 1

    return SUCCESS_CODE


def get_reset_info(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 读取网口的reset_info信息
    修改时间: 2023/7/19 10:44:29
    作    者: h00662017
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.reset_info


def get_rxtx_info(bdf, queue, queue_info, terminal='server'):
    """
    =====================================================================
    函数说明：查询队列使能状态
    作    者: dwx1206993
    =====================================================================
    """
    info_dict = {}

    info = hns_common.exec_command(command=f'cat {hns_config.DEBUG_DIR_HNS}/{bdf}/queue/{queue_info}',
                                   terminal=terminal)
    info_list = re.split("\n", info)

    bd_num_index = info_list[0].split().index('BD_NUM')
    tail_index = info_list[0].split().index('TAIL')
    head_index = info_list[0].split().index('HEAD')
    fbdnum_index = info_list[0].split().index('FBDNUM')
    base_addr_index = info_list[0].split().index('BASE_ADDR')
    ring_en_index = info_list[0].split().index('RING_EN')
    info_dict['BD_NUM'] = info_list[queue + 1].split()[bd_num_index]
    info_dict['TAIL'] = info_list[queue + 1].split()[tail_index]
    info_dict['HEAD'] = info_list[queue + 1].split()[head_index]
    info_dict['FBDNUM'] = info_list[queue + 1].split()[fbdnum_index]
    info_dict['BASE_ADDR'] = info_list[queue + 1].split()[base_addr_index]
    info_dict['RING_EN'] = info_list[queue + 1].split()[ring_en_index]

    if queue_info == 'rx_queue_info':
        bd_len_index = info_list[0].split().index('BD_LEN')
        pktnum_index = info_list[0].split().index('PKTNUM')
        rx_ring_en_index = info_list[0].split().index('RX_RING_EN')
        info_dict['BD_LEN'] = info_list[queue + 1].split()[bd_len_index]
        info_dict['PKTNUM'] = info_list[queue + 1].split()[pktnum_index]
        info_dict['RX_RING_EN'] = info_list[queue + 1].split()[rx_ring_en_index]

    elif queue_info == 'tx_queue_info':
        tc_index = info_list[0].split().index('TC')
        offset_index = info_list[0].split().index('OFFSET')
        tx_ring_en_index = info_list[0].split().index('TX_RING_EN')
        info_dict['TC'] = info_list[queue + 1].split()[tc_index]
        info_dict['OFFSET'] = info_list[queue + 1].split()[offset_index]
        info_dict['TX_RING_EN'] = info_list[queue + 1].split()[tx_ring_en_index]

    return info_dict


def get_uc(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口uc信息
    修改时间: 2023/07/28 16:48:00
    作    者: h00662017
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.mac_list.uc


def get_mc(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 获取网口mc信息
    修改时间: 2023/07/28 16:48:00
    作    者: h00662017
    =====================================================================
    """
    handler = get_debugfs_handler(iface, terminal=terminal)
    return handler.mac_list.mc
