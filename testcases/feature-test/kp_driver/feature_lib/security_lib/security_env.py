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
# @Date      	:   2024-05-06 15:36:43
# @License   	:   Mulan PSL v2
# @Desc      	:   add lib for acc enviroment
#####################################


from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.feature_config.security_config.security_config import polestar_env_info, security_global
from test_config.global_config.global_config import project_global


class SecurityEnv():
    def __init__(self):
        self.terminal = None
        # 从security_config.py中获取设备信息，安全测试为直连环境
        self.server_info = polestar_env_info
        self.server = polestar_env_info.get("server")
        self.client = polestar_env_info.get("client")
        if self.server is None:
            msg_center.error('未找到对应的测试单板信息,终止测试流程,请检查配置文件!!!')
            exit(-1)

    def dut_init(self, **kwargs):
        """
        初始化并连接测试单板
        :param kwargs:
        :return: None
        """
        MultiModeTerminal.realtime_output = True
        MultiModeTerminal.cmd_result = True
        MultiModeTerminal.ssh_prompt = project_global.ssh_prompt
        security_global.server_ssh = MultiModeTerminal(self.server['ip'], self.server['port'], self.server['username'],
                                                       self.server['password'], MultiModeTerminal.TYPE_BASE_SSH,
                                                       **kwargs)
        security_global.server_ssh.open_connect()
        security_global.client_ssh = MultiModeTerminal(self.client['ip'], self.client['port'], self.client['username'],
                                                       self.client['password'], MultiModeTerminal.TYPE_BASE_SSH,
                                                       **kwargs)
        security_global.client_ssh.open_connect()
        security_global.server_scp = MultiModeTerminal(self.server['ip'], self.server['port'], self.server['username'],
                                                       self.server['password'], MultiModeTerminal.TYPE_SSH, **kwargs)
        security_global.server_scp.open_connect()
        security_global.client_scp = MultiModeTerminal(self.client['ip'], self.client['port'], self.client['username'],
                                                       self.client['password'], MultiModeTerminal.TYPE_SSH, **kwargs)
        security_global.client_scp.open_connect()
        security_global.vm_server = MultiModeTerminal(self.server['ip'], self.server['port'], self.server['username'],
                                                      self.server['password'], MultiModeTerminal.TYPE_SSH, **kwargs)
        security_global.vm_server.open_connect()

    @staticmethod
    def dut_close():
        """
        断开与测试单板的连接
        :return:
        """
        security_global.server_ssh.close_connect()
        security_global.client_ssh.close_connect()
        security_global.server_scp.close_connect()
        security_global.client_scp.close_connect()
        security_global.vm_server.close_connect()
