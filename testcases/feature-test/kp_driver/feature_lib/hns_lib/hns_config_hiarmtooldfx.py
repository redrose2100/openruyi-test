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
import time

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config import hns_config
from test_config.feature_config.hns_config import hns_register_config
from test_config.global_config import global_config
from feature_lib.hns_lib import hns_config_ethtool
from feature_lib.hns_lib import hns_common
from feature_lib.hns_lib import hns_debugfs
from feature_lib.hns_lib import hns_ko


def ppp_du_mac(iface, terminal="server"):
    """
    =====================================================================
    函数说明: 查询mac信息
    函数返回: (uc_mas, mc_macs)
    修改时间: 2022/03/10 09:52:17
    作    者: lwx567203
    =====================================================================
    """
    bdf = hns_config_ethtool.get_iface_bdf(iface)
    command = f"{hns_config.HIARMTOOL} ppp -i {iface} -du mac"
    lines = hns_common.exec_command(terminal=terminal, command=command)
    uc_macs, mc_macs = [], []
    for line in lines.splitlines():
        if "|" not in line:
            continue
        line = re.sub(" +", "", line)
        items = line.split("|")
        if global_config.lava_global.run_env_type == global_config.project_global.d06:
            lens = 10
        else:
            lens = 7
        if len(items) == lens and items[-3] == bdf[-1]:
            uc_macs.append(items[2])
        if len(items) == 3 and items[0] != "index":
            mc_macs.append(items[1])
        if "overflow" in line:
            break
    return uc_macs, mc_macs


def set_pause_storm(dev, mode, direct, period=2000, storm_time=500, recovery=500, terminal="server"):
    """
    =====================================================================
    函数说明：设置pause风暴
    参数说明：
    dev ：网络设备名
    mode：pause风暴 开/关
    dict：方向 tx/rx
    注意事项：无
    使用实例：set_pause_storm（"eth0","on","rx")
    作   者： ywx925178
    生成时间： 2022/03/09
    =====================================================================
    """
    # 参数：-d 方向 tx/rx ；-e 使能状态 0(disable)/1(enable) ；-p 时间间隔，多久查询一次pause风暴，单位ms,
    # 支持10进制/16进制； -t 风暴抑制时间 ；-r 恢复时间
    handler = hns_common.get_terminal_handler(terminal)
    key_value_dict = {
        "rx": "0", "tx": "1", "on": "1", "off": "0"
    }
    cmd = f"{hns_config.HIKPTOOLTEST} ext -i {dev} -t 14 -pd {key_value_dict.get(direct)} -pe {key_value_dict.get(mode)} " \
          f"-pp {period} -pt {storm_time} -pr {recovery}"
    handler.send_command(cmd)
    status = get_pause_storm_enable_status(dev, direct, terminal=terminal).get("enable")
    if status != key_value_dict.get(mode):
        msg_center.error("设置pause风暴失败！")
        return FAILURE_CODE
    return SUCCESS_CODE


def get_pause_storm_enable_status(network, direct, terminal="server"):
    """
    =====================================================================
    函数说明： 获取pause风暴使能状态
    参数说明：
    dev: 网口名
    direct: tx/rx
    注意事项：无
    使用实例：get_pause_storm_enable_status(self, dev, direct)
    对应命令：hiarmtooldfxpro storm -i eth0 -d 0
    作   者： ywx925178
    生成时间： 2022/03/09
    #!!=====================================================================
    """
    key_value_dict = {"rx": "0", "tx": "1", "on": "1", "off": "0"}
    handler = hns_common.get_terminal_handler(terminal)
    handler.send_command(f"{hns_config.HIKPTOOLTEST} ext -i {network} -t 15 -pd {key_value_dict.get(direct)}")
    ret_str = handler.information
    info_dict = {}
    if ret_str == "" or handler.ret_code != 0:
        msg_center.error(f"查询pause风暴使能信息失败！")
        return FAILURE_CODE

    for lines in ret_str.split("\n"):
        info_key = lines.split(":")[0].strip()
        info_dict[info_key] = lines.split(":")[1].strip()
    return info_dict


def get_adapt(dev, terminal="server"):
    """
    =====================================================================
    函数说明： 查询网口自适应模式
    参数说明：
    作   者： ywx925178
    #!!=====================================================================
    """
    handler = hns_common.get_terminal_handler(terminal)
    handler.send_command("%s self_adapt -i %s | grep 'adapt status' | awk '{print $NF}'" % (hns_config.HIARMTOOLPRO,
                                                                                            dev))
    return handler.information


