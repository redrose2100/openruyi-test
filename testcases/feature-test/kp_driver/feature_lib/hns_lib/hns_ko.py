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

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config import global_config
from test_config.feature_config.hns_config import hns_config
from kp_comm import drive
from kp_comm import base
from feature_lib.hns_lib import hns_common as comm, hns_hikptool
from feature_lib.hns_lib import hns_eth_attributes as attr
from feature_lib.hns_lib import hns_config_basic


def re_insmod_hns3(terminal="server", **kwargs):
    """重新加载hns3"""
    if rmmod_driver(hns_config.HNS3_KO, terminal=terminal) != SUCCESS_CODE:
        return FAILURE_CODE

    if insmod_driver(hns_config.HNS3_KO, terminal=terminal, **kwargs) != SUCCESS_CODE:
        return FAILURE_CODE

    # 2022/11/10 检查网口关系是否错乱并重命名
    comm.rename_iface(terminal)

    return SUCCESS_CODE


def insmod_driver(driver, terminal="server", check_dmesg=True, **kwargs):
    """
    =====================================================================
    函数说明: 加载驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:06:48
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    result = check_driver_modporbe(driver, status="insmod", terminal=terminal)
    if result == SUCCESS_CODE:
        return SUCCESS_CODE
    comm.clear_dmesg_log(terminal=terminal)
    ko_path = f"{hns_config.KO_PAYH}/{driver}.ko"
    if "pmu" in ko_path:
        msg = comm.exec_command(command=f"ls {ko_path}")
        if "No such file or directory" in msg:
            ko_path = f"{hns_config.PMU_KO_PATH}/{driver}.ko"
    # 2022/12/5 适配OS，先判断ko存不存在，不存在则复制
    msg = comm.exec_command(terminal=terminal, command=f"ls {ko_path}")
    if "No such file or directory" in msg:
        true_path = comm.exec_command(terminal=terminal, command=f"modinfo {driver} |grep -i filename |awk '{{print$2}}'")
        comm.exec_command(terminal=terminal, command=f"cp {true_path} {ko_path}")
    if drive.CmdDrive(terminal=handler).insmod_ko([ko_path], **kwargs) != SUCCESS_CODE:
        return FAILURE_CODE

    # 2023/02/16 Nezha加载驱动修改mac末两位为0
    if global_config.lava_global.bios_version.lower() == hns_config.NEZHA_BIOS.lower() and driver == hns_config.HNS3_KO:
        for hns_net in hns_config.ALL_LOCAL_NETWORK_LIST_ISO:
            handler.send_command(f"{hns_config.ETHTOOL} -i {hns_net} | grep driver")
            if "hns3" not in handler.information:
                continue
            mac = attr.get_iface_mac(hns_net, terminal=terminal)
            set_mac = ""
            for i in range(4):
                set_mac += mac.split(":")[i] + ":"
            hns_config_basic.ifconfig_basic(hns_net, f"hw ether {set_mac}00:00", terminal=terminal)

    if check_dmesg:
        result = comm.check_dmesg(hns_config.DMESG_CHECK, terminal=terminal)
        if result != SUCCESS_CODE:
            msg_center.error("dmesg有错误信息存在:")
            msg_center.error(f"{handler.information}")
            return FAILURE_CODE

    # 2022/11/10 检查网口关系是否错乱并重命名
    if driver == hns_config.HNS3_KO:
        comm.rename_iface(terminal)

    return SUCCESS_CODE


def insmod_hnae3(terminal="server"):
    """
    =====================================================================
    函数说明: 加载hnae3驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:37:59
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.HNAE3_KO, terminal=terminal)


def insmod_hclge(terminal="server"):
    """
    =====================================================================
    函数说明: 加载hclge驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:40:00
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.HCLGE_KO, terminal=terminal)


def insmod_hclgevf(terminal="server"):
    """
    =====================================================================
    函数说明: 加载hclgevf驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:40:00
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.HCLGEVF_KO, terminal=terminal)


