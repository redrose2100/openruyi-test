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


from feature_lib.hns_lib import hns_common as comm


def set_arfs(iface: str, terminal="server", enable=True):
    """
    功能描述: 使能arfs
    参数说明:
        :param iface    网口名
        :param ternimal 终端类型
        :param enable   是否使能
    修改时间: 2021/07/08 16:15:43
    作    者: lwx567203
    """
    handler = comm.get_terminal_handler(terminal)
    command, entries, cnt = "", 0, 0
    if enable is True:
        command += "service irqbalance stop; "
        command += "ethtool -K {} ntuple on; ".format(iface)
        entries, cnt = 32768, 2048

    command += "echo {} > /proc/sys/net/core/rps_sock_flow_entries; ".format(entries)
    command += "echo {} > /sys/class/net/{}/queues/rx-0/rps_flow_cnt; ".format(cnt, iface)
    command += "echo {} > /sys/class/net/{}/queues/rx-1/rps_flow_cnt; ".format(cnt, iface)
    command += "echo {} > /sys/class/net/{}/queues/rx-2/rps_flow_cnt; ".format(cnt, iface)
    command += "echo {} > /sys/class/net/{}/queues/rx-3/rps_flow_cnt; ".format(cnt, iface)
    handler.send_command(command)