def set_adapt(dev, adapt, terminal="server"):
    """
    =====================================================================
    函数说明： 配置网口自适应模式
    参数说明：adapt:自适应模式off/on
    作   者： ywx925178
    #!!=====================================================================
    """
    handler = hns_common.get_terminal_handler(terminal)
    handler.send_command(f"{hns_config.HIARMTOOLPRO} self_adapt -i {dev} -s {adapt}")
    if get_adapt(dev) != adapt:
        msg_center.error(f"配置网口自适应模式{adapt}失败！")
        return FAILURE_CODE
    return SUCCESS_CODE


def get_vlan_entries(dev, terminal="server"):
    """
    =====================================================================
    函数说明： 查询vlan表项
    参数说明：
    作   者： ywx925178
    #!!=====================================================================
    """
    handler = hns_common.get_terminal_handler(terminal)
    handler.send_command(f"{hns_config.HIARMTOOL} ppp -i {dev} -du vlan")
    return handler.information


def get_register_addr(network, ras_addr, terminal="server"):
    """
    =====================================================================
      函数名称 : get_register_addr
      函数说明 : 获取寄存器地址
      参数说明 : network:
               addr_bit_dict: 寄存器及注错bit的字典
    =====================================================================
    """
    hns_ko.insmod_hns3_cae(terminal=terminal)
    handler = hns_common.get_terminal_handler(terminal)
    if isinstance(ras_addr, int):
        ras_addr = hex(ras_addr)
    cmd = f"{hns_config.HIARMTOOL} reg -i {network} -a {ras_addr}"
    handler.send_command(cmd)
    value = handler.information.strip().split()[-1]
    try:
        value = int(value, 16)
    except ValueError:
        value = 0xffffffffffffff
    finally:
        pass
    return hex(value)


def hiarmtool_err_ras(network, kvargs, terminal="server"):
    """
    =====================================================================
      函数名称 : hiarmtool_err_ras
      函数说明 : 使用hiarmtool工具注入RAS错误
      参数说明 :
                network:
                addr_bit_dict: 寄存器及注错bit的字典
    =====================================================================
    """
    hns_ko.insmod_hns3_cae(terminal=terminal)
    for ras_addr, ras_bit in kvargs.items():
        if str(ras_addr).isdigit():
            ras_addr = hex(ras_addr)
        cmd = f"{hns_config.HIARMTOOL} reg -i {network} -a {ras_addr} -v {ras_bit}"
        result = hns_common.exec_command(terminal, cmd)
        if global_config.lava_global.run_env_type == 1:
            if result != "" and not result.count("Run ioctl failed"):
                return FAILURE_CODE
    return SUCCESS_CODE


def set_register_addr(network, addr, value, terminal="server"):
    """
    =====================================================================
      函数名称 : set_register_addr
      函数说明 : 配置寄存器地址
      参数说明 :
    =====================================================================
    """
    hns_ko.insmod_hns3_cae(terminal=terminal)
    handler = hns_common.get_terminal_handler(terminal)
    if isinstance(addr, int):
        addr = hex(addr)
    if isinstance(value, int):
        value = hex(value)
    cmd = f"{hns_config.HIARMTOOL} reg -i {network} -a {addr} -v {value}"
    handler.send_command(cmd)
    rg_value = get_register_addr(network, addr, terminal=terminal)
    if int(rg_value, 16) == int(value, 16):
        msg_center.info("修改寄存器地址成功！")
        return SUCCESS_CODE
    msg_center.info("修改寄存器地址失败！")
    return FAILURE_CODE


def hikptooltest(iface, cmd:str="pkt", back=False, terminal='server', **kwargs):
    """
    =====================================================================
    函数说明: hikptooltest工具
            hikptooltest pkt -i eth1 -bd 1 -n 100
            hikptooltest reg -i eth1 -a 0x10014040 -v 0x0001
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/08 15:40:01
    作    者: lwx567203
    =====================================================================
    """
    handler = hns_common.get_terminal_handler(terminal)
    key_convert = {
        'num': 'n',
        'pkt_type': 't',
        'pkt_len': 'l',
        'bd_num': 'bd',
        'addr': 'a',
        'value': 'v',
        'mode': 'm',
        'ctrl': 'c'
    }
    command = f"hikptooltest {cmd} -i {iface}"
    for key, value in kwargs.items():
        command = f"{command} -{key_convert.get(key)} {value}"
    if back:
        command = f"{command} &"
    handler.send_command(command)
    return handler.information