def insmod_hns3(terminal="server", **kwargs):
    """
    =====================================================================
    函数说明: 加载hns3驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:40:00
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.HNS3_KO, terminal=terminal, **kwargs)


def insmod_hns3_cae(terminal="server"):
    """
    =====================================================================
    函数说明: 加载hns3_cae驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:40:00
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.CAE_KO, terminal=terminal)


def insmod_vfio(terminal="server", **kwargs):
    """
    ============================================
    函数说明: 加载vfio.ko
    修改时间: 2023-02-22 11:45:24
    作   者: lwx567203
    ============================================
    """
    return insmod_driver(hns_config.VFIO, terminal=terminal, **kwargs)


def insmod_vfio_virqfd(terminal="server", **kwargs):
    """
    ============================================
    函数说明: 6.2以前的版本加载vfio_virqfd.ko
    修改时间: 2023-02-22 11:47:19
    作   者: lwx567203
    ============================================
    """
    return insmod_driver(hns_config.VFIO_VIRQRD, terminal=terminal, **kwargs)


def insmod_vfio_pci_core(terminal="server", **kwargs):
    """
    ============================================
    函数说明: 6.2以后的版本加载vfio_pci_core.ko
    修改时间: 2023-02-22 11:47:19
    作   者: lwx567203
    ============================================
    """
    return insmod_driver(hns_config.VFIO_PCI_CORE, terminal=terminal, **kwargs)


def insmod_vfio_pci(terminal="server", **kwargs):
    """
    ============================================
    函数说明: 加载vfio-pci.ko
    修改时间: 2023-02-22 11:47:19
    作   者: lwx567203
    ============================================
    """
    return insmod_driver(hns_config.VFIO_PCI, terminal=terminal, **kwargs)


def insmod_vfio_iommu_type1(terminal="server", **kwargs):
    """
    ============================================
    函数说明: 加载vfio_iommu_type1.ko
    修改时间: 2023-02-22 11:47:19
    作   者: lwx567203
    ============================================
    """
    return insmod_driver(hns_config.VFIO_IOMMU_TYPE1, terminal=terminal, **kwargs)


def insmod_vfio_ko(terminal="server"):
    """
    ============================================
    函数说明: 加载vfio相关驱动
    修改时间: 2023-02-22 11:50:45
    作   者: lwx567203
    ============================================
    """
    functions = [insmod_vfio, insmod_vfio_virqfd, insmod_vfio_pci, insmod_vfio_iommu_type1]
    if hns_config.IMAGE_VERSION.get(terminal) == hns_config.PLINTH_NAME:
        functions = [insmod_vfio, insmod_vfio_virqfd, insmod_vfio_pci, insmod_vfio_iommu_type1]
    params = [{"enable_unsafe_noiommu_mode": 1}, {}, {}, {}]
    for function, param in zip(functions, params):
        result = function(terminal=terminal, **param)
        if result != SUCCESS_CODE:
            return FAILURE_CODE
    return SUCCESS_CODE


def rmmod_hns3_cae(terminal="server"):
    """
    =====================================================================
    函数说明: 加载hns3_cae驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:40:00
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.CAE_KO, terminal=terminal)


def insmod_roce(terminal="server"):
    """
    =====================================================================
    函数说明: 加成hns_roce驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:53:43
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.ROCE_KO, terminal=terminal)


def insmod_hns_ko(terminal="server", roce_flage=1):
    """
    =====================================================================
    函数说明: 加载内核驱动
    :param terminal 终端类型(server|client)
    :param roce_flage: 1 需要加载roce驱动 0 不需要roce驱动
    函数返回: SUCCESS_CODE|FAILURE_CODE
    应用举例: insmod_hns_ko(terminal="server")
    修改时间: 2021/08/24 09:33:22
    作    者: lwx567203
    =====================================================================
    """
    functions = [insmod_hnae3, insmod_hclge, insmod_hclgevf, insmod_hns3, insmod_hns3_cae]
    if roce_flage == 1:
        if global_config.lava_global.run_env_type != 3:
            functions.append(insmod_roce)
    for function in functions:
        result = function(terminal=terminal)
        if result != SUCCESS_CODE:
            return FAILURE_CODE
    return SUCCESS_CODE


