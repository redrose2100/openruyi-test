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


import itertools
import json
import os
import re
import time

import IPy
import xlrd
import xlwt
from common_lib.base_lib.base_config import FAILURE_CODE, SUCCESS_CODE
from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_utils import check_result
from xlutils.copy import copy

from feature_lib.hns_lib import hns_common as comm
from feature_lib.hns_lib import hns_config_ethtool
from test_config.feature_config.hns_config.hns_config import global_param as ssh

ROOTDIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))


def __save_info__(terminal, command, logfile):
    """
    =====================================================================
    函数说明: 保存信息到文件
    修改时间: 2022/01/13 16:54:17
    作    者: lwx567203
    =====================================================================
    """
    handler = comm.get_terminal_handler(terminal)
    handler.send_command(command)
    with open(f"{engine_global.project.base_dir_path}/{logfile}", "w") as f_desc:
        f_desc.write(handler.information)


def __save_bw_info__(logfile, msg):
    """
    =====================================================================
    函数说明: 保存信息到文件
    修改时间: 2022/01/13 16:54:17
    作    者: ywx925178
    =====================================================================
    """
    with open(f"{engine_global.project.base_dir_path}/{logfile}", "a", encoding='utf-8') as f_desc:
        f_desc.write(msg)


def save_board_info():
    """
    =====================================================================
    函数说明: 保存单板的信息
    修改时间: 2022/01/14 14:40:22
    作    者: lwx567203
    =====================================================================
    """
    for terminal in ["server", "client"]:
        __save_info__(terminal, "free -g", f"{terminal}_memory.log")
        __save_info__(terminal, "lscpu", f"{terminal}_cpus.log")
        __save_info__(terminal, "dmidecode -t memory | grep -i speed", f"{terminal}_bios_memory.log")


def iperf_get_bw(log_path, terminal="server"):
    """
    =====================================================================
    函数说明: 获取iperf冲包网口带宽数据
    修改时间: 2023/05/19 16:34:57
    作    者: ywx925178
    =====================================================================
    """
    bw_msg = comm.exec_command(terminal=terminal, command=f"cat {log_path}")
    return re.findall("MBytes\\s+(.*)\\sMbits/sec", bw_msg)


