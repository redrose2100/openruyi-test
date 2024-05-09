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
import math

from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from common_lib.testengine_lib.engine_global import engine_global as eg
from test_config.global_config import global_config
from common_lib.base_lib.base_wait_time import wait_time
from kp_comm import drive
from kp_comm import base
from feature_lib.hns_lib import hns_config_ethtool
from feature_lib.hns_lib import hns_config_basic
from feature_lib.hns_lib import hns_ko
from test_config.feature_config.hns_config import hns_config
from feature_lib.hns_lib import hns_common


class PtpClockSyn(object):
    """
    =====================================================================
    函数说明: PTP时钟同步
    修改时间: 2022/10/14 10:47:19
    作   者: ywx925178
    =====================================================================
    """
    def __init__(self, terminal: str = "server"):
        self.terminal = terminal

    def get_ptp_dev(self):
        """
        =====================================================================
        函数说明: 查询PTP设备
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        ret_str = hns_common.exec_command(terminal=self.terminal, command=f"ls {hns_config.PTP_DEV_PATH} | grep ptp")
        ptp_dev = []
        if ret_str == "":
            msg_center.info("没有PTP设备!")
            return ptp_dev

        ptp_dev_list = re.findall(r"ptp(\d+)", ret_str)
        for ptp_num in ptp_dev_list:
            ptp_dev.append("ptp" + ptp_num)
        return ptp_dev

    def set_ptp_clock(self, ptp_t, ptp_dev="ptp0"):
        """
        =====================================================================
        函数说明: 配置网口PTP时钟
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        msg_center.info("配置时间不一致")
        ret_str = hns_common.exec_command(terminal=self.terminal,
                                          command=f"{hns_config.PHC_CTL} /dev/{ptp_dev} set {ptp_t}")
        if "set clock time to" not in ret_str:
            msg_center.info("时间配置失败！")
            return FAILURE_CODE
        return SUCCESS_CODE

    @staticmethod
    def ptp_clock_syn(local_net, remote_net, sync_type="H", pro_type=4):
        """
        =====================================================================
        函数说明: PTP时钟同步
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        logfile = f"{eg.project.base_dir_path}/"
        msg_center.info("对端执行master模式")
        hns_common.exec_command(terminal="client", command=f"{hns_config.PTP4L_T} -{pro_type} -i {remote_net} "
                                                           f"-{sync_type} -m > {logfile}ptp_master.log 2>&1 &")
        msg_center.info("本端执行slave模式")
        hns_common.exec_command(command=f"{hns_config.PTP4L_T} -{pro_type} -i {local_net} "
                                        f"-{sync_type} -m -s > {logfile}ptp_slave.log 2>&1 &")
        time.sleep(hns_config.PTP_SLEEP_TIME)

    @staticmethod
    def get_ptp_clock_single(ptp_dev, terminal="server"):
        """
        =====================================================================
        函数说明: 获取时间
        参数说明: ptp_dev：PTP设备
        应用举例: NA
        修改时间: 2022/12/06 09:27:00
        作   者: ywx925178
        返回 值: 网口PTP时间
        =====================================================================
        """
        ret_str = hns_common.exec_command(terminal=terminal, command=f"{hns_config.PHC_CTL} /dev/{ptp_dev} get")
        ptp_t = re.findall(r"time is (\d+.\d+)", ret_str)[0]
        return ptp_t

    def get_ptp_clock(self, ptp_s_m="ptp0", ptp_s_s="ptp1", ptp_c="ptp0"):
        """
        =====================================================================
        函数说明: 获取两端ptp同步后时间
        参数说明: ptp_s_m：本端网口PTP设备；ptp_s_s：本端ptp同步设备；ptp_c：对端网口PTP设备
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        返回 值: ptp0_t_s：本端网口PTP时间；ptp1_t_s：本端ptp同步设备时间；ptp0_t_c：对端网口PTP时间
        =====================================================================
        """
        ptp0_t_s = self.get_ptp_clock_single(ptp_s_m)
        ptp1_t_s = self.get_ptp_clock_single(ptp_s_s)
        ptp0_t_c = 0
        if self.terminal == "client":
            ptp0_t_c = self.get_ptp_clock_single(ptp_c, terminal=self.terminal)
        return ptp0_t_s, ptp1_t_s, ptp0_t_c

    def check_ptp_clock(self):
        """
        =====================================================================
        函数说明: 校验PTP时钟同步后时间一致
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        msg_center.info("获取时钟同步后的时间")
        ptp0_t_s, ptp1_t_s, ptp0_t_c = self.get_ptp_clock()
        if self.terminal == "client":
            if math.fabs(float(ptp0_t_s) - float(ptp0_t_c)) > hns_config.PTP_ACCURACY_ERR:
                msg_center.error(f"本端ptp0设备时间未与对端ptp0同步！"
                                 f"本端与对端ptp0时间差：{math.fabs(float(ptp0_t_s) - float(ptp0_t_c))}")
                return FAILURE_CODE
        if math.fabs(float(ptp1_t_s) - float(ptp0_t_s)) > hns_config.PTP_ACCURACY_ERR:
            msg_center.error(f"ptpX设备时间未与ptp0同步！"
                             f"ptp0与ptpX时间差：{math.fabs(float(ptp1_t_s) - float(ptp0_t_s))}")
            return FAILURE_CODE
        return SUCCESS_CODE

    def get_ptp_platformdev(self):
        """
        =====================================================================
        函数说明: 获取ptp设备IO　die
        bind_unbind：绑定、解绑(bind/unbind)
        bdf：ptp设备bdf
        修改时间: 2022/03/23 16:51:21
        作    者: ywx925178
        =====================================================================
        """
        io_list = []
        ret_str = hns_common.exec_command(terminal=self.terminal,
                                          command=f"ls {hns_config.PTP_PD_PATH}/hisi_ptp | grep 'HISI'")
        if ret_str == "":
            msg_center.info("不存在PTP　platform设备！")
            return io_list
        io_list = re.findall(r"(\S+:\S+)", ret_str)
        return io_list

    def save_ptp_reslog(self, log_path):
        """
        =====================================================================
        函数说明: 保存PTP寄存器的值
        修改时间: 2022/03/23 16:51:21
        作    者: ywx925178
        =====================================================================
        """
        hns_common.exec_command(terminal=self.terminal,
                                command=f"cat {hns_config.PTP_REG_PATH} > {log_path}_rgs.txt 2>&1")

    def ptp_platformdev_bind_unbind(self, bind_unbind, io_die):
        """
        =====================================================================
        函数说明: ptp设备绑定解绑
        bind_unbind：绑定、解绑(bind/unbind)
        io_die：ptp设备IO die
        作    者: ywx925178
        =====================================================================
        """
        hns_common.exec_command(terminal=self.terminal,
                                command=f"echo {io_die} > /sys/bus/platform/drivers/hisi_ptp/{bind_unbind}")
        io_list = self.get_ptp_platformdev()
        if bind_unbind == "unbind":
            if io_die in io_list:
                msg_center.error("ptp设备解绑失败！")
                return FAILURE_CODE
        else:
            if io_die not in io_list:
                msg_center.error("ptp设备绑定失败！")
                return FAILURE_CODE
        return SUCCESS_CODE

    def insmod_hisi_ptp(self):
        """
        =====================================================================
        函数说明: 加载hisi_ptp驱动
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        handler = hns_common.get_terminal_handler(self.terminal)
        ptp_dev_list_bef = self.get_ptp_dev()
        ret_code, ret_info = drive.CmdDrive(terminal=handler).lsmod_ko(hns_config.PTP_KO)
        if ret_code:
            ptp_num = 1
            hns_ko.insmod_driver(hns_config.PTP_KO, terminal=self.terminal)
        else:
            ptp_num = 0
        ptp_dev_list_aft = self.get_ptp_dev()
        if len(ptp_dev_list_aft) - len(ptp_dev_list_bef) != ptp_num:
            msg_center.error("加载ptp驱动，/dev/目录未增加ptpX同步设备！")
            return FAILURE_CODE
        return SUCCESS_CODE

    def rmmod_hisi_ptp(self):
        """
        =====================================================================
        函数说明: 卸载hisi_ptp驱动
        函数返回: None
        应用举例: NA
        修改时间: 2022/10/09 09:27:00
        作   者: ywx925178
        =====================================================================
        """
        handler = hns_common.get_terminal_handler(self.terminal)
        ptp_dev_list_bef = self.get_ptp_dev()
        ret_code, ret_info = drive.CmdDrive(terminal=handler).lsmod_ko(hns_config.PTP_KO)
        if ret_code:
            ptp_num = 0
        else:
            hns_ko.rmmod_driver(hns_config.PTP_KO, terminal=self.terminal)
            ptp_num = 1
        ptp_dev_list_aft = self.get_ptp_dev()
        if len(ptp_dev_list_bef) - len(ptp_dev_list_aft) != ptp_num:
            msg_center.error("卸载ptp驱动，/dev/目录未删除ptpX同步设备！")
            return FAILURE_CODE
        return SUCCESS_CODE