def insmod_bonding(terminal="server"):
    """
    =====================================================================
    函数说明: 加成bonding驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 10:53:43
    作    者: lwx567203
    =====================================================================
    """
    return insmod_driver(hns_config.BONDING_KO, terminal=terminal)


def rmmod_driver(driver, terminal="server", check_dmesg=True):
    """
    =====================================================================
    函数说明: 卸载驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 09:36:35
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    result = check_driver_modporbe(driver, status="rmmod", terminal=terminal)
    if result == SUCCESS_CODE:
        return SUCCESS_CODE

    # 卸载依赖它的驱动
    driver = driver.replace("-", "_")
    result = comm.exec_command(terminal, f"ls /sys/module/{driver}/holders/")
    for use_driver in result.split():
        msg_center.info(f"开始卸载依赖{driver}的驱动：{use_driver}")
        rmmod_driver(use_driver, terminal)

    comm.clear_dmesg_log(terminal=terminal)
    if drive.CmdDrive(terminal=handler).rmmod_ko([driver]) != SUCCESS_CODE:
        return FAILURE_CODE

    if driver == hns_config.CAE_KO:
        hns_hikptool.HikpToolTest().has_hns3_cae[terminal] = False

    if check_dmesg:
        result = comm.check_dmesg("NULL pointer|kernel paging|panic|deadlocked|call trace|error", terminal=terminal, shield=False)
        if result != SUCCESS_CODE:
            msg_center.error("dmesg有错误信息存在:")
            msg_center.error(f"{handler.information}")
            return FAILURE_CODE
    return SUCCESS_CODE


def rmmod_roce(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载hns3驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:00:16
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.ROCE_KO, terminal=terminal)


def rmmod_hns3(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载hns3驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:00:16
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.HNS3_KO, terminal=terminal)


def rmmod_hclgevf(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载hclgevf驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:00:16
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.HCLGEVF_KO, terminal=terminal)


def rmmod_hclge(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载hclge驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:03:43
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.HCLGE_KO, terminal=terminal)


def rmmod_hnae3(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载hnae3驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:03:54
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.HNAE3_KO, terminal=terminal)


def rmmod_hns_ko(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载内核驱动
    :param terminal 终端类型(server|client)
    函数返回: SUCCESS_CODE|FAILURE_CODE
    应用举例: rmmod_hns_ko(terminal="server")
    修改时间: 2021/08/24 09:41:05
    作    者: lwx567203
    =====================================================================
    """
    functions = [rmmod_hns3, rmmod_hclge, rmmod_hclgevf, rmmod_hnae3]
    if global_config.lava_global.run_env_type != 3:
        functions.insert(0, rmmod_roce)
    for function in functions:
        result = function(terminal=terminal)
        if result == FAILURE_CODE:
            return FAILURE_CODE
    return SUCCESS_CODE


def rmmod_bonding(terminal="server"):
    """
    =====================================================================
    函数说明: 卸载bonding驱动
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/11/04 11:03:54
    作    者: lwx567203
    =====================================================================
    """
    return rmmod_driver(hns_config.BONDING_KO, terminal=terminal)