class Performance():
    """
    测试性能基类，其他测试性能模块从此类继承并增加自有属性和方法
    """

    def __init__(self, s_iface, c_iface):
        self.s_iface = s_iface
        self.c_iface = c_iface
        self.bdf = hns_config_ethtool.get_iface_bdf(s_iface)
        if self.bdf == FAILURE_CODE:
            check_result(FAILURE_CODE, SUCCESS_CODE, fail_str='此网口不存在BDF')
        self.s_cpus = 1
        self.c_cpus = 1


    def select_interrupt_id_cpu(self):
        """
        =====================================================================
        函数说明: 此函数返回需要绑定的核
        修改时间: 2022/01/14 16:35:26
        作    者: lwx567203
        =====================================================================
        """
        self.s_cpus, self.c_cpus = comm.interrupt_cpu_continue(self.s_iface, self.c_iface)


    def iperf_tcp_performance(self, local_ip, remote_ip, threads, num='', flags='tx', seconds=30):
        """
        =====================================================================
        函数说明: 此函数用作iperf测试网口tcp 大包收包或者发包性能
        修改时间: 2022/01/14 16:34:57
        作    者: lwx567203
        =====================================================================
        """
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        direct = {"rx": "tx", "tx": "rx"}.get(flags, "rx")
        server_log = f"{path}_server_{self.s_iface}_{num}_{flags}.log"
        client_log = f"{path}_client_{self.c_iface}_{num}_{direct}.log"
        other_args = "-f m"
        if IPy.IP(local_ip).version() == 6:
            other_args = "-V -f m"
        if flags == 'tx':
            s_cpus, s_log, s_type = self.c_cpus, client_log, "client"
            host, c_cpus, c_log, c_type = remote_ip, self.s_cpus, server_log, "server"
        else:
            s_cpus, s_log, s_type = self.s_cpus, server_log, "server"
            host, c_cpus, c_log, c_type = local_ip, self.c_cpus, client_log, "client"

        comm.iperf(mode="-s", other=other_args, cpus=s_cpus, output=s_log, terminal=s_type)
        time.sleep(3)
        other_args = f"{other_args} -P {threads} -t {seconds}"
        run_cnt, s_total_bw, c_total_bw = 3, 0, 0
        for _ in range(run_cnt):
            comm.iperf(mode="-c", host=host, other=other_args, cpus=c_cpus, output=c_log, terminal=c_type)
            comm.wait_process_finish("iperf", terminal=c_type)
            time.sleep(3)

            # 查看带宽数据
            handler = comm.get_terminal_handler("server")
            handler.send_command(f"tail -n 1 {server_log} | awk '{{printf $(NF-1)}}'")
            s_total_bw += float(handler.information.strip())
            handler = comm.get_terminal_handler("client")
            handler.send_command(f"tail -n 1 {client_log} | awk '{{printf $(NF-1)}}'")
            c_total_bw += float(handler.information.strip())
        server_bw, client_bw = s_total_bw / run_cnt, c_total_bw / run_cnt
        msg_center.info(f"测试本端{flags}性能为{server_bw}M/s, 测试对端{direct}性能为{client_bw}M/s")
        return server_bw, client_bw


    def iperf_tcp_performance_two_port(self, local_ip, remote_ip, threads, num='', flags='tx', seconds=30, **kwargs):
        """
        =====================================================================
        函数说明: 此函数用作iperf双端口测试网口tcp 大包收包或者发包性能
        修改时间: 2022/01/14 16:34:57
        作    者: ywx925178
        =====================================================================
        """
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        direct = {"rx": "tx", "tx": "rx"}.get(flags, "rx")
        server_log = f"{path}_server_{self.s_iface}_{num}_{flags}.log"
        client_log = f"{path}_client_{self.c_iface}_{num}_{direct}.log"
        other_args = "-f m"
        if IPy.IP(local_ip).version() == 6:
            other_args = "-V -f m"
        local_ip2 = kwargs.get("local_ip2", None)
        remote_ip2 = kwargs.get("remote_ip2", None)
        if local_ip2 is None and remote_ip2 is None:
            msg_center.error("双端口冲包，第二个冲包IP未输入！")
            return FAILURE_CODE
        else:
            server_log2 = f"{path}_server2_{self.s_iface}_{num}_{flags}.log"
            client_log2 = f"{path}_client2_{self.c_iface}_{num}_{direct}.log"
        if flags == 'tx':
            s_cpus, s_log, s_type = self.c_cpus, client_log, "client"
            s_cpus, s_log2, s_type = self.c_cpus, client_log2, "client"
            host, c_cpus, c_log, c_type = remote_ip, self.s_cpus, server_log, "server"
            host2, c_cpus, c_log2, c_type = remote_ip2, self.s_cpus, server_log2, "server"
        else:
            s_cpus, s_log, s_type = self.s_cpus, server_log, "server"
            s_cpus, s_log2, s_type = self.s_cpus, server_log2, "server"
            host, c_cpus, c_log, c_type = local_ip, self.c_cpus, client_log, "client"
            host2, c_cpus, c_log2, c_type = local_ip2, self.c_cpus, client_log2, "client"

        comm.iperf(mode="-s", other=f"{other_args} -p 5001", cpus=s_cpus, output=s_log, terminal=s_type)
        comm.iperf(mode="-s", other=f"{other_args} -p 5002", cpus=s_cpus, output=s_log2, terminal=s_type)
        time.sleep(3)
        other_args = f"{other_args} -P {threads} -t {seconds}"
        run_cnt, s_total_bw, s_total_bw2, c_total_bw, c_total_bw2 = 3, 0, 0, 0, 0
        for _ in range(run_cnt):
            comm.iperf(mode="-c", host=host, other=f"{other_args} -p 5001", cpus=c_cpus, output=c_log, terminal=c_type)
            comm.iperf(mode="-c", host=host2, other=f"{other_args} -p 5002", cpus=c_cpus, output=c_log2,
                       terminal=c_type)
            comm.wait_process_finish("iperf", terminal=c_type)
            time.sleep(3)

            # 查看带宽数据
            handler = comm.get_terminal_handler("server")
            handler.send_command(f"tail -n 1 {server_log} | awk '{{printf $(NF-1)}}'")
            s_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {server_log2} | awk '{{printf $(NF-1)}}'")
            s_total_bw2 += float(handler.information.strip())

            handler = comm.get_terminal_handler("client")
            handler.send_command(f"tail -n 1 {client_log} | awk '{{printf $(NF-1)}}'")
            c_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {client_log2} | awk '{{printf $(NF-1)}}'")
            c_total_bw2 += float(handler.information.strip())
        server_bw, client_bw = s_total_bw / run_cnt, c_total_bw / run_cnt
        server_bw2, client_bw2 = s_total_bw2 / run_cnt, c_total_bw2 / run_cnt
        msg_center.info(f"测试本端网口1{flags}性能为{server_bw}M/s, 测试对端网口1{direct}性能为{client_bw}M/s")
        msg_center.info(f"测试本端网口2{flags}性能为{server_bw2}M/s, 测试对端网口2{direct}性能为{client_bw2}M/s")
        return server_bw, client_bw, server_bw2, client_bw2


    def iperf_tcp_performance_bidir(self, local_ip, remote_ip, threads, num='', seconds=30):
        """
        =====================================================================
        函数说明: 此函数用作iperf测试网口tcp 双向收发包性能
        修改时间: 2022/01/14 16:34:57
        作    者: ywx925178
        =====================================================================
        """
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        server_tx_log = f"{path}_server_{self.s_iface}_{num}_tx.log"
        server_rx_log = f"{path}_server_{self.s_iface}_{num}_rx.log"
        client_tx_log = f"{path}_client_{self.c_iface}_{num}_tx.log"
        client_rx_log = f"{path}_client_{self.c_iface}_{num}_rx.log"
        other_s_args = "-f m -p 5001"
        other_c_args = "-f m -p 5002"
        if IPy.IP(local_ip).version() == 6:
            other_s_args = f"-V {other_s_args}"
            other_c_args = f"-V {other_c_args}"

        comm.iperf(mode="-s", other=other_s_args, cpus=self.c_cpus, output=server_rx_log, terminal="server")
        comm.iperf(mode="-s", other=other_c_args, cpus=self.c_cpus, output=client_rx_log, terminal="client")
        time.sleep(3)
        other_ss_args = f"{other_c_args} -P {threads} -t {seconds}"
        other_cc_args = f"{other_s_args} -P {threads} -t {seconds}"
        run_cnt, s_tx_total_bw, s_rx_total_bw, c_tx_total_bw, c_rx_total_bw = 3, 0, 0, 0, 0
        for _ in range(run_cnt):
            comm.iperf(mode="-c", host=remote_ip, other=other_ss_args, cpus=self.c_cpus, output=server_tx_log,
                       terminal="server")
            comm.iperf(mode="-c", host=local_ip, other=other_cc_args, cpus=self.c_cpus, output=client_tx_log,
                       terminal="client")
            comm.wait_process_finish("iperf -c", terminal="server")
            comm.wait_process_finish("iperf -c", terminal="client")
            time.sleep(3)

            # 查看带宽数据
            handler = comm.get_terminal_handler("server")
            handler.send_command(f"tail -n 1 {server_tx_log} | awk '{{printf $(NF-1)}}'")
            s_tx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {server_rx_log} | awk '{{printf $(NF-1)}}'")
            s_rx_total_bw += float(handler.information.strip())
            handler = comm.get_terminal_handler("client")
            handler.send_command(f"tail -n 1 {client_tx_log} | awk '{{printf $(NF-1)}}'")
            c_tx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {client_rx_log} | awk '{{printf $(NF-1)}}'")
            c_rx_total_bw += float(handler.information.strip())
        server_tx_bw, server_rx_bw = s_tx_total_bw / run_cnt, s_rx_total_bw / run_cnt,
        client_tx_bw, client_rx_bw = c_tx_total_bw / run_cnt, c_rx_total_bw / run_cnt
        msg_center.info(f"测试本端tx性能为{server_tx_bw}M/s, 测试本端rx性能为{server_rx_bw}M/s")
        msg_center.info(f"测试对端tx性能为{client_tx_bw}M/s, 测试对端rx性能为{client_rx_bw}M/s")
        return server_tx_bw, server_rx_bw, client_tx_bw, client_rx_bw


    def iperf_tcp_performance_bidir_two_port(self, local_ip, remote_ip, threads, num='', seconds=30, **kwargs):
        """
        =====================================================================
        函数说明: 此函数用作iperf双端口测试网口tcp 双向收发包性能
        修改时间: 2022/01/14 16:34:57
        作    者: ywx925178
        =====================================================================
        """
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        server_tx_log = f"{path}_server_{self.s_iface}_{num}_tx.log"
        server_tx_log2 = f"{path}_server_{self.s_iface}_{num}_tx2.log"
        server_rx_log = f"{path}_server_{self.s_iface}_{num}_rx.log"
        server_rx_log2 = f"{path}_server_{self.s_iface}_{num}_rx2.log"
        client_tx_log = f"{path}_client_{self.c_iface}_{num}_tx.log"
        client_tx_log2 = f"{path}_client_{self.c_iface}_{num}_tx2.log"
        client_rx_log = f"{path}_client_{self.c_iface}_{num}_rx.log"
        client_rx_log2 = f"{path}_client_{self.c_iface}_{num}_rx2.log"
        other_s_args = "-f m -p 5001"
        other_s_args2 = "-f m -p 5002"
        other_c_args = "-f m -p 5003"
        other_c_args2 = "-f m -p 5004"
        if IPy.IP(local_ip).version() == 6:
            other_s_args = f"-V {other_s_args}"
            other_s_args2 = f"-V {other_s_args2}"
            other_c_args = f"-V {other_c_args}"
            other_c_args2 = f"-V {other_c_args2}"

        comm.iperf(mode="-s", other=other_s_args, cpus=self.c_cpus, output=server_rx_log, terminal="server")
        comm.iperf(mode="-s", other=other_s_args2, cpus=self.c_cpus, output=server_rx_log2, terminal="server")
        comm.iperf(mode="-s", other=other_c_args, cpus=self.c_cpus, output=client_rx_log, terminal="client")
        comm.iperf(mode="-s", other=other_c_args2, cpus=self.c_cpus, output=client_rx_log2, terminal="client")
        time.sleep(3)
        other_ss_args = f"{other_c_args} -P {threads} -t {seconds}"
        other_ss_args2 = f"{other_c_args2} -P {threads} -t {seconds}"
        other_cc_args = f"{other_s_args} -P {threads} -t {seconds}"
        other_cc_args2 = f"{other_s_args2} -P {threads} -t {seconds}"
        run_cnt, s_tx_total_bw, s_rx_total_bw, c_tx_total_bw, c_rx_total_bw = 3, 0, 0, 0, 0
        s_tx_total_bw2, s_rx_total_bw2, c_tx_total_bw2, c_rx_total_bw2 = 0, 0, 0, 0
        local_ip2 = kwargs.get("local_ip2", None)
        remote_ip2 = kwargs.get("remote_ip2", None)
        if local_ip2 is None and remote_ip2 is None:
            msg_center.error("双端口冲包，第二个冲包IP未输入！")
            return FAILURE_CODE
        for _ in range(run_cnt):
            comm.iperf(mode="-c", host=remote_ip, other=other_ss_args, cpus=self.c_cpus, output=server_tx_log,
                       terminal="server")
            comm.iperf(mode="-c", host=remote_ip2, other=other_ss_args2, cpus=self.c_cpus, output=server_tx_log2,
                       terminal="server")
            comm.iperf(mode="-c", host=local_ip, other=other_cc_args, cpus=self.c_cpus, output=client_tx_log,
                       terminal="client")
            comm.iperf(mode="-c", host=local_ip2, other=other_cc_args2, cpus=self.c_cpus, output=client_tx_log2,
                       terminal="client")
            comm.wait_process_finish("iperf -c", terminal="server")
            comm.wait_process_finish("iperf -c", terminal="client")
            time.sleep(3)

            # 查看带宽数据
            handler = comm.get_terminal_handler("server")
            handler.send_command(f"tail -n 1 {server_tx_log} | awk '{{printf $(NF-1)}}'")
            s_tx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {server_tx_log2} | awk '{{printf $(NF-1)}}'")
            s_tx_total_bw2 += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {server_rx_log} | awk '{{printf $(NF-1)}}'")
            s_rx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {server_rx_log2} | awk '{{printf $(NF-1)}}'")
            s_rx_total_bw2 += float(handler.information.strip())

            handler = comm.get_terminal_handler("client")
            handler.send_command(f"tail -n 1 {client_tx_log} | awk '{{printf $(NF-1)}}'")
            c_tx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {client_tx_log2} | awk '{{printf $(NF-1)}}'")
            c_tx_total_bw2 += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {client_rx_log} | awk '{{printf $(NF-1)}}'")
            c_rx_total_bw += float(handler.information.strip())
            handler.send_command(f"tail -n 1 {client_rx_log2} | awk '{{printf $(NF-1)}}'")
            c_rx_total_bw2 += float(handler.information.strip())
        server_tx_bw, server_rx_bw = s_tx_total_bw / run_cnt, s_rx_total_bw / run_cnt,
        server_tx_bw2, server_rx_bw2 = s_tx_total_bw2 / run_cnt, s_rx_total_bw2 / run_cnt,
        client_tx_bw, client_rx_bw = c_tx_total_bw / run_cnt, c_rx_total_bw / run_cnt
        client_tx_bw2, client_rx_bw2 = c_tx_total_bw2 / run_cnt, c_rx_total_bw2 / run_cnt
        msg_center.info(f"测试本端端口1tx性能为{server_tx_bw}M/s, 测试本端端口1rx性能为{server_rx_bw}M/s")
        msg_center.info(f"测试对端端口1tx性能为{client_tx_bw}M/s, 测试对端端口1rx性能为{client_rx_bw}M/s")
        msg_center.info(f"测试本端端口2tx性能为{server_tx_bw2}M/s, 测试本端端口2rx性能为{server_rx_bw2}M/s")
        msg_center.info(f"测试对端端口2tx性能为{client_tx_bw2}M/s, 测试对端端口2rx性能为{client_rx_bw2}M/s")
        return server_tx_bw, server_rx_bw, client_tx_bw, client_rx_bw, \
            server_tx_bw2, server_rx_bw2, client_tx_bw2, client_rx_bw2


    def iperf_tcp_stability(self, iperf_ip, threads, seconds):
        """
        =====================================================================
        函数说明: 此函数用作iperf测试网口tcp流量稳定性，中间是否有中断或者偏低现象
        修改时间: 2022/01/14 16:34:57
        作    者: lwx567203
        =====================================================================
        """
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        server_log = f"{path}_server_{self.s_iface}_server.log"
        client_log = f"{path}_client_{self.c_iface}_client.log"
        other_args = "-f m -i 1"
        if IPy.IP(iperf_ip).version() == 6:
            other_args = "-V -f m -i 1"
        s_cpus, s_log, s_type = self.s_cpus, server_log, "server"
        host, c_cpus, c_log, c_type = iperf_ip, self.c_cpus, client_log, "client"

        comm.iperf(mode="-s", other=other_args, cpus=s_cpus, output=s_log, terminal=s_type)
        time.sleep(3)
        other_args = f"{other_args} -P {threads} -t {seconds}"
        comm.iperf(mode="-c", host=host, other=other_args, cpus=c_cpus, output=c_log, terminal=c_type)
        time.sleep(seconds)
        comm.wait_process_finish("iperf", terminal=c_type)
        time.sleep(3)

        # 查看带宽数据
        if threads > 1:
            server_cmd = f"grep 'SUM' {server_log}| awk '{{print $(NF-1)}}'"
            client_cmd = f"grep 'SUM' {client_log}| awk '{{print $(NF-1)}}'"
        else:
            server_cmd = f"sed -n '/Bandwidth/,$p' {server_log}|grep -v 'Bandwidth'|awk '{{print $(NF-1)}}'"
            client_cmd = f"sed -n '/Bandwidth/,$p' {client_log}|grep -v 'Bandwidth'|awk '{{print $(NF-1)}}'"
        handler = comm.get_terminal_handler("server")
        handler.send_command(server_cmd)
        s_total_bw = handler.information.strip().split('\n')
        s_total_bw = [float(x) for x in s_total_bw]
        handler = comm.get_terminal_handler("client")
        handler.send_command(client_cmd)
        c_total_bw = handler.information.strip().split('\n')
        c_total_bw = [float(x) for x in c_total_bw]
        comm.kill_process('iperf', terminal="server")
        comm.kill_process('iperf', terminal="client")
        msg_center.info(f"测试本端性能为{s_total_bw[-1]}M/s, 测试对端性能为{c_total_bw[-1]}M/s")
        for bw_list in [s_total_bw, c_total_bw]:
            bw_abnormal_times = 0
            for index, bw_item in enumerate(bw_list[:-1]):
                if bw_item < bw_list[-1] * 0.1:
                    msg_center.warning(f"第{index}秒，带宽偏离平均值比较大，请检查！")
                    return FAILURE_CODE
                if not bw_list[-1] * 0.5 < bw_item < bw_list[-1] * 1.5:
                    msg_center.warning(f"第{index}秒，带宽偏离平均值比较大，请检查！")
                    bw_abnormal_times += 1
            if bw_abnormal_times > 3:
                msg_center.warning("异常带宽数值出现超过3次，请检查！")
                return FAILURE_CODE
        return SUCCESS_CODE


    @staticmethod
    def __start_netperf__(terminal="server", host="127.0.0.1", port=12865, **kwargs):
        """
        =====================================================================
        函数说明: 根据参数启动netperf进程
        :param NA
        函数返回: None
        应用举例: NA
        修改时间: 2022/01/17 11:51:47
        作    者: lwx567203
        =====================================================================
        """
        seconds = kwargs.get("seconds", 3000)
        protos = kwargs.get("proto", ["UDP"])
        if isinstance(protos, str):
            protos = [protos]
        sizes = kwargs.get("size", [None])
        if not isinstance(sizes, list):
            sizes = [sizes]
        itertor = itertools.product(protos, sizes)
        for protol, size in itertor:
            kwargs.update(dict(protol=protol, size=size, seconds=seconds))
            comm.start_netperf(terminal=terminal, host=host, port=port, **kwargs)


    def netperf_performance(self, local_ip, remote_ip, threads, **kwargs):
        """
        =====================================================================
        函数说明: 此函数用作netperf测试网口UDP收包发包性能，tcp发包性能
        修改时间: 2022/01/14 16:35:56
        作    者: lwx567203
        =====================================================================
        """
        for terminal in ("server", "client"):
            comm.kill_process('netserver', terminal=terminal)
            comm.kill_process('netperf', terminal=terminal)

        direct = kwargs.get("direct", "rx")
        number = kwargs.get("number", 0)
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        if direct == 'tx':
            server, client, host_ip, s_cpus, index = "client", "server", remote_ip, self.c_cpus, 6
            logfile = f"{path}_netperf_{self.s_iface}_{number}.log"
            kwargs.update(dict(cpus=self.s_cpus, output=logfile))
        else:
            server, client, host_ip, s_cpus, index = "server", "client", local_ip, self.s_cpus, 5
            logfile = f"{path}_netperf_{self.c_iface}_{number}.log"
            kwargs.update(dict(cpus=self.c_cpus, output=logfile))

        port = comm.start_netserver(terminal=server, cpus=s_cpus)
        time.sleep(2)
        run_cnt, total_bw = 3, 0
        for idx in range(run_cnt):
            for _ in range(threads):
                self.__start_netperf__(terminal=client, host=host_ip, port=port, **kwargs)
            time.sleep(2)
            handler = comm.get_terminal_handler("server")
            sar_log = f"{path}_server_sar_{self.s_iface}_{number}_{direct}_{idx}.log"
            handler.send_command(f"sar -n DEV 1 30 > '{sar_log}' 2>&1")
            comm.wait_process_finish("sar", terminal=client)
            comm.kill_process('netperf', terminal=client)
            handler.send_command(f"cat {sar_log} | grep Average |grep {self.s_iface} | awk '{{printf ${index}}}'")
            total_bw += float(handler.information.strip())
        comm.kill_process('netserver', terminal=server)
        server_bw = total_bw / run_cnt
        msg_center.info(f"测试server端{direct}方向{run_cnt}次平均性能为{server_bw}")
        return server_bw


    def netperf_performance_two_port(self, local_ip1, remote_ip1, local_ip2, remote_ip2, **kwargs):
        """
        =====================================================================
        函数说明: 此函数用作netperf测试网口UDP发包性能，双端口
        修改时间: 2022/01/14 16:35:56
        作    者: ywx925178
        =====================================================================
        """
        for terminal in ("server", "client"):
            comm.kill_process('netserver', terminal=terminal)
            comm.kill_process('netperf', terminal=terminal)

        number = kwargs.get("number", 0)
        s_iface1 = kwargs.get("local_net1", None)
        s_iface2 = kwargs.get("local_net2", None)
        c_iface1 = kwargs.get("remote_net1", None)
        c_iface2 = kwargs.get("remote_net2", None)
        path = f"{engine_global.project.base_dir_path}/{engine_global.pytest.case_name}"
        port1 = comm.start_netserver(terminal="server", cpus=self.s_cpus)
        port2 = comm.start_netserver(terminal="server", cpus=self.s_cpus)
        port3 = comm.start_netserver(terminal="client", cpus=self.c_cpus)
        port4 = comm.start_netserver(terminal="client", cpus=self.c_cpus)
        time.sleep(2)
        run_cnt, rx_total_bw, tx_total_bw, rx_total_bw_list, tx_total_bw_list = 3, 0, 0, [], []
        for idx in range(run_cnt):
            self.__start_netperf__(terminal="server", host=remote_ip1, port=port3, **kwargs)
            self.__start_netperf__(terminal="server", host=remote_ip2, port=port4, **kwargs)
            self.__start_netperf__(terminal="client", host=local_ip1, port=port1, **kwargs)
            self.__start_netperf__(terminal="client", host=local_ip2, port=port2, **kwargs)
            time.sleep(2)
            for terminal in ("server", "client"):
                handler = comm.get_terminal_handler(terminal)
                rx_sar_log = f"{path}_server_sar_{terminal}_{number}_rx_{idx}.log"
                handler.send_command(f"sar -n DEV 1 30 > '{rx_sar_log}' 2>&1")
                tx_sar_log = f"{path}_server_sar_{terminal}_{number}_tx_{idx}.log"
                handler.send_command(f"sar -n DEV 1 30 > '{tx_sar_log}' 2>&1")
                comm.wait_process_finish("sar", terminal=terminal)

                if terminal == "server":
                    for iface in (s_iface1, s_iface2):
                        handler.send_command(f"cat {rx_sar_log} | grep Average |grep {iface} | "
                                             f"awk '{{printf $5}}'")
                        rx_total_bw += float(handler.information.strip())
                        handler.send_command(f"cat {tx_sar_log} | grep Average |grep {iface} | "
                                             f"awk '{{printf $6}}'")
                        tx_total_bw += float(handler.information.strip())
                    rx_total_bw_list.append(rx_total_bw)
                    tx_total_bw_list.append(tx_total_bw)

                else:
                    for iface in (c_iface1, c_iface2):
                        handler.send_command(f"cat {rx_sar_log} | grep Average |grep {iface} | "
                                             f"awk '{{printf $5}}'")
                        rx_total_bw += float(handler.information.strip())
                        handler.send_command(f"cat {tx_sar_log} | grep Average |grep {iface} | "
                                             f"awk '{{printf $6}}'")
                        tx_total_bw += float(handler.information.strip())
                    rx_total_bw_list.append(rx_total_bw)
                    tx_total_bw_list.append(tx_total_bw)
            comm.kill_process('netperf', terminal=terminal)
        comm.kill_process('netserver', terminal=terminal)
        server_rx_bw1, server_rx_bw2 = rx_total_bw_list[0] / run_cnt, rx_total_bw_list[1] / run_cnt
        client_rx_bw1, client_rx_bw2 = rx_total_bw_list[-1] / run_cnt, rx_total_bw_list[-2] / run_cnt
        server_tx_bw1, server_tx_bw2 = tx_total_bw_list[0] / run_cnt, tx_total_bw_list[1] / run_cnt
        client_tx_bw1, client_tx_bw2 = tx_total_bw_list[-1] / run_cnt, tx_total_bw_list[-2] / run_cnt
        msg_center.info(f"测试server端rx方向{run_cnt}次平均性能为: 网口1：{server_rx_bw1}，网口2：{server_rx_bw2}")
        msg_center.info(f"测试client端rx方向{run_cnt}次平均性能为: 网口1：{client_rx_bw1}，网口2：{client_rx_bw2}")
        msg_center.info(f"测试server端tx方向{run_cnt}次平均性能为: 网口1：{server_tx_bw1}，网口2：{server_tx_bw2}")
        msg_center.info(f"测试client端tx方向{run_cnt}次平均性能为: 网口1：{client_tx_bw1}，网口2：{client_tx_bw2}")
        return server_rx_bw1, server_rx_bw2, client_rx_bw1, client_rx_bw2, \
            server_tx_bw1, server_tx_bw2, client_tx_bw1, client_tx_bw2


    @staticmethod
    def get_performance_benchmark_data(smmu_mode='nostrict', protocol_type='tcp', iptype='ipv4', config_item='ring',
                                       config_value='1024', packet_len='largelen', threads='1'):
        """
        =====================================================================
        函数名称 : get_performance_benchmark_data
        函数说明 :此函数用作获取性能基准数据
        参数说明 :
        smmu_mode：
        protocol_type：
        iptype：
        config_value：
        packet_len：
        threads:
        返回结果 : 本端和对端网卡需要绑定的核
        注意事项 : 无
        使用实例 : result = self.get_performance_benchmark_data()
        
        生成时间 : 2021-09-15
        修改纪录 :
        =====================================================================
        """
        try:
            filename = "{}/lib/performance_config.json".format(ROOTDIR)
            performance_benchmark = open(filename, 'r')
        except IOError as error:
            assert error.strerror != "No such file or directory", msg_center.error(error)
        finally:
            pass
        datas = json.load(performance_benchmark)
        performance_benchmark.close()
        data = datas["pagepool"][smmu_mode][protocol_type][iptype][config_item][config_value][packet_len]["threads"][
            threads]
        return data


    @staticmethod
    def fn_process_network_bw_data(expect, tool, terminal="server", **kwargs):
        """
        =====================================================================
        函数说明: 保存性能数据到执行机
        修改时间: 2022/01/14 16:34:57
        作    者: ywx925178
        =====================================================================
        """
        handler = comm.get_terminal_handler(terminal)
        file = f"{engine_global.pytest.case_name}.json"
        __save_bw_info__(file, f"case_name    ：{engine_global.pytest.case_name}\n")
        __save_bw_info__(file, f"\n测试基本信息如下：\n")
        __save_bw_info__(file, f"test_mode    : {kwargs.get('mode', 'SMMU')}\n")
        __save_bw_info__(file, f"port_speed   : {kwargs.get('port_speed', '')}\n")
        __save_bw_info__(file, f"test_tool    : {tool}")
        __save_bw_info__(file, f"test_protocol: {kwargs.get('pro', 'TCP')}\n")
        __save_bw_info__(file, f"test_thread  : {kwargs.get('thread', '1')}\n")
        __save_bw_info__(file, f"test_time    : {kwargs.get('time', '30s')}\n")
        __save_bw_info__(file, f"expect_bw    : {expect}\n")

        __save_bw_info__(file, f"\n单端口测试带宽信息如下（单位：M/s）：\n")
        __save_bw_info__(file, f"server_tx_bw : {kwargs.get('s_tx_bw', 'N/A')}\n")
        __save_bw_info__(file, f"server_rx_bw : {kwargs.get('s_rx_bw', 'N/A')}\n")
        __save_bw_info__(file, f"client_tx_bw : {kwargs.get('c_tx_bw', 'N/A')}\n")
        __save_bw_info__(file, f"client_rx_bw : {kwargs.get('c_rx_bw', 'N/A')}\n")
        if kwargs.get("s_tx_bw2", None) is not None or kwargs.get("s_rx_bw2", None) is not None \
                or kwargs.get("c_tx_bw2", None) is not None or kwargs.get("c_rx_bw2", None) is not None:
            __save_bw_info__(file, f"\n双端口测试(端口2)带宽信息如下（单位：M/s）：\n")
            __save_bw_info__(file, f"server_tx_bw2: {kwargs.get('s_tx_bw2', 'N/A')}\n")
            __save_bw_info__(file, f"server_rx_bw2: {kwargs.get('s_rx_bw2', 'N/A')}\n")
            __save_bw_info__(file, f"client_tx_bw2: {kwargs.get('c_tx_bw2', 'N/A')}\n")
            __save_bw_info__(file, f"client_rx_bw2: {kwargs.get('c_rx_bw2', 'N/A')}\n")

        msg_center.info("打印单板信息")
        __save_bw_info__(file, f"\n单板信息如下：\n")
        for cmd in ("free -g", "lscpu", "dmidecode -t memory | grep -i speed"):
            handler.send_command(cmd, disable_show_and_log=True)
            __save_bw_info__(file, f"**********{cmd}**********:\n {handler.information}\n\n")


    @staticmethod
    def iperf_get_bw(log_path, terminal="server"):
        """
        =====================================================================
        函数说明: 获取iperf冲包网口带宽数据
        修改时间: 2023/05/19 16:34:57
        作    者: ywx925178
        =====================================================================
        """
        bw_msg = comm.exec_command(terminal=terminal, command=f"cat {log_path}")
        return re.findall("MBytes\\s+(.*)\\sMbits/sec", bw_msg)


    def get_memory_module_info(terminal="server"):
        info = comm.exec_command(terminal, "dmidecode -t memory | grep -i 'memory speed'")
        speeds = set(re.findall(r'Speed: (.*) MT/s', info))
        speed_dict = {}
        for speed in speeds:
            c = info.count(f'Speed: {speed} MT/s')
            speed_dict[speed] = c
        return speed_dict


    def save_performance_in_xls(self, base_data, local_date, **kwargs):
        wk = xlwt.Workbook()
        # 设置单元格背景色
        styleg = xlwt.easyxf('pattern: pattern solid, fore_colour green')
        styler = xlwt.easyxf('pattern: pattern solid, fore_colour red')
        # 设置单元格格式为居中
        al = xlwt.Alignment()
        al.horz = 0x02
        al.vert = 0x01
        styleg.alignment = al
        styler.alignment = al
        # 设置表存放路径，名称，信息
        m_time = time.strftime("%Y-%m", time.localtime(time.time()))
        d_time = time.strftime("%Y-%m-%d", time.localtime(time.time()))
        file_name = f"/home/cilog/nic_performance_{m_time}.xls"
        # 设置列标题，获取性能环境的参数配置
        title = ['环境ip', 'mem_speed', 'smmu', 'cpu_num', 'port', 'pagepool', 'mtu', 'rx-buf-len', 'tx_ring',
                 'rx_ring', '网口速率',
                 '协议', '包长', '线程数', '单位', '性能指标', '用例编号', '方向']
        terminal = kwargs.get("terminal", ["server", "client"])
        remote_data = kwargs.get("remote_data", "NULL")
        sheet_name = kwargs.get("sheet_name", "4K")
        direction = kwargs.get("direction", "NULL")
        smmu = kwargs.get("smmu", "on")
        threads = kwargs.get("threads", 1)
        flow = kwargs.get("flow", "tcp4")
        length = kwargs.get("length", "大包")
        unit = kwargs.get("unit", "Mbit/s")
        port = kwargs.get("port", "pf")
        ip = f"本端：{ssh.server_ip} 对端：{ssh.client_ip}"
        if isinstance(terminal, str):
            s_mem_speed = self.get_memory_module_info(terminal=terminal)
            dicts = {"本端": s_mem_speed}
        if isinstance(terminal, list):
            s_mem_speed = self.get_memory_module_info(terminal=terminal[0])
            c_mem_speed = self.get_memory_module_info(terminal=terminal[1])
            dicts = {"本端": s_mem_speed, "对端": c_mem_speed}
        mem_speed = ""
        for key, value in dicts.items():
            for mem_key, mem_value in value.items():
                mem_speed = mem_speed + key + f"内存条频率{mem_key}: {mem_value}根 "
        rx_buf_len = self.ring_info.get('rx buf len')
        tx_ring = self.ring_info.get('tx')
        rx_ring = self.ring_info.get('rx')
        # 如果文件不存在，则新建文件，并且新建一个4K的sheet，一个64K的sheet，每个sheet写入列标题
        if os.path.exists(file_name) == False:
            sheet1 = wk.add_sheet('4K')
            sheet2 = wk.add_sheet('64K')
            i = 0
            for line in title:
                sheet1.write(0, i, line, styleg)
                sheet2.write(0, i, line, styleg)
                # 设置列的宽度
                sheet1.col(i).width = 256 * 10
                sheet2.col(i).width = 256 * 10
                i = i + 1
            wk.save(file_name)
        # 如果表格存在，使用xlrd对表格进行追加写入
        rb = xlrd.open_workbook(file_name, formatting_info=True)
        all_sheet = rb.sheet_names()
        sheet = rb.sheet_by_name(all_sheet[all_sheet.index(sheet_name)])
        rows = sheet.nrows
        newrb = copy(rb)
        new_sheet = newrb.get_sheet(all_sheet.index(sheet_name))
        # 先检查表格里面是否已经存在用例的参数配置，如果存在，则跳过
        # 如果不存在，需要先写入参数配置
        row_index = 1
        tmp_result = [ip, mem_speed, smmu, self.cpu_num, port, self.pagepool, self.mtu, rx_buf_len, tx_ring, rx_ring,
                      self.speed, flow, length, threads, unit, base_data, engine_global.pytest.case_name, direction]
        for i in range(1, rows):
            row_value = sheet.row_values(i)
            if set(tmp_result).issubset(set(row_value)):
                break
            row_index = row_index + 1
        else:
            for i in range(len(tmp_result)):
                new_sheet.write(rows, i, tmp_result[i], styleg)
            newrb.save(file_name)
            row_index = rows
        # 性能数据按天存放
        result = {f'{d_time}_local': local_date, f'{d_time}_remote': remote_data}
        rb = xlrd.open_workbook(file_name, formatting_info=True)
        all_sheet = rb.sheet_names()
        sheet = rb.sheet_by_name(all_sheet[all_sheet.index(sheet_name)])
        newrb = copy(rb)
        new_sheet = newrb.get_sheet(all_sheet.index(sheet_name))
        row_len = sheet.row_len(row_index)
        if set([f'{d_time}_local']).issubset(set(sheet.row_values(0))):
            row_len = row_len - 2
        i = 0
        # 写入性能数据，如果有指标且实际性能低于指标性能，写入红色，否则写入绿色
        for key, value in result.items():
            new_sheet.write(0, row_len + i, key, styleg)
            style = styleg
            if base_data != "NULL":
                # 如果传入的是字符串类型，先进行分割再比较
                if isinstance(local_date, str):
                    for data in local_date.split(", "):
                        if float(data) < base_data:
                            style = styler
                else:
                    if local_date < base_data:
                        style = styler
            new_sheet.write(row_index, row_len + i, value, style)
            new_sheet.col(row_len + i).width = 256 * 15
            i = i + 1
        newrb.save(file_name)
