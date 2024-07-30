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



import sys
import time

import re
from common_lib.base_lib.base_log_message import LOG_LEVEL_WARNING, LOG_LEVEL_INFO, log_message

FORCE_PAUSE_ENABLE = 0
FORCE_PAUSE_DISABLE = 1
INTERVALS = 0.01


class EthernetRegisterGe():

    def __init__(self, telnet, dev, succ="\[SUCCEED"):
        """
        #!!================================================================
        #  类名：    ethernet_register_ge
        #  函数说明：    以太接口命令的AW封装；
        #  参数说明：
        #            telnet:     远程连接com口的telnet终端
        #            dev:       设备的名字，比如 eth0, eth5
        #            succ:      命令执行成功回显，命令执行示例
        #                       1630~#hikptooltest reg -i eth1 -a 0x48090500120 -v 0xc
        #                       hikptooltest[9878]: [1970-01-02 14:41:45] [unknown@local] [hikptooltest reg -i e
        #                       th1 -a 0x48090500120 -v 0xc] [14:41:45] [SUCCEED].
        #                       1630~#
        #  注意事项：无
        #  作    者:pwx468996
        #  生成日期：  2017-06-06
        #  修改纪录：
        #!!================================================================
        """
        self.up = telnet
        self.dev = dev
        self.succ = succ

        # GE寄存器地址格式
        self.base_addr = 0x10500000
        self.unimac_offset = 0x80000
        self.mac_offset = 0x1000

        return

    def get_reg_value(self, reg):
        """
        #!!=====================================================================
        # 过  程  名： get_reg_value
        # 函数说明： 提取匹配的寄存器的值
        # 参数说明：reg：寄存器地址，比如0x13050205c
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        reg_value = None

        cmd = 'hikptooltest reg -i %s -a 0x%x' % (self.dev, reg)
        log_message(LOG_LEVEL_INFO, "telnet", "%s:%s cmd=%s", self.up.hostip, self.up.hostport, cmd)
        msg = self.up.send_command_one_by_one(cmd, self.succ, 10, INTERVALS)

        if len(re.findall(self.succ, msg)) >= 1:
            retcode = 0

        pattern = 'value\s*:\s*(0x\w+)'
        match = re.findall(pattern, msg)
        if match:
            retcode = 0
            reg_value = match[0]

        return retcode, reg_value

    def set_reg_value(self, reg, value):
        """
        #!!=====================================================================
        # 过  程  名： set_reg_value
        # 函数说明： 配置匹配的寄存器的值
        # 参数说明：reg：寄存器地址，比如0x13050205c
        #          value: 寄存器值，比如0x00000001
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2019-10-23
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""

        cmd = 'hikptooltest reg -i %s -a 0x%x -v 0x%x' % (self.dev, reg, value)
        log_message(LOG_LEVEL_INFO, "telnet", "%s:%s cmd=%s", self.up.hostip, self.up.hostport, cmd)
        retstr = self.up.send_command_one_by_one(cmd, self.succ, 10, INTERVALS)

        if len(re.findall(self.succ, retstr)) >= 1:
            retcode = 0

        return retcode, retstr

    def get_reg_value_64(self, reg):
        """
        #!!=====================================================================
        # 过  程  名： get_reg_value_64
        # 函数说明： 提取匹配的寄存器的值
        # 参数说明：reg：寄存器地址，比如0x10500ca8
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-09
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        reg_value = None

        cmd = 'hikptooltest reg -i %s -a 0x%x -b 64' % (self.dev, reg)
        log_message(LOG_LEVEL_INFO, "telnet", "%s:%s cmd=%s", self.up.hostip, self.up.hostport, cmd)
        msg = self.up.send_command_one_by_one(cmd, self.succ, 10, INTERVALS)

        if len(re.findall(self.succ, msg)) >= 1:
            retcode = 0

        pattern = 'value\s*:\s*(0x\w+)'
        match = re.findall(pattern, msg)
        if match:
            retcode = 0
            reg_value = match[0]

        return retcode, reg_value

    def set_reg_value_64(self, reg, value):
        """
        #!!=====================================================================
        # 过  程  名： set_reg_value_64
        # 函数说明： 配置匹配的寄存器的值
        # 参数说明：reg：寄存器地址，比如0x10500ca8
        #          value: 寄存器值，比如0xFFFFFFFF00
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-09
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""

        cmd = 'hikptooltest reg -i %s -a 0x%x -v 0x%x -b 64' % (self.dev, reg, value)
        log_message(LOG_LEVEL_INFO, "telnet", "%s:%s cmd=%s", self.up.hostip, self.up.hostport, cmd)
        retstr = self.up.send_command_one_by_one(cmd, self.succ, 10, INTERVALS)

        if len(re.findall(self.succ, retstr)) >= 1:
            retcode = 0

        return retcode, retstr

    def make_addr(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： make_addr
        # 函数说明： 拼接基地址
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：拼接好的基地址
        # 注意事项：内部调用
        #
        # 
        # 生成时间： 2020-07-20
        # 修改纪录：
        #!!=====================================================================
        """
        return self.base_addr + unimac * self.unimac_offset + mac * self.mac_offset

    def link_up_check(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： link_up_check
        # 函数说明： 检查端口是否是link up状态
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 link up状态;
        #              1 link down状态;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x42c
        retcode, value = self.get_reg_value(addr)
        link_status = ((int(value, 16)) & 0x100000) >> 20

        if link_status == 1:
            retcode = 0
            retstr = "unimac%d_mac%d link状态为link up" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d link状态不为link up" % (unimac, mac)

        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)
        return retcode, retstr

    def get_tx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_mib
        # 函数说明： 获取接收方向报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #             -1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        check_err = 0
        tx_mib_packet = 0
        tx_bad_packet = 0

        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcac + base_addr, 0xca8 + base_addr, 0xcbc + base_addr, 0xcb8 + base_addr,
                      0xc9c + base_addr, 0xc98 + base_addr]

        retcode, tx_goodpkt_h = self.get_reg_value(addr_liter[0])
        retcode, tx_goodpkt_l = self.get_reg_value(addr_liter[1])
        retcode, tx_total_h = self.get_reg_value(addr_liter[2])
        retcode, tx_total_l = self.get_reg_value(addr_liter[3])
        retcode, tx_bad_h = self.get_reg_value(addr_liter[4])
        retcode, tx_bad_l = self.get_reg_value(addr_liter[5])
        if retcode != 0:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "read register failed!")
            return retcode, (check_err, tx_mib_packet, tx_bad_packet)

        tx_good_packet = (int(tx_goodpkt_l, 16)) + (int(tx_goodpkt_h, 16)) * 0x100000000
        tx_bad_packet = (int(tx_bad_l, 16)) + (int(tx_bad_h, 16)) * 0x100000000
        if tx_bad_packet != 0:
            check_err += 1
        if check_err == 0:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "No error packets!")
        else:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "fail:badpkts exit in tx path")
        tx_mib_packet = (int(tx_total_l, 16)) + (int(tx_total_h, 16)) * 0x100000000

        return retcode, (tx_good_packet, tx_mib_packet, tx_bad_packet)

    def set_tx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_mib
        # 函数说明： 1GE设置发送方向报文统计寄存器
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #             -1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        base_addr = self.make_addr(unimac, mac) + 0xca8
        retcode, retstr = self.set_reg_value_64(base_addr, 0xffffffff00)
        return retcode, retstr

    def read_tx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： read_tx_mib
        # 函数说明： 判断发送方向报文统计寄存器是否正常写入
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        base_addr = self.make_addr(unimac, mac) + 0xca8
        check_err = 0
        retcode, value_h = self.get_reg_value_64(base_addr)
        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "tx value:%s", value_h)
        if value_h != "0xffffffff00":
            check_err += 1

        if check_err == 0:
            retcode = 0
            retstr = "unimac%d_mac%d tx寄存器写值成功" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d tx寄存器写值失败" % (unimac, mac)

        return retcode, retstr

    def check_max_tx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： check_max_tx_mib
        # 函数说明： 1GE检查发送方向报文统计是否是最大值
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        base_addr = self.make_addr(unimac, mac) + 0xca8
        check_err = 0
        retcode, value_h = self.get_reg_value_64(base_addr)
        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "tx value:%s", value_h)
        if value_h != "0xffffffffff":
            check_err += 1

        if check_err == 0:
            retcode = 0
            retstr = "unimac%d_mac%d tx寄存器保持最大值" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d tx寄存器没有保持最大值" % (unimac, mac)

        return retcode, retstr

    def get_rx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_mib
        # 函数说明： 获取接收方向报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #             -1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        check_err = 0
        rx_mib_packet = 0
        rx_bad_packet = 0

        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xe0c + base_addr, 0xe08 + base_addr, 0xe1c + base_addr, 0xe18 + base_addr,
                      0xdfc + base_addr, 0xdf8 + base_addr]

        retcode, rx_goodpkt_h = self.get_reg_value(addr_liter[0])
        retcode, rx_goodpkt_l = self.get_reg_value(addr_liter[1])
        retcode, rx_total_h = self.get_reg_value(addr_liter[2])
        retcode, rx_total_l = self.get_reg_value(addr_liter[3])
        retcode, rx_bad_h = self.get_reg_value(addr_liter[4])
        retcode, rx_bad_l = self.get_reg_value(addr_liter[5])
        if retcode != 0:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "read register failed!")
            return retcode, (check_err, rx_mib_packet, rx_bad_packet)

        rx_good_packet = (int(rx_goodpkt_l, 16)) + (int(rx_goodpkt_h, 16)) * 0x100000000
        rx_bad_packet = (int(rx_bad_l, 16)) + (int(rx_bad_h, 16)) * 0x100000000
        if rx_bad_packet != 0:
            check_err += 1
        if check_err == 0:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "No bad packets!")
        else:
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "%s",
                        "fail:badpkts exit in rx path")
        rx_mib_packet = (int(rx_total_l, 16)) + (int(rx_total_h, 16)) * 0x100000000

        return retcode, (rx_good_packet, rx_mib_packet, rx_bad_packet)

    def set_rx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_mib
        # 函数说明： 设置rx方向报文统计寄存器
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #             -1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""

        base_addr = self.make_addr(unimac, mac) + 0xe08
        retcode, retstr = self.set_reg_value_64(base_addr, 0xffffffff00)

        return retcode, retstr

    def read_rx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： read_rx_mib
        # 函数说明： 判断接收方向报文统计寄存器是否正常写入
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        base_addr = self.make_addr(unimac, mac) + 0xe08
        check_err = 0
        retcode, value_h = self.get_reg_value_64(base_addr)
        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "rx value:%s", value_h)
        if value_h != "0xffffffff00":
            check_err += 1

        if check_err == 0:
            retcode = 0
            retstr = "unimac%d_mac%d rx寄存器写值成功" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d rx寄存器写值失败" % (unimac, mac)

        return retcode, retstr

    def check_max_rx_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： check_max_rx_mib
        # 函数说明： 检查rx方向最大报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 结果不正确
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        base_addr = self.make_addr(unimac, mac) + 0xe08
        check_err = 0
        retcode, value_h = self.get_reg_value_64(base_addr)
        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + sys._getframe().f_code.co_name, "rx value:%s",
                    value_h)
        if value_h != "0xffffffffff":
            check_err += 1

        if check_err == 0:
            retcode = 0
            retstr = "unimac%d_mac%d rx寄存器保持最大值" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d rx寄存器没有保持最大值" % (unimac, mac)

        return retcode, retstr

    def check_link_down_int(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： check_link_down_int
        # 函数说明： 检查是否产生link down中断
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        link_down = None
        addr = self.make_addr(unimac, mac) + 0x000
        retcode, value = self.get_reg_value(addr)
        link_down = ((int(value, 16)) & 0x40) >> 6

        if link_down == 1:
            retcode = 0
            retstr = "unimac%d_mac%d 产生link down中断" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d 没有产生link down中断" % (unimac, mac)

        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)
        return retcode, link_down

    def check_link_up_int(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： check_link_up_int
        # 函数说明： 检查是否产生link up中断
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        link_up = None
        addr = self.make_addr(unimac, mac) + 0x000
        retcode, value = self.get_reg_value(addr)
        link_up = ((int(value, 16)) & 0x20) >> 5

        if link_up == 1:
            retcode = 0
            retstr = "unimac%d_mac%d 产生link up中断" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d 没有产生link up中断" % (unimac, mac)

        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)
        return retcode, link_up

    def check_mac_int(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： check_mac_int
        # 函数说明： 检查mac是否产生中断
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 无中断上报;
        #              1 有中断上报;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x000
        retcode, init_value = self.get_reg_value(addr)
        int_value = int(init_value, 16)

        if int_value == 0:
            retcode = 0
            retstr = "unimac%d_mac%d无中断上报" % (unimac, mac)
        else:
            retcode = 1
            retstr = "unimac%d_mac%d有中断上报" % (unimac, mac)

        log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)
        return retcode, retstr

    def clean_int(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： clean_int
        # 函数说明： 清理验证板中断统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x000
        retcode, retstr = self.set_reg_value(addr, 0xfff)
        return retcode, retstr

    def enable_int(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： enable_int
        # 函数说明： 使能中断
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x004
        retcode, retstr = self.set_reg_value(addr, 0x71F)
        return retcode, retstr

    def set_port_rxen(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_port_rxen
        # 函数说明： 端口接收方向使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否开启使能(1：使能；0：去使能)
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x100
        set_value = 0x1 + enable * 0x2
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_port_txen(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_port_txen
        # 函数说明： 端口接收方向使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否开启使能(1：使能；0：去使能)
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x100
        set_value = 0x2 + enable * 0x1
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_port_txrxen(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_port_txrxen
        # 函数说明： 端口发送和接收方向使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否开启使能(1：使能；0：去使能)
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x100
        set_value = enable * 0x3
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_loop(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_loop
        # 函数说明： 设置验证板环回
        # 参数说明：
        #           enable：是否开启环回
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：0x4809054011c
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retcode = ""
        mac_loop_rx2tx = self.make_addr(unimac, mac) + 0x4011c
        retcode, value = self.get_reg_value(mac_loop_rx2tx)
        set_value = ((int(value, 16)) & 0xfffffffb) + enable * 0x4
        retcode, retstr = self.set_reg_value(mac_loop_rx2tx, set_value)
        return retcode, retstr

    def set_mag_tx2rx_loopback(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_mag_tx2rx_loopback
        # 函数说明： 设置验证板内环回
        # 参数说明：
        #           enable：是否开启环回
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：0x4809054011c
        #
        # 
        # 生成时间： 2021-03-10
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retcode = ""
        tx2rx = self.make_addr(unimac, mac) + 0x4011c
        retcode, value = self.get_reg_value(tx2rx)
        set_value = ((int(value, 16)) & 0xffff001f) + enable * 0x3220
        retcode, retstr = self.set_reg_value(tx2rx, set_value)
        return retcode, retstr

    def get_mag_tx_all_pkt_cnt(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_mag_tx_all_pkt_cnt
        # 函数说明： 获取mag tx总包统计
        # 参数说明：mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-11
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        mag_tx_all = None
        base_addr = 0x10820118 + 0x100000 * mac
        retcode, mag_tx_all = self.get_reg_value_64(base_addr)
        return retcode, int(mag_tx_all, 16)

    def get_mag_rx_all_pkt_cnt(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_mag_rx_all_pkt_cnt
        # 函数说明： 获取mag rx总包统计
        # 参数说明：mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-11
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        mag_rx_all = None
        base_addr = 0x10820100 + 0x100000 * mac
        retcode, mag_rx_all = self.get_reg_value_64(base_addr)
        return retcode, int(mag_rx_all, 16)

    def get_mag_tx_err_pkt_cnt(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_mag_tx_err_pkt_cnt
        # 函数说明： 获取mag tx错包统计
        # 参数说明：mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-11
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        mag_tx_err = None
        base_addr = 0x10820368 + 0x100000 * mac
        retcode, mag_tx_err = self.get_reg_value_64(base_addr)
        return retcode, int(mag_tx_err, 16)

    def get_mag_rx_err_pkt_cnt(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_mag_rx_all_pkt_cnt
        # 函数说明： 获取mag rx错包统计
        # 参数说明：mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-11
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        mag_rx_err = None
        base_addr = 0x10820350 + 0x100000 * mac
        retcode, mag_rx_err = self.get_reg_value_64(base_addr)
        return retcode, int(mag_rx_err, 16)

    def set_ipg(self, unimac, mac, value):
        """
        #!!=====================================================================
        # 过  程  名： set_ipg
        # 函数说明： 设置ipg
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           value：设置的ipg的值
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x120
        retcode, value_tmp = self.get_reg_value(addr)
        set_value = ((int(value_tmp, 16)) & 0xffffff00) + value
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_min_pkt_size(self, unimac, mac, value):
        """
        #!!=====================================================================
        # 过  程  名： set_min_pkt_size
        # 函数说明： 设置最小帧
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           value：设置最小帧的值
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x128
        retcode, retstr = self.set_reg_value(addr, value)
        return retcode, retstr

    def set_max_pkt_size(self, unimac, mac, value):
        """
        #!!=====================================================================
        # 过  程  名： set_max_pkt_size
        # 函数说明： 设置最大帧
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           value：设置最大帧的值
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x12c
        retcode, retstr = self.set_reg_value(addr, value)
        return retcode, retstr

    def set_reset(self, unimac, mac, value):
        """
        #!!=====================================================================
        # 过  程  名： set_reset
        # 函数说明： 设置端口reset 模式
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           value：设置reset值
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x040
        retcode, retstr = self.set_reg_value(addr, value)
        return retcode, retstr

    def reset_port(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： reset_port
        # 函数说明： 端口复位
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-28
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = 0x10310ab0
        retcode, old_value = self.get_reg_value(addr)
        tmp_value = int(old_value, 16) & 0xfffffff0
        new_value = tmp_value + 1 << mac
        retcode, retstr = self.set_reg_value(addr, new_value)
        return retcode, retstr

    def dis_reset_port(self, mac):
        """
        #!!=====================================================================
        # 过  程  名： dis_reset_port
        # 函数说明： 端口解复位
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-28
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = 0x10310ab4
        retcode, old_value = self.get_reg_value(addr)
        tmp_value = int(old_value, 16) & 0xfffffff0
        new_value = tmp_value + 1 << mac
        retcode, retstr = self.set_reg_value(addr, new_value)
        return retcode, retstr

    # 流控
    # tx on  rx on  0x3
    # tx on  rx off 0x7
    # tx off rx on  0x2
    # tx off rx off 0x6
    def set_txrx_pause_enable(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_txrx_pause_enable
        # 函数说明： 设置tx和rx流控使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x160
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffff8
        set_value = value_tmp + 0x3
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_txrx_pause_disable(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_txrx_pause_disable
        # 函数说明： 设置tx和rx流控去使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2021-03-09
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x160
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffff8
        set_value = value_tmp + 0x6
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_tx_pause_enable(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_pause_enable
        # 函数说明： 设置tx流控单独使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x160
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffff8
        set_value = value_tmp + 0x7
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_rx_pause_enable(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_pause_enable
        # 函数说明： 设置rx流控单独使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x160
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffff8
        set_value = value_tmp + 0x2
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_force_pause_enable(self, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_force_pause_enable
        # 函数说明： 强制设置port反压
        # 参数说明：mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-24
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = 0x10820338 + 0x100000 * mac
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffffe
        set_value = value_tmp + enable * 0x1
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def get_tx_pause_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_pause_mib
        # 函数说明： 统计tx方向流控帧
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_pause_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xce4 + base_addr, 0xce0 + base_addr]
        retcode, tx_pause_h = self.get_reg_value(addr_liter[0])
        retcode, tx_pause_l = self.get_reg_value(addr_liter[1])
        tx_pause_mib = (int(tx_pause_l, 16)) + (int(tx_pause_h, 16)) * 0x100000000
        return retcode, tx_pause_mib

    def get_rx_pause_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_pause_mib
        # 函数说明： 统计rx方向流控帧
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_pause_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xe44 + base_addr, 0xe40 + base_addr]
        retcode, rx_pause_h = self.get_reg_value(addr_liter[0])
        retcode, rx_pause_l = self.get_reg_value(addr_liter[1])
        rx_pause_mib = (int(rx_pause_l, 16)) + (int(rx_pause_h, 16)) * 0x100000000
        return retcode, rx_pause_mib

    def set_tx_truncate(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_truncate
        # 函数说明： 设置tx方向截断使能
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        #           enable:是否使能（1：使能  0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffffffdf
        set_value = value_tmp + enable * 0x20
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_rx_truncate(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_truncate
        # 函数说明： 设置rx方向截断使能
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        #           enable:是否使能（1：使能  0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffdfffff
        set_value = value_tmp + enable * 0x200000
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_tx_under_min_err_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_under_min_err_en
        # 函数说明： 设置rx方向超短帧标错使能
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        #           enable:是否使能（1：使能  0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffffffef
        set_value = value_tmp + enable * 0x10
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_rx_under_min_err_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_under_min_err_en
        # 函数说明： 设置rx方向超短帧报警使能
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        #           enable:是否使能（1：使能  0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffefffff
        set_value = value_tmp + enable * 0x100000
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_pma_status(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_pma_status
        # 函数说明： 设置PMA的状态使能
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x700
        retcode, retstr = self.set_reg_value(addr, enable)
        return retcode, retstr

    def set_tx_bit_reverse(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_bit_reverse
        # 函数说明： 设置tx mib翻转
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x704
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffffffef
        set_value = value_tmp + enable * 0x10
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_rx_bit_reverse(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_bit_reverse
        # 函数说明： 设置rx mib翻转
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x704
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffffffdf
        set_value = value_tmp + enable * 0x20
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def get_tx_unicase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_unicase_mib
        # 函数说明： 获取tx方向单播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_unicase_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xccc + base_addr, 0xcc8 + base_addr]
        retcode, tx_unicase_h = self.get_reg_value(addr_liter[0])
        retcode, tx_unicase_l = self.get_reg_value(addr_liter[1])
        tx_unicase_mib = int(tx_unicase_l, 16) + int(tx_unicase_h, 16) * 0x100000000
        return retcode, tx_unicase_mib

    def get_tx_multicase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_multicase_mib
        # 函数说明： 获取tx方向组播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_multicase_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcd4 + base_addr, 0xcd0 + base_addr]
        retcode, tx_multicase_h = self.get_reg_value(addr_liter[0])
        retcode, tx_multicase_l = self.get_reg_value(addr_liter[1])
        tx_multicase_mib = int(tx_multicase_l, 16) + int(tx_multicase_h, 16) * 0x100000000
        return retcode, tx_multicase_mib

    def get_tx_broadcase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_broadcase_mib
        # 函数说明： 获取tx方向广播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_broadcase_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcdc + base_addr, 0xcd8 + base_addr]
        retcode, tx_broadcase_h = self.get_reg_value(addr_liter[0])
        retcode, tx_broadcase_l = self.get_reg_value(addr_liter[1])
        tx_broadcase_mib = int(tx_broadcase_l, 16) + int(tx_broadcase_h, 16) * 0x100000000
        return retcode, tx_broadcase_mib

    def get_tx_fragment_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_fragment_mib
        # 函数说明： 获取tx方向fragment报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_fragment_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x004 + base_addr, 0x000 + base_addr]
        retcode, tx_fragment_h = self.get_reg_value(addr_liter[0])
        retcode, tx_fragment_l = self.get_reg_value(addr_liter[1])
        tx_fragment_mib = int(tx_fragment_l, 16) + int(tx_fragment_h, 16) * 0x100000000
        return retcode, tx_fragment_mib

    def get_tx_under_size_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_under_size_mib
        # 函数说明： 获取tx方向undersize报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_under_size_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x00c + base_addr, 0x008 + base_addr]
        retcode, tx_under_size_h = self.get_reg_value(addr_liter[0])
        retcode, tx_under_size_l = self.get_reg_value(addr_liter[1])
        tx_under_size_mib = int(tx_under_size_l, 16) + int(tx_under_size_h, 16) * 0x100000000
        return retcode, tx_under_size_mib

    def get_tx_under_min_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_under_min_mib
        # 函数说明： 获取tx方向超短帧报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-13
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_under_min_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x014 + base_addr, 0x010 + base_addr]
        retcode, tx_under_min_h = self.get_reg_value(addr_liter[0])
        retcode, tx_under_min_l = self.get_reg_value(addr_liter[1])
        tx_under_min_mib = int(tx_under_min_l, 16) + int(tx_under_min_h, 16) * 0x100000000
        return retcode, tx_under_min_mib

    def get_tx_over_size_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_over_size_mib
        # 函数说明： 获取tx方向超长帧报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_over_size_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc8c + base_addr, 0xc88 + base_addr]
        retcode, tx_over_size_h = self.get_reg_value(addr_liter[0])
        retcode, tx_over_size_l = self.get_reg_value(addr_liter[1])
        tx_over_size_mib = int(tx_over_size_l, 16) + int(tx_over_size_h, 16) * 0x100000000
        return retcode, tx_over_size_mib

    def get_tx_jabber_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_jabber_mib
        # 函数说明： 获取tx方向jabber报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_jabber_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc94 + base_addr, 0xc90 + base_addr]
        retcode, tx_jabber_h = self.get_reg_value(addr_liter[0])
        retcode, tx_jabber_l = self.get_reg_value(addr_liter[1])
        tx_jabber_mib = int(tx_jabber_l, 16) + int(tx_jabber_h, 16) * 0x100000000
        return retcode, tx_jabber_mib

    def get_tx_totaloctets_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_totaloctets_mib
        # 函数说明： 获取tx方向总字节数
        # 参数说明：  unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_totaloctets_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcc4 + base_addr, 0xcc0 + base_addr]
        retcode, tx_totaloctets_h = self.get_reg_value(addr_liter[0])
        retcode, tx_totaloctets_l = self.get_reg_value(addr_liter[1])
        tx_totaloctets_mib = int(tx_totaloctets_l, 16) + int(tx_totaloctets_h, 16) * 0x100000000
        return retcode, tx_totaloctets_mib

    def get_rx_unicase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_unicase_mib
        # 函数说明： 获取rx方向单播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_unicase_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x22c + base_addr, 0x228 + base_addr]
        retcode, rx_unicase_h = self.get_reg_value(addr_liter[0])
        retcode, rx_unicase_l = self.get_reg_value(addr_liter[1])
        rx_unicase_mib = int(rx_unicase_l, 16) + int(rx_unicase_h, 16) * 0x100000000
        return retcode, rx_unicase_mib

    def get_rx_multicase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_multicase_mib
        # 函数说明： 获取rx方向组播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_multicase_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x234 + base_addr, 0x230 + base_addr]
        retcode, rx_multicase_h = self.get_reg_value(addr_liter[0])
        retcode, rx_multicase_l = self.get_reg_value(addr_liter[1])
        rx_multicase_mib = int(rx_multicase_l, 16) + int(rx_multicase_h, 16) * 0x100000000
        return retcode, rx_multicase_mib

    def get_rx_broadcase_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_broadcase_mib
        # 函数说明： 获取rx方向广播报文数
        # 参数说明： unimac:验证板unimac号
        #           mac:验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_broadcase_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x23c + base_addr, 0x238 + base_addr]
        retcode, rx_broadcase_h = self.get_reg_value(addr_liter[0])
        retcode, rx_broadcase_l = self.get_reg_value(addr_liter[1])
        rx_broadcase_mib = int(rx_broadcase_l, 16) + int(rx_broadcase_h, 16) * 0x100000000
        return retcode, rx_broadcase_mib

    def get_rx_fragment_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_fragment_mib
        # 函数说明： 获取rx方向fragment报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_fragment_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x164 + base_addr, 0x160 + base_addr]
        retcode, rx_fragment_h = self.get_reg_value(addr_liter[0])
        retcode, rx_fragment_l = self.get_reg_value(addr_liter[1])
        rx_fragment_mib = int(rx_fragment_l, 16) + int(rx_fragment_h, 16) * 0x100000000
        return retcode, rx_fragment_mib

    def get_rx_under_size_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_under_size_mib
        # 函数说明： 获取rx方向fragment报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_under_size_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x16c + base_addr, 0x168 + base_addr]
        retcode, rx_under_size_h = self.get_reg_value(addr_liter[0])
        retcode, rx_under_size_l = self.get_reg_value(addr_liter[1])
        rx_under_size_mib = int(rx_under_size_l, 16) + int(rx_under_size_h, 16) * 0x100000000
        return retcode, rx_under_size_mib

    def get_rx_under_min_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_under_min_mib
        # 函数说明： 获取rx方向超短帧报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_under_min_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x174 + base_addr, 0x170 + base_addr]
        retcode, rx_under_min_h = self.get_reg_value(addr_liter[0])
        retcode, rx_under_min_l = self.get_reg_value(addr_liter[1])
        rx_under_min_mib = int(rx_under_min_l, 16) + int(rx_under_min_h, 16) * 0x100000000
        return retcode, rx_under_min_mib

    def get_rx_over_size_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_over_size_mib
        # 函数说明： 获取rx方向超长帧报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_over_size_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1ec + base_addr, 0x1e8 + base_addr]
        retcode, rx_over_size_h = self.get_reg_value(addr_liter[0])
        retcode, rx_over_size_l = self.get_reg_value(addr_liter[1])
        rx_over_size_mib = int(rx_over_size_l, 16) + int(rx_over_size_h, 16) * 0x100000000
        return retcode, rx_over_size_mib

    def get_rx_jabber_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_over_size_mib
        # 函数说明： 获取rx方向jabber报文数
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_jabber_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1f4 + base_addr, 0x1f0 + base_addr]
        retcode, rx_jabber_h = self.get_reg_value(addr_liter[0])
        retcode, rx_jabber_l = self.get_reg_value(addr_liter[1])
        rx_jabber_mib = int(rx_jabber_l, 16) + int(rx_jabber_h, 16) * 0x100000000
        return retcode, rx_jabber_mib

    def get_rx_totaloctets_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_totaloctets_mib
        # 函数说明： 获取rx方向总字节数
        # 参数说明：  unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_totaloctets_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x224 + base_addr, 0x220 + base_addr]
        retcode, rx_totaloctets_h = self.get_reg_value(addr_liter[0])
        retcode, rx_totaloctets_l = self.get_reg_value(addr_liter[1])
        rx_totaloctets_mib = int(rx_totaloctets_l, 16) + int(rx_totaloctets_h, 16) * 0x100000000
        return retcode, rx_totaloctets_mib

    def get_tx_64_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_64_mib
        # 函数说明： 获取tx方向64字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_64_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc1c + base_addr, 0xc18 + base_addr]
        retcode, tx_64_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_64_mib_l = self.get_reg_value(addr_liter[1])
        tx_64_mib = int(tx_64_mib_l, 16) + int(tx_64_mib_h, 16) * 0x100000000
        return retcode, tx_64_mib

    def get_tx_65to127_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_65to127_mib
        # 函数说明： 获取tx方向65to127字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_65to127_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc24 + base_addr, 0xc20 + base_addr]
        retcode, tx_65to127_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_65to127_mib_l = self.get_reg_value(addr_liter[1])
        tx_65to127_mib = int(tx_65to127_mib_l, 16) + int(tx_65to127_mib_h, 16) * 0x100000000
        return retcode, tx_65to127_mib

    def get_tx_128to255_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_128to255_mib
        # 函数说明： 获取tx方向128to255字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_128to255_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc2c + base_addr, 0xc28 + base_addr]
        retcode, tx_128to255_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_128to255_mib_l = self.get_reg_value(addr_liter[1])
        tx_128to255_mib = int(tx_128to255_mib_l, 16) + int(tx_128to255_mib_h, 16) * 0x100000000
        return retcode, tx_128to255_mib

    def get_tx_256to511_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_256to511_mib
        # 函数说明： 获取tx方向256to511字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_256to511_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc34 + base_addr, 0xc30 + base_addr]
        retcode, tx_256to511_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_256to511_mib_l = self.get_reg_value(addr_liter[1])
        tx_256to511_mib = int(tx_256to511_mib_l, 16) + int(tx_256to511_mib_h, 16) * 0x100000000
        return retcode, tx_256to511_mib

    def get_tx_512to1023_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_512to1023_mib
        # 函数说明： 获取tx方向512to1023字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_512to1023_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc3c + base_addr, 0xc38 + base_addr]
        retcode, tx_512to1023_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_512to1023_mib_l = self.get_reg_value(addr_liter[1])
        tx_512to1023_mib = int(tx_512to1023_mib_l, 16) + int(tx_512to1023_mib_h, 16) * 0x100000000
        return retcode, tx_512to1023_mib

    def get_tx_1024to1518_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_1024to1518_mib
        # 函数说明： 获取tx方向1024to1518字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_1024to1518_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc44 + base_addr, 0xc40 + base_addr]
        retcode, tx_1024to1518_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_1024to1518_mib_l = self.get_reg_value(addr_liter[1])
        tx_1024to1518_mib = int(tx_1024to1518_mib_l, 16) + int(tx_1024to1518_mib_h, 16) * 0x100000000
        return retcode, tx_1024to1518_mib

    def get_tx_1519to2047_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_1519to2047_mib
        # 函数说明： 获取tx方向1519to2047字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_1519to2047_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc4c + base_addr, 0xc48 + base_addr]
        retcode, tx_1519to2047_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_1519to2047_mib_l = self.get_reg_value(addr_liter[1])
        tx_1519to2047_mib = int(tx_1519to2047_mib_l, 16) + int(tx_1519to2047_mib_h, 16) * 0x100000000
        return retcode, tx_1519to2047_mib

    def get_tx_2048to4095_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_2048to4095_mib
        # 函数说明： 获取tx方向2048to4095字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_2048to4095_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc54 + base_addr, 0xc50 + base_addr]
        retcode, tx_2048to4095_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_2048to4095_mib_l = self.get_reg_value(addr_liter[1])
        tx_2048to4095_mib = int(tx_2048to4095_mib_l, 16) + int(tx_2048to4095_mib_h, 16) * 0x100000000
        return retcode, tx_2048to4095_mib

    def get_tx_4096to8191_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_4096to8191_mib
        # 函数说明： 获取tx方向4096to8191字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_4096to8191_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc5c + base_addr, 0xc58 + base_addr]
        retcode, tx_4096to8191_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_4096to8191_mib_l = self.get_reg_value(addr_liter[1])
        tx_4096to8191_mib = int(tx_4096to8191_mib_l, 16) + int(tx_4096to8191_mib_h, 16) * 0x100000000
        return retcode, tx_4096to8191_mib

    def get_tx_8192to9216_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_8192to9216_mib
        # 函数说明： 获取tx方向8192to9216字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_8192to9216_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc64 + base_addr, 0xc60 + base_addr]
        retcode, tx_8192to9216_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_8192to9216_mib_l = self.get_reg_value(addr_liter[1])
        tx_8192to9216_mib = int(tx_8192to9216_mib_l, 16) + int(tx_8192to9216_mib_h, 16) * 0x100000000
        return retcode, tx_8192to9216_mib

    def get_tx_9217to12287_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_9217to12287_mib
        # 函数说明： 获取tx方向9217to12287字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_9217to12287_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc6c + base_addr, 0xc68 + base_addr]
        retcode, tx_9217to12287_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_9217to12287_mib_l = self.get_reg_value(addr_liter[1])
        tx_9217to12287_mib = int(tx_9217to12287_mib_l, 16) + int(tx_9217to12287_mib_h, 16) * 0x100000000
        return retcode, tx_9217to12287_mib

    def get_tx_12288to16383_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_12288to16383_mib
        # 函数说明： 获取tx方向12288to16383字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_12288to16383_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc74 + base_addr, 0xc70 + base_addr]
        retcode, tx_12288to16383_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_12288to16383_mib_l = self.get_reg_value(addr_liter[1])
        tx_12288to16383_mib = int(tx_12288to16383_mib_l, 16) + int(tx_12288to16383_mib_h, 16) * 0x100000000
        return retcode, tx_12288to16383_mib

    def get_tx_1519tomax_bad_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_1519tomax_bad_mib
        # 函数说明： 获取tx方向1519tomax字节bad报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_1519tomax_bad_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc7c + base_addr, 0xc78 + base_addr]
        retcode, tx_1519tomax_bad_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_1519tomax_bad_mib_l = self.get_reg_value(addr_liter[1])
        tx_1519tomax_bad_mib = int(tx_1519tomax_bad_mib_l, 16) + int(tx_1519tomax_bad_mib_h, 16) * 0x100000000
        return retcode, tx_1519tomax_bad_mib

    def get_tx_1519tomax_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_1519tomax_mib
        # 函数说明： 获取tx方向1519tomax字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_1519tomax_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xc84 + base_addr, 0xc80 + base_addr]
        retcode, tx_1519tomax_mib_h = self.get_reg_value(addr_liter[0])
        retcode, tx_1519tomax_mib_l = self.get_reg_value(addr_liter[1])
        tx_1519tomax_mib = int(tx_1519tomax_mib_l, 16) + int(tx_1519tomax_mib_h, 16) * 0x100000000
        return retcode, tx_1519tomax_mib

    def get_rx_64_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_64_mib
        # 函数说明： 获取rx方向64字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_64_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x17c + base_addr, 0x178 + base_addr]
        retcode, rx_64_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_64_mib_l = self.get_reg_value(addr_liter[1])
        rx_64_mib = int(rx_64_mib_l, 16) + int(rx_64_mib_h, 16) * 0x100000000
        return retcode, rx_64_mib

    def get_rx_65to127_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_65to127_mib
        # 函数说明： 获取rx方向65to127字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_65to127_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x184 + base_addr, 0x180 + base_addr]
        retcode, rx_65to127_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_65to127_mib_l = self.get_reg_value(addr_liter[1])
        rx_65to127_mib = int(rx_65to127_mib_l, 16) + int(rx_65to127_mib_h, 16) * 0x100000000
        return retcode, rx_65to127_mib

    def get_rx_128to255_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_128to255_mib
        # 函数说明： 获取rx方向128to255字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_128to255_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x18c + base_addr, 0x188 + base_addr]
        retcode, rx_128to255_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_128to255_mib_l = self.get_reg_value(addr_liter[1])
        rx_128to255_mib = int(rx_128to255_mib_l, 16) + int(rx_128to255_mib_h, 16) * 0x100000000
        return retcode, rx_128to255_mib

    def get_rx_256to511_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_256to511_mib
        # 函数说明： 获取rx方向256to511字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_256to511_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x194 + base_addr, 0x190 + base_addr]
        retcode, rx_256to511_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_256to511_mib_l = self.get_reg_value(addr_liter[1])
        rx_256to511_mib = int(rx_256to511_mib_l, 16) + int(rx_256to511_mib_h, 16) * 0x100000000
        return retcode, rx_256to511_mib

    def get_rx_512to1023_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_512to1023_mib
        # 函数说明： 获取rx方向512to1023字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_512to1023_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x19c + base_addr, 0x198 + base_addr]
        retcode, rx_512to1023_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_512to1023_mib_l = self.get_reg_value(addr_liter[1])
        rx_512to1023_mib = int(rx_512to1023_mib_l, 16) + int(rx_512to1023_mib_h, 16) * 0x100000000
        return retcode, rx_512to1023_mib

    def get_rx_1024to1518_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_512to1023_mib
        # 函数说明： 获取rx方向512to1023字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_1024to1518_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1a4 + base_addr, 0x1a0 + base_addr]
        retcode, rx_1024to1518_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_1024to1518_mib_l = self.get_reg_value(addr_liter[1])
        rx_1024to1518_mib = int(rx_1024to1518_mib_l, 16) + int(rx_1024to1518_mib_h, 16) * 0x100000000
        return retcode, rx_1024to1518_mib

    def get_rx_1519to2047_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_512to1023_mib
        # 函数说明： 获取rx方向512to1023字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_1519to2047_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1ac + base_addr, 0x1a8 + base_addr]
        retcode, rx_1519to2047_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_1519to2047_mib_l = self.get_reg_value(addr_liter[1])
        rx_1519to2047_mib = int(rx_1519to2047_mib_l, 16) + int(rx_1519to2047_mib_h, 16) * 0x100000000
        return retcode, rx_1519to2047_mib

    def get_rx_2048to4095_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_512to1023_mib
        # 函数说明： 获取rx方向512to1023字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_2048to4095_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1b4 + base_addr, 0x1b0 + base_addr]
        retcode, rx_2048to4095_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_2048to4095_mib_l = self.get_reg_value(addr_liter[1])
        rx_2048to4095_mib = int(rx_2048to4095_mib_l, 16) + int(rx_2048to4095_mib_h, 16) * 0x100000000
        return retcode, rx_2048to4095_mib

    def get_rx_4096to8191_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_4096to8191_mib
        # 函数说明： 获取rx方向4096to8191字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_4096to8191_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1bc + base_addr, 0x1b8 + base_addr]
        retcode, rx_4096to8191_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_4096to8191_mib_l = self.get_reg_value(addr_liter[1])
        rx_4096to8191_mib = int(rx_4096to8191_mib_l, 16) + int(rx_4096to8191_mib_h, 16) * 0x100000000
        return retcode, rx_4096to8191_mib

    def get_rx_8192to9216_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_8192to9216_mib
        # 函数说明： 获取rx方向8192to9216字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_8192to9216_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1c4 + base_addr, 0x1c0 + base_addr]
        retcode, rx_8192to9216_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_8192to9216_mib_l = self.get_reg_value(addr_liter[1])
        rx_8192to9216_mib = int(rx_8192to9216_mib_l, 16) + int(rx_8192to9216_mib_h, 16) * 0x100000000
        return retcode, rx_8192to9216_mib

    def get_rx_9217to12287_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_9217to12287_mib
        # 函数说明： 获取rx方向9217to12287字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_9217to12287_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1cc + base_addr, 0x1c8 + base_addr]
        retcode, rx_9217to12287_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_9217to12287_mib_l = self.get_reg_value(addr_liter[1])
        rx_9217to12287_mib = int(rx_9217to12287_mib_l, 16) + int(rx_9217to12287_mib_h, 16) * 0x100000000
        return retcode, rx_9217to12287_mib

    def get_rx_12288to16383_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_12288to16383_mib
        # 函数说明： 获取rx方向12288to16383字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_12288to16383_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1d4 + base_addr, 0x1d0 + base_addr]
        retcode, rx_12288to16383_mib_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_12288to16383_mib_mib_l = self.get_reg_value(addr_liter[1])
        rx_12288to16383_mib = int(rx_12288to16383_mib_mib_l, 16) + int(rx_12288to16383_mib_mib_h, 16) * 0x100000000
        return retcode, rx_12288to16383_mib

    def get_rx_1519tomax_bad_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_1519tomax_bad_mib
        # 函数说明： 获取rx方向1519tomax字节bad报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_1519tomax_bad_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1dc + base_addr, 0x1d8 + base_addr]
        retcode, rx_1519tomax_bad_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_1519tomax_bad_mib_l = self.get_reg_value(addr_liter[1])
        rx_1519tomax_bad_mib = int(rx_1519tomax_bad_mib_l, 16) + int(rx_1519tomax_bad_mib_h, 16) * 0x100000000
        return retcode, rx_1519tomax_bad_mib

    def get_rx_1519tomax_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_1519tomax_mib
        # 函数说明： 获取rx方向1519tomax字节报文数
        # 参数说明： unimac:验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_1519tomax_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xc00
        addr_liter = [0x1e4 + base_addr, 0x1e0 + base_addr]
        retcode, rx_1519tomax_mib_h = self.get_reg_value(addr_liter[0])
        retcode, rx_1519tomax_mib_l = self.get_reg_value(addr_liter[1])
        rx_1519tomax_mib = int(rx_1519tomax_mib_l, 16) + int(rx_1519tomax_mib_h, 16) * 0x100000000
        return retcode, rx_1519tomax_mib

    def set_rx_fcs_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_fcs_en
        # 函数说明： rx方向FCS校验使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffeffff
        set_value = value_tmp + enable * 0x10000
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_rx_fcs_strip_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_rx_fcs_strip_en
        # 函数说明： rx方向FCS剥离使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffdffff
        set_value = value_tmp + enable * 0x20000
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_tx_fcs_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_fcs_en
        # 函数说明： tx方向FCS添加使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retcode = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffffe
        set_value = value_tmp + enable * 0x1
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def get_rx_fcs_err_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_fcs_err_mib
        # 函数说明： 获取rx方向带fcs 错误的mib统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_fec_err_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xeac + base_addr, 0xea8 + base_addr]
        retcode, rx_fec_err_h = self.get_reg_value(addr_liter[0])
        retcode, rx_fec_err_l = self.get_reg_value(addr_liter[1])
        rx_fec_err_mib = int(rx_fec_err_l, 16) + int(rx_fec_err_h, 16) * 0x100000000
        return retcode, rx_fec_err_mib

    def get_tx_from_app_good_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_from_app_good_mib
        # 函数说明： 获取tx方向from app good报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_from_app_good_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xd54 + base_addr, 0xd50 + base_addr]
        retcode, tx_from_app_good_h = self.get_reg_value(addr_liter[0])
        retcode, tx_from_app_good_l = self.get_reg_value(addr_liter[1])
        tx_from_app_good_mib = int(tx_from_app_good_l, 16) + int(tx_from_app_good_h, 16) * 0x100000000
        return retcode, tx_from_app_good_mib

    def get_tx_from_app_bad_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_from_app_bad_mib
        # 函数说明： 获取tx方向from app bad报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_from_app_bad_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xd5c + base_addr, 0xd58 + base_addr]
        retcode, tx_from_app_bad_h = self.get_reg_value(addr_liter[0])
        retcode, tx_from_app_bad_l = self.get_reg_value(addr_liter[1])
        tx_from_app_bad_mib = int(tx_from_app_bad_l, 16) + int(tx_from_app_bad_h, 16) * 0x100000000
        return retcode, tx_from_app_bad_mib

    def get_rx_send_app_good_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_send_app_good_mib
        # 函数说明： 获取rx方向send app good报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_send_app_good_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xebc + base_addr, 0xeb8 + base_addr]
        retcode, rx_send_app_good_h = self.get_reg_value(addr_liter[0])
        retcode, rx_send_app_good_l = self.get_reg_value(addr_liter[1])
        rx_send_app_good_mib = int(rx_send_app_good_l, 16) + int(rx_send_app_good_h, 16) * 0x100000000
        return retcode, rx_send_app_good_mib

    def get_rx_send_app_bad_mib(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_send_app_bad_mib
        # 函数说明： 获取rx方向send app bad报文统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        rx_send_app_bad_mib = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xec4 + base_addr, 0xec0 + base_addr]
        retcode, rx_send_app_bad_h = self.get_reg_value(addr_liter[0])
        retcode, rx_send_app_bad_l = self.get_reg_value(addr_liter[1])
        rx_send_app_bad_mib = int(rx_send_app_bad_l, 16) + int(rx_send_app_bad_h, 16) * 0x100000000
        return retcode, rx_send_app_bad_mib

    def set_mib_read_clean(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_mib_read_clean
        # 函数说明： 设置读清使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能(1：使能；2：去使能)
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x194
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xffffffef
        set_value = value_tmp + enable * 0x10
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def clean_mib(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： clean_mib
        # 函数说明： 设置清除报文使能
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x194
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffffe
        set_value = value_tmp + enable * 0x1
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_tx_padding_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_tx_padding_en
        # 函数说明： 设置tx方向padding使能
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffffd
        set_value = value_tmp + enable * 0x2
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def set_min_padding_size(self, unimac, mac, value):
        """
        #!!=====================================================================
        # 过  程  名： set_min_padding_size
        # 函数说明： 设置最小帧
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        #           value：设置最小帧的值
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        min_size_addr = self.make_addr(unimac, mac) + 0x124
        retcode, retstr = self.set_reg_value(min_size_addr, value)
        return retcode, retstr

    def get_total_tx_pkt(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_total_tx_pkt
        # 函数说明： 获取总发包数
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_pkt = None
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcbc + base_addr, 0xcb8 + base_addr]
        retcode, tx_pkt_h = self.get_reg_value(addr_liter[0])
        retcode, tx_pkt_l = self.get_reg_value(addr_liter[1])
        tx_pkt = int(tx_pkt_l, 16) + int(tx_pkt_h, 16) * 0x100000000
        return retcode, tx_pkt

    def set_mac_pfc_en(self, unimac, mac, enable):
        """
        #!!=====================================================================
        # 过  程  名： set_mac_pfc_en
        # 函数说明： 设置pfc使能
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           enable：是否使能（1：使能；0：去使能）
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""
        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfffffeff
        set_value = value_tmp + (enable * 0x100)
        retcode, retstr = self.set_reg_value(addr, set_value)

        addr = self.make_addr(unimac, mac) + 0x104
        retcode, value = self.get_reg_value(addr)
        value_tmp = (int(value, 16)) & 0xfbfffbff
        set_value = value_tmp + (enable * 0x4000400)
        retcode, retstr = self.set_reg_value(addr, set_value)
        return retcode, retstr

    def get_tx_priority_mib(self, unimac, mac, priority):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_priority_mib
        # 函数说明： 获取tx方向各个priority的pfc帧数
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           priority：pfc优先级通道号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_priority_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xcf0 + 0x8 * priority
        retcode, retstr_temp = self.get_reg_value(base_addr)
        tx_priority_mib = int(retstr_temp, 16)
        return retcode, tx_priority_mib

    def get_rx_priority_mib(self, unimac, mac, priority):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_priority_mib
        # 函数说明： 获取rx方向各个priority的pfc帧数
        # 参数说明： unimac：验证板unimac号
        #           mac：验证板mac号
        #           priority：pfc优先级通道号
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              -1 结果不正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        tx_priority_mib = None
        base_addr = self.make_addr(unimac, mac) + 0xe50 + 0x8 * priority
        retcode, retstr_temp = self.get_reg_value(base_addr)
        tx_priority_mib = int(retstr_temp, 16)
        return retcode, tx_priority_mib

    def get_tx_pfc_pkt(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_tx_pfc_pkt
        # 函数说明：
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xcec + base_addr, 0xce8 + base_addr]
        retcode, tx_pfc_pkt_h = self.get_reg_value(addr_liter[0])
        retcode, tx_pfc_pkt_l = self.get_reg_value(addr_liter[1])
        tx_pfc_pkt = int(tx_pfc_pkt_l, 16) + int(tx_pfc_pkt_h, 16) * 0x100000000
        return retcode, tx_pfc_pkt

    def get_rx_pfc_pkt(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： get_rx_pfc_pkt
        # 函数说明：
        # 参数说明：
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串f
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        base_addr = self.make_addr(unimac, mac)
        addr_liter = [0xe4c + base_addr, 0xe48 + base_addr]
        retcode, tx_pfc_pkt_h = self.get_reg_value(addr_liter[0])
        retcode, tx_pfc_pkt_l = self.get_reg_value(addr_liter[1])
        rx_pfc_pkt = int(tx_pfc_pkt_l, 16) + int(tx_pfc_pkt_h, 16) * 0x100000000
        return retcode, rx_pfc_pkt

    def clear_telnet_buffer(self):
        """
        #!!=====================================================================
        # 过  程  名：clear_telnet_buffer
        # 函数说明： 清除科思云串口交换机缓存问题
        # 参数说明：无
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        #
        # 
        # 生成时间： 2017-06-06
        # 修改纪录：
        #!!=====================================================================
        """
        retcode = -1
        retstr = self.up.send_command_one_by_one("", "#", 10)
        if retstr.endswith("#"):
            retcode = 0
        return retcode, retstr

    def set_device_speed_full(self, dev, speed, autoneg="off", duplex="full"):
        """
        #!!=====================================================================
        # 过  程  名：set_device_autoneg_state
        # 函数说明：配置设备的自协商状态、速率、双工模式
        # 参数说明：dev：设备的名字，比如 eth0, eth5
        #          speed: 网口速率
        #          autoneg: 自协商状态，比如on,off;
        #          duplex: 双工模式，比如full,half;
        # 返  回  值: (错误码，命令执行结果)
        #          错误码：
        #                 0 结果正确
        #                 1 没有设备输入（ No device has been input）
        #                 2 没有设备(No such device)
        #                 4 没有权限 (Permission denied)
        #                 5 命令错误 (bad command)
        #                 999 新的错误
        #           命令执行结果： 正确时为值，失败时返回命令行的所有结果
        # 注意事项：无
        # 使用实例：cmd_ethtool.set_device_autoneg_state("eth7",10000,"on")
        # 对应命令：ethtool -s eth7 autoneg off speed 10000 duplex full
        # 作          者：xwx468995
        # 生成时间：  2019-01-26
        # 修改纪录：
        #!!=====================================================================
        """
        # 1. retcode初始化赋值-1,判断dev是否传入为空串
        retcode = -1

        if dev == "":
            retcode = 1
            retstr = "No device has been input!"
            return retcode, retstr

        # 2.封装命令
        cmd = r"ethtool -s %s autoneg %s speed %s duplex %s" % (dev, autoneg, speed, duplex)

        # 3.发送命令到终端，取回返回值处理
        retstr = self.up.send_command_one_by_one(cmd, "#", 5, INTERVALS)

        # 4.判断结果中是否含有错误，如果发现直接打印错误码和错误结果
        if "No such device" in retstr:
            retcode = 2
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d ： 没有设备输入(No such device)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)

        elif "Permission denied" in retstr:
            retcode = 4
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 没有权限  (Permission denied)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)

        elif "bad command" in retstr:
            retcode = 5
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 命令错误 (bad command)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)

        elif "command not found" in retstr:
            retcode = 10
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : undefined error", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s", retstr)

        elif "#" in retstr:
            retcode = 0
            time.sleep(1)
            return retcode, retstr
        else:
            retcode = 999
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%d : %s",
                        retcode, retstr)

        # 5.返回结果： retcode和返回值retstr
        return retcode, retstr

    # ========================================= mib check below ===============================================
    def mib_check(self, unimac, mac):
        """
        #!!=====================================================================
        # 过  程  名： mib_check
        # 函数说明： 打印各类mib统计
        # 参数说明：unimac：验证板unimac号
        #           mac：验证板mac号
        # 返  回  值：mib非0统计
        # 注意事项：无
        #
        # 
        # 生成时间： 2020-08-27
        # 修改纪录：
        #!!=====================================================================
        """
        mib = ""

        tx_good, tx_total, tx_bad = self.get_tx_mib(unimac, mac)[1]
        tx_oct = self.get_tx_totaloctets_mib(unimac, mac)[1]
        tx_uni = self.get_tx_unicase_mib(unimac, mac)[1]
        tx_multi = self.get_tx_multicase_mib(unimac, mac)[1]
        tx_broad = self.get_tx_broadcase_mib(unimac, mac)[1]
        tx_pause = self.get_tx_pause_mib(unimac, mac)[1]
        tx_64 = self.get_tx_64_mib(unimac, mac)[1]
        tx_65_127 = self.get_tx_65to127_mib(unimac, mac)[1]
        tx_128_255 = self.get_tx_128to255_mib(unimac, mac)[1]
        tx_255_511 = self.get_tx_256to511_mib(unimac, mac)[1]
        tx_512_1023 = self.get_tx_512to1023_mib(unimac, mac)[1]
        tx_1024_1518 = self.get_tx_1024to1518_mib(unimac, mac)[1]
        tx_1519_2047 = self.get_tx_1519to2047_mib(unimac, mac)[1]
        tx_2048_4095 = self.get_tx_2048to4095_mib(unimac, mac)[1]
        tx_4096_8191 = self.get_tx_4096to8191_mib(unimac, mac)[1]
        tx_8192_8216 = self.get_tx_8192to9216_mib(unimac, mac)[1]
        tx_9217_12287 = self.get_tx_9217to12287_mib(unimac, mac)[1]
        tx_12288_16383 = self.get_tx_12288to16383_mib(unimac, mac)[1]
        tx_1519_max_good = self.get_tx_1519tomax_mib(unimac, mac)[1]
        tx_1519_max_bad = self.get_tx_1519tomax_bad_mib(unimac, mac)[1]
        tx_fragment = self.get_tx_fragment_mib(unimac, mac)[1]
        tx_undersize = self.get_tx_under_size_mib(unimac, mac)[1]
        tx_undermin = self.get_tx_under_min_mib(unimac, mac)[1]
        tx_oversize = self.get_tx_over_size_mib(unimac, mac)[1]
        tx_jabber = self.get_tx_jabber_mib(unimac, mac)[1]
        tx_from_app_good = self.get_tx_from_app_good_mib(unimac, mac)[1]
        tx_from_app_bad = self.get_tx_from_app_bad_mib(unimac, mac)[1]

        rx_good, rx_total, rx_bad = self.get_rx_mib(unimac, mac)[1]
        rx_oct = self.get_rx_totaloctets_mib(unimac, mac)[1]
        rx_uni = self.get_rx_unicase_mib(unimac, mac)[1]
        rx_multi = self.get_rx_multicase_mib(unimac, mac)[1]
        rx_broad = self.get_rx_broadcase_mib(unimac, mac)[1]
        rx_pause = self.get_rx_pause_mib(unimac, mac)[1]
        rx_64 = self.get_rx_64_mib(unimac, mac)[1]
        rx_65_127 = self.get_rx_65to127_mib(unimac, mac)[1]
        rx_128_255 = self.get_rx_128to255_mib(unimac, mac)[1]
        rx_255_511 = self.get_rx_256to511_mib(unimac, mac)[1]
        rx_512_1023 = self.get_rx_512to1023_mib(unimac, mac)[1]
        rx_1024_1518 = self.get_rx_1024to1518_mib(unimac, mac)[1]
        rx_1519_2047 = self.get_rx_1519to2047_mib(unimac, mac)[1]
        rx_2048_4095 = self.get_rx_2048to4095_mib(unimac, mac)[1]
        rx_4096_8191 = self.get_rx_4096to8191_mib(unimac, mac)[1]
        rx_8192_8216 = self.get_rx_8192to9216_mib(unimac, mac)[1]
        rx_9217_12287 = self.get_rx_9217to12287_mib(unimac, mac)[1]
        rx_12288_16383 = self.get_rx_12288to16383_mib(unimac, mac)[1]
        rx_1519_max_good = self.get_rx_1519tomax_mib(unimac, mac)[1]
        rx_1519_max_bad = self.get_rx_1519tomax_bad_mib(unimac, mac)[1]
        rx_fragment = self.get_rx_fragment_mib(unimac, mac)[1]
        rx_undersize = self.get_rx_under_size_mib(unimac, mac)[1]
        rx_undermin = self.get_rx_under_min_mib(unimac, mac)[1]
        rx_oversize = self.get_rx_over_size_mib(unimac, mac)[1]
        rx_jabber = self.get_rx_jabber_mib(unimac, mac)[1]
        rx_fcs_err = self.get_rx_fcs_err_mib(unimac, mac)[1]
        rx_send_app_good = self.get_rx_send_app_good_mib(unimac, mac)[1]
        rx_send_app_bad = self.get_rx_send_app_bad_mib(unimac, mac)[1]

        mib += self._add_mib("[TX total PKTS]", tx_total)
        mib += self._add_mib("[TX good PKTS]", tx_good)
        mib += self._add_mib("[TX bad PKTS]", tx_bad)
        mib += self._add_mib("[TX total OCTS]", tx_oct)
        mib += self._add_mib("[TX unicase PKTS]", tx_uni)
        mib += self._add_mib("[TX multicase PKTS]", tx_multi)
        mib += self._add_mib("[TX broadcase PKTS]", tx_broad)
        mib += self._add_mib("[TX pause PKTS]", tx_pause)
        mib += self._add_mib("[TX 64 PKTS]", tx_64)
        mib += self._add_mib("[TX 65-127 PKTS]", tx_65_127)
        mib += self._add_mib("[TX 128-255 PKTS]", tx_128_255)
        mib += self._add_mib("[TX 256-511 PKTS]", tx_255_511)
        mib += self._add_mib("[TX 512-1023 PKTS]", tx_512_1023)
        mib += self._add_mib("[TX 1024-1518 PKTS]", tx_1024_1518)
        mib += self._add_mib("[TX 1519-2047 PKTS]", tx_1519_2047)
        mib += self._add_mib("[TX 2048-4095 PKTS]", tx_2048_4095)
        mib += self._add_mib("[TX 4096-8191 PKTS]", tx_4096_8191)
        mib += self._add_mib("[TX 8192-9216 PKTS]", tx_8192_8216)
        mib += self._add_mib("[TX 9217-12287 PKTS]", tx_9217_12287)
        mib += self._add_mib("[TX 12288-16383 PKTS]", tx_12288_16383)
        mib += self._add_mib("[TX 1519_max_good PKTS]", tx_1519_max_good)
        mib += self._add_mib("[TX 1519_max_bad PKTS]", tx_1519_max_bad)
        mib += self._add_mib("[TX fragment PKTS]", tx_fragment)
        mib += self._add_mib("[TX undersize PKTS]", tx_undersize)
        mib += self._add_mib("[TX undermin PKTS]", tx_undermin)
        mib += self._add_mib("[TX oversize PKTS]", tx_oversize)
        mib += self._add_mib("[TX jabber PKTS]", tx_jabber)
        mib += self._add_mib("[TX from_app_good PKTS]", tx_from_app_good)
        mib += self._add_mib("[TX from_app_bad PKTS]", tx_from_app_bad)

        mib += self._add_mib("[RX total PKTS]", rx_total)
        mib += self._add_mib("[RX good PKTS]", rx_good)
        mib += self._add_mib("[RX bad PKTS]", rx_bad)
        mib += self._add_mib("[RX total OCTS]", rx_oct)
        mib += self._add_mib("[RX unicase PKTS]", rx_uni)
        mib += self._add_mib("[RX multicase PKTS]", rx_multi)
        mib += self._add_mib("[RX broadcase PKTS]", rx_broad)
        mib += self._add_mib("[RX pause PKTS]", rx_pause)
        mib += self._add_mib("[RX 64 PKTS]", rx_64)
        mib += self._add_mib("[RX 65-127 PKTS]", rx_65_127)
        mib += self._add_mib("[RX 128-255 PKTS]", rx_128_255)
        mib += self._add_mib("[RX 256-511 PKTS]", rx_255_511)
        mib += self._add_mib("[RX 512-1023 PKTS]", rx_512_1023)
        mib += self._add_mib("[RX 1024-1518 PKTS]", rx_1024_1518)
        mib += self._add_mib("[RX 1519-2047 PKTS]", rx_1519_2047)
        mib += self._add_mib("[RX 2048-4095 PKTS]", rx_2048_4095)
        mib += self._add_mib("[RX 4096-8191 PKTS]", rx_4096_8191)
        mib += self._add_mib("[RX 8192-9216 PKTS]", rx_8192_8216)
        mib += self._add_mib("[RX 9217-12287 PKTS]", rx_9217_12287)
        mib += self._add_mib("[RX 12288-16383 PKTS]", rx_12288_16383)
        mib += self._add_mib("[RX 1519_max_good PKTS]", rx_1519_max_good)
        mib += self._add_mib("[RX 1519_max_bad PKTS]", rx_1519_max_bad)
        mib += self._add_mib("[RX fragment PKTS]", rx_fragment)
        mib += self._add_mib("[RX undersize PKTS]", rx_undersize)
        mib += self._add_mib("[RX undermin PKTS]", rx_undermin)
        mib += self._add_mib("[RX oversize PKTS]", rx_oversize)
        mib += self._add_mib("[RX jabber PKTS]", rx_jabber)
        mib += self._add_mib("[RX fcs_err PKTS]", rx_fcs_err)
        mib += self._add_mib("[RX send_app_good PKTS]", rx_send_app_good)
        mib += self._add_mib("[RX send_app_bad PKTS]", rx_send_app_bad)

        return mib.strip("\n")

    @classmethod
    def _add_mib(cls, info, pkt):
        """
        #!!=====================================================================
        # 过  程  名： _add_mib
        # 函数说明： 过滤掉为0的统计项
        # 参数说明：info：说明信息
        #          pkt：报文数量
        # 返  回  值：pkt
        # 注意事项：内部调用
        #
        # 
        # 生成时间： 2020-07-27
        # 修改纪录：
        #!!=====================================================================
        """
        if pkt == 0:
            return ""
        else:
            return "%s: %s\n" % (info, pkt)

    # ========================================= mib check above ===============================================

    # ========================================= iperf below ===============================================
    def iperf_server(self, udp=False, background=True):
        """
        #!!=====================================================================
        # 过  程  名： iperf_server
        # 函数说明： 建立iperf服务端
        # 参数说明：udp：是否是udp模式
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 没有可执行权限;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        # 使用实例：terminal.iperf_run(True)
        # 对应命令：iperf -s -u &
        # 
        # 生成时间： 2020-08-25
        # 修改纪录：
        #!!=====================================================================
        """
        # 1. retcode初始化赋值-1
        retcode = -1
        retstr = ""

        # 2.封装命令
        cmd = "iperf -s"
        if udp:
            cmd += " -u"
        if background:
            cmd += " &"

        # 3.发送命令到终端，取回返回值处理
        retstr = self.up.send_command_one_by_one(cmd, "#", 5, INTERVALS)

        # 4.判断结果中是否含有错误，如果发现直接打印错误码和错误结果
        if "No such device" in retstr:
            retcode = 2
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d ： 没有设备输入(No such device)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "Permission denied" in retstr:
            retcode = 4
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 没有权限  (Permission denied)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "bad command" in retstr:
            retcode = 5
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 命令错误 (bad command)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "command not found" in retstr:
            retcode = 10
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : undefined error", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "#" in retstr:
            retcode = 0
            time.sleep(1)
            return retcode, retstr
        else:
            retcode = 999
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%d : %s",
                        retcode, retstr)

        # 5.返回结果： retcode和返回值retstr
        return retcode, retstr

    def iperf_run(self, ip, time_t, bandwidth=None, udp=False, background=True):
        """
        #!!=====================================================================
        # 过  程  名： iperf_server
        # 函数说明： 建立iperf客户端
        # 参数说明：udp：是否是udp模式
        # 返  回  值：(错误码，命令执行结果)
        #        错误码：
        #              0 结果正确;
        #              1 没有可执行权限;
        #        命令执行结果： 命令行执行和terminal中的输出字符串
        # 注意事项：无
        # 使用实例：terminal.iperf_run("20.20.20.11", )
        # 对应命令：iperf -c 20.20.20.11 -t 10 -b 100M -u &
        # 
        # 生成时间： 2020-08-25
        # 修改纪录：
        #!!=====================================================================
        """
        # 1. retcode初始化赋值-1
        retcode = -1
        retstr = ""

        # 2.封装命令
        cmd = "iperf -c %s -t %s" % (ip, time_t)
        if bandwidth:
            cmd += " -b %s" % bandwidth
        if udp:
            cmd += " -u"
        if background:
            cmd += " &"

        # 3.发送命令到终端，取回返回值处理
        retstr = self.up.send_command_one_by_one(cmd, "#", 5, INTERVALS)

        # 4.判断结果中是否含有错误，如果发现直接打印错误码和错误结果
        if "No such device" in retstr:
            retcode = 2
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d ： 没有设备输入(No such device)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "Permission denied" in retstr:
            retcode = 4
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 没有权限  (Permission denied)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "bad command" in retstr:
            retcode = 5
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : 命令错误 (bad command)", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "command not found" in retstr:
            retcode = 10
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name,
                        "%d : undefined error", retcode)
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%s",
                        retstr)

        elif "#" in retstr:
            retcode = 0
            time.sleep(1)
            return retcode, retstr
        else:
            retcode = 999
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "%d : %s",
                        retcode, retstr)

        # 5.返回结果： retcode和返回值retstr
        return retcode, retstr

    def iperf_kill(self):
        """
        #!!=====================================================================
        # 过  程  名： iperf_kill
        # 函数说明： 杀死iperf进程
        # 参数说明：无
        # 返  回  值：无
        # 注意事项：
        # 使用实例：terminal.iperf_kill()
        # 对应命令：killall -9 iperf
        #
        # 
        # 生成时间： 2020-08-25
        #!!=====================================================================
        """
        retcode = -1
        retstr = ""

        cmd = "killall -9 iperf"
        retstr = self.up.send_command_one_by_one(cmd, "#", 10, INTERVALS)
        time.sleep(2)
        retstr = self.up.send_command_one_by_one(cmd, "#", 10, INTERVALS)
        if "iperf: no process found" in retstr or "iperf: no process killed" in retstr:
            retcode = 0
        else:
            retcode = 1
            log_message(LOG_LEVEL_WARNING, self.__class__.__name__ + "|" + sys._getframe().f_code.co_name, "未知错误")
        return retcode, retstr

    # ========================================= iperf above ===============================================

    def set_rx_waterline(self, dev, high):
        """
        #!!=====================================================================
        # 过  程  名：set_rx_waterline
        # 函数说明：设置水线
        # 参数说明：dev：设备的名字，比如 eth0, eth5
        #          high: 是否为高水线
        # 返  回  值: (错误码，命令执行结果)
        #          错误码：
        #                 0 结果正确
        #                 1 结果错误
        #           命令执行结果： 正确时为值，失败时返回命令行的所有结果
        # 注意事项：无
        # 使用实例：terminal.set_rx_waterline("eth1", 0)
        # 对应命令：hikptooltest qos -i eth1 -s rx_buff_threshold -TC 0x1 -H 0x2 -L 0x1
        # 作          者：xwx468995
        # 生成时间：  2021-03-10
        # 修改纪录：
        #!!=====================================================================
        """
        # 1. retcode初始化赋值-1,判断dev是否传入为空串
        retcode = -1
        retstr = ""

        if dev == "":
            retcode = 1
            retstr = "No device has been input!"
            return retcode, retstr

        # 2.封装命令
        threshold_h = 0x2
        threshold_l = 0x1
        wl_h = 0x2
        wl_l = 0x1

        if high:
            threshold_h = 0x0
            threshold_l = 0x0
            wl_h = 0x506
            wl_l = 0x4d6

        cmds = ["hikptooltest qos -i {} -s rx_buff_threshold -TC 0x1 -H {} -L {}".format(
            dev, threshold_h, threshold_l),
            "hikptooltest qos -i {} -s rx_priv_buff_wl -TC 0x1 -H {} -L {}".format(dev, wl_h, wl_l)]

        # 3.发送命令到终端，取回返回值处理
        for cmd in cmds:
            retstr += self.up.send_command_one_by_one(cmd, "#", 5, INTERVALS)

        # 4.判断结果中是否含有错误，如果发现直接打印错误码和错误结果
        if len(re.findall(self.succ, retstr)) >= 1:
            retcode = 0

        # 5.返回结果： retcode和返回值retstr
        return retcode, retstr