def insmod_pmu_ko(terminal="server", check_dmesg=True):
    """
    加载HNS IO PMU驱动
    """
    handler = comm.get_terminal_handler(terminal=terminal)
    if insmod_hns_ko(terminal=terminal) != SUCCESS_CODE:
        msg_center.error("加载hns内核驱动失败")
        return FAILURE_CODE

    if insmod_driver(hns_config.PMU_KO, terminal=terminal) != SUCCESS_CODE:
        msg_center.error("加载pmu内核驱动失败")
        return FAILURE_CODE

    cmd = "ls %s | grep 'hisi_hns' |awk '{print $NF}'" % hns_config.PMU_DEV_PATH
    handler.send_command(cmd)
    pmu_dev_list = handler.stdout.strip('\n').split('\n')
    for pmu_dev in pmu_dev_list:
        file_list = ['events/bw_ssu_egu', 'filtermode/bw_ssu_egu', 'format/event']
        for file_name in file_list:
            file_path = os.path.join(hns_config.PMU_DEV_PATH, pmu_dev, file_name)
            if base.CmdOs(terminal=handler).check_exist_file(file_path) != True:
                return FAILURE_CODE

    handler.send_command(hns_config.DMESG_CHECK)
    if handler.information not in (None, "") and check_dmesg is True:
        msg_center.error("dmesg有错误信息存在")
        return FAILURE_CODE
    return SUCCESS_CODE


def rmmod_pmu_ko(terminal="server", check_dmesg=True):
    """
    卸载HNS IO PMU驱动
    """
    handler = comm.get_terminal_handler(terminal=terminal)
    if rmmod_driver(hns_config.PMU_KO, terminal=terminal):
        msg_center.error("卸载pmu内核驱动失败")
        return FAILURE_CODE

    cmd = "ls %s | grep 'hisi_hns'" % hns_config.PMU_DEV_PATH
    handler.send_command(cmd)
    if handler.ret_code == SUCCESS_CODE:
        msg_center.info("after rmmod pmu ko, file should not exists, fail")
        return FAILURE_CODE

    handler.send_command(hns_config.DMESG_CHECK)
    if handler.information not in (None, "") and check_dmesg is True:
        msg_center.error("dmesg有错误信息存在")
        return FAILURE_CODE
    return SUCCESS_CODE


def check_driver_modporbe(driver:str, status="insmod", terminal="server"):
    """
    =====================================================================
    函数说明: 检查驱动是否已加载或卸载
    :param driver   驱动名称
    :param status   驱动状态(insmod|rmmod)
    :param terminal 终端类型(server|client)
    函数返回: True|False
    应用举例: check_driver_modporbe("hns3", status="insmod", terminal="server")
    修改时间: 2021/08/23 15:28:57
    备注：公共函数lsmod的返回不好用，所以这里没用
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal=terminal)
    driver_name = driver.replace("-", "_")
    handler.send_command("lsmod | awk '{{print$1}}' | grep -iw {}".format(driver_name))
    result = handler.information.strip().lower()
    if (result, status) == (driver.replace("-", "_"), "insmod"):
        msg_center.info("驱动%s已加载", driver)
        return SUCCESS_CODE
    if (result, status) == ("", "rmmod"):
        msg_center.info("驱动%s已卸载", driver)
        return SUCCESS_CODE
    return FAILURE_CODE


def set_pagepool_status(enable='1', terminal='server'):
    """
    网口收包流程是否增加 page pool，默认为使能
    :param enable:
    :param execution:
    :return:
    """
    handler = comm.get_terminal_handler(terminal)
    if rmmod_driver(hns_config.HNS3_KO, terminal=terminal) != SUCCESS_CODE:
        return FAILURE_CODE
    ko_path = f"{hns_config.KO_PAYH}/{hns_config.HNS3_KO}.ko"
    dic = {"page_pool_enabled": enable}
    if drive.CmdDrive(terminal=handler).insmod_ko([ko_path], **dic) != SUCCESS_CODE:
        return FAILURE_CODE
    cmd = "cat /sys/module/hns3/parameters/page_pool_enabled"
    handler.send_command(cmd)
    if (enable == '1' and handler.information != 'Y') or (enable == '0' and handler.information != 'N'):
        msg_center.info("配置pagepool失败，请检查！！")
        return FAILURE_CODE
    return SUCCESS_CODE
