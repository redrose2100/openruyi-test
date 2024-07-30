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


import concurrent.futures

from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.base_lib.base_config import SUCCESS_CODE, FAILURE_CODE
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal
from common_lib.base_lib.base_multi_mode_terminal import TYPE_BASE_SSH
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from test_config.feature_config.hns_config import hns_config


class HnsEnv():
    """
    =====================================================================
    函数说明: NA
    :param NA
    函数返回: None
    应用举例: NA
    修改时间: 2021/12/15 16:13:34
    作    者: lwx567203
    =====================================================================
    """

    def __init__(self):
        self.__get_yaml_conf()

    def __get_yaml_conf(self):
        """
        =====================================================================
        函数说明: 从yaml文件中获取配置
        :param NA
        函数返回: None
        应用举例: NA
        修改时间: 2021/12/17 10:03:12
        作    者: lwx567203
        =====================================================================
        """
        result = project_lib.get_lava_device_ip_address()
        self.server_info = result.get('server')
        self.client_info = result.get('client')

    def _connect_dut(self, terminal: str, connect_type: str) -> object:
        """
        =====================================================================
        函数说明: ssh连接单板
        修改时间: 2021/12/15 15:26:16
        作    者: lwx567203
        =====================================================================
        """
        info = {
            "server": self.server_info, "client": self.client_info,
            "ftp_server": self.server_info, "ftp_client": self.client_info,
            "server_telnet": self.server_info, "client_telnet": self.client_info,
        }.get(terminal, "server")

        ip = info.get('ip', "127.0.0.1")
        port = info.get('port', 22)
        username = info.get('username', "test")
        password = info.get('password', "test")
        if terminal.count("_telnet"):
            ip = info.get('telnet')
            port = info.get('serial')
            username = None
            password = None

        if not ip or not port:
            return SUCCESS_CODE

        msg_center.info(f"建立{terminal}连接到{ip}")
        handler = MultiModeTerminal(ip, int(port), username, password, type=connect_type, prompt=hns_config.HOST_PROMPTER)
        if not handler.open_connect():
            msg_center.error(f"connect to {terminal}: {info.get('ip')}失败")
            return FAILURE_CODE
        setattr(ssh, terminal, handler)
        setattr(ssh, f"{terminal}_ip", info.get("ip"))
        setattr(ssh, f"{terminal}_user", info.get("username"))
        setattr(ssh, f"{terminal}_key", info.get("password"))
        if not getattr(hns_config, f"{terminal}_ifaces", []):
            setattr(hns_config, f"{terminal}_ifaces", info.get("ifaces", "").split())
        if not getattr(hns_config, f"{terminal}_bdfs", []):
            setattr(hns_config, f"{terminal}_bdfs", info.get("bdfs", "").split())
        return SUCCESS_CODE

    def connect_dut(self, connect_type: str = TYPE_BASE_SSH):
        """
        =====================================================================
        函数说明: 建立远程连接
        修改时间: 2021/12/15 15:34:40
        作    者: lwx567203
        =====================================================================
        """
        threads = concurrent.futures.ThreadPoolExecutor(max_workers=10)
        connect_threads = []
        terminals = ["server", "server_telnet", "ftp_server"]
        types = [connect_type, MultiModeTerminal.TYPE_TELNET, MultiModeTerminal.TYPE_SSH]
        if hns_config.ENVIRONMENT.lower() == "client":
            terminals.extend(["client", "client_telnet", "ftp_client"])
            types = types * 2
        elif hns_config.ENVIRONMENT.lower() == "tesgine":
            from feature_lib.hns_lib.tesgine import hns_tesgine as tesgine
            connect_threads.append(threads.submit(tesgine.connect))
        else:
            pass

        for terminal, con_type in zip(terminals, types):
            connect_threads.append(threads.submit(self._connect_dut, terminal, con_type))

        concurrent.futures.wait(connect_threads)
        for thread in connect_threads:
            if thread.result() != SUCCESS_CODE:
                return False
        return True

    @staticmethod
    def disconnect_dut():
        """
        =====================================================================
        函数说明: 断开连接
        修改时间: 2021/12/20 11:32:33
        作    者: lwx567203
        =====================================================================
        """
        for key in ("server", "ftp_server", "server_telnet", "client", "ftp_client", "client_telnet"):
            terminal = getattr(ssh, key, None)
            if not terminal:
                continue
            terminal.close_connect()
        if ssh.tesgine:
            from feature_lib.hns_lib.tesgine import hns_tesgine as tesgine
            tesgine.disconnect()