def hikp_fec_err(network, err_type, terminal="server"):
    """
    =====================================================================
    函数名称 : hikp_fec_err
    函数说明 : hikptooltest构造fec错误
    "BASEFEC注错步骤：可纠写0x7ff0070 不可纠写0x7ff0080 如下是可纠步骤
    1、配置eth1注错（注错寄存器地址bit0写0,bit4-7写0x7,bit16-31写0x7ff）：hikptooltest -i eth1 -a 0x1061e044 -v 0x7ff0070   ==>eth2就是0x1061e0C4
    2、注错使能：hikptooltest -i eth1 -a 0x1061e048  -v 0x1 ==>eth2就是0x1061e0C8
    3、查询注错统计：hikptooltest -i eth1 -a 0x1061e04c,记录结果 ==>eth2就是0x1061e0CC
    4、 hikptooltest -i eth1 -a 0x1061e044 -v 0x7ff0071
    5、使能:hikptooltest -i eth1 -a 0x1061e048  -v 0x1
    6、查询注错统计 重复步骤1-6 10次
    7、hikptooltest读取fecerr误码统计
    "RSFEC注错步骤：
    1、设置注错端口：hikptooltest -i eth1 -a 0x10620320 -v 0x0
    2、设置注错symbol:hikptooltest -i eth1 -a 0x10620328 -v 0x7
    3、设置注错symbol个数:hikptooltest -i eth1 -a 0x10620330 -v 0x7
    4、设置开始注错位置:hikptooltest -i eth1 -a 0x10620338 -v 0x40
    5、设置code word个数：hikptooltest -i eth1 -a 0x10620340 -v 0x2
    6、设置注错间隔：hikptooltest -i eth1 -a 0x10620350 -v 0x20
    7、设置注错模式为fix模式：hikptooltest -i eth1 -a 0x10620320 -v 0x0
    8、开始注错：hikptooltest -i eth1 -a 0x10620320 -v 0x1
    9、等待10S，停止注错：hikptooltest -i eth1 -a 0x10620320 -v 0x0
    10、查询TX统计：hikptooltest -i eth1 -a 0x10620360
    11、hikptooltest读取fecerr误码统计"
    参数说明 : err_type: base_corr/base_uncorr/rs
    作    者: ywx925178
    =====================================================================
    """
    # TX的注错是：
    # phy_id * 0x20 来计算的，目前fpga的端口只有phy0和phy4（4*0x20 +  0x1061e044 = 0x1061e0c4）
    # 端口是我们通常说的pf0和pf1，目前pf0对应mac0，对应phy0，pf1对应mac1，对应phy4
    phy_id = hns_debugfs.get_iface_mac_id(network, terminal=terminal) * 2
    if "base" in err_type:
        base_err_dict = {"base_corr": hns_register_config.BASE_CORR_ADDR_LIST,
                         "base_uncorr": hns_register_config.BASE_UNCORR_ADDR_LIST,
                         "base_all": hns_register_config.BASE_CORR_ADDR_LIST + hns_register_config.BASE_UNCORR_ADDR_LIST}
        for _ in range(5):
            for base_err in base_err_dict.get(err_type):
                for addr, value in zip(hns_register_config.BASE_ADDR_LIST, [hex(base_err), "0x1"]):
                    base_addr = hns_register_config.FEC_BASE_ADDR + addr + phy_id * 0x20
                    hikptooltest(network, cmd="reg", addr=hex(base_addr), value=value, terminal=terminal)
                get_fec_addr = hns_register_config.FEC_BASE_ADDR + hns_register_config.BASE_ERR_GET + phy_id * 0x20
                hikptooltest(network, cmd="reg", addr=hex(get_fec_addr), terminal=terminal)
            stop_addr = hns_register_config.FEC_BASE_ADDR + hns_register_config.BASE_ADDR_LIST[1] + phy_id * 0x20
            hikptooltest(network, cmd="reg", addr=hex(stop_addr), value="0x0", terminal=terminal)

    elif "rs" in err_type:
        rs_err_dict = {"rs_corr": hns_register_config.RS_UNCORR_ADDR_DICT,
                       "rs_uncorr": hns_register_config.RS_CORR_ADDR_DICT}
        hikptooltest(network, cmd="reg",
                     addr=hex(hns_register_config.FEC_BASE_ADDR + hns_register_config.RS_ADDR + phy_id * 0x20),
                     value="0x0", terminal=terminal)

        for addr, value in dict.items(rs_err_dict.get(err_type)):
            rs_addr = hns_register_config.FEC_BASE_ADDR + addr + phy_id * 0x20
            hikptooltest(network, cmd="reg", addr=hex(rs_addr), value=hex(value), terminal=terminal)

        for value in ["0x1", "0x0"]:
            time.sleep(10)
            hikptooltest(network, cmd="reg",
                         addr=hex(hns_register_config.FEC_BASE_ADDR + hns_register_config.RS_ADDR + phy_id * 0x20),
                         value=value, terminal=terminal)
    else:
        msg_center.info("错误类型输入错误！")
        return FAILURE_CODE
    return SUCCESS_CODE
