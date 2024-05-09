#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
#====================================================================================
# @
# @
# @Create time : 2022/1/27 14:54
# @FileName    : virt_environment.py
# @Description : virt模块的连接句柄封装
#====================================================================================
"""
from common_lib.base_lib.base_multi_mode_terminal import MultiModeTerminal
from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config import project_global
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.virt_config.virt_config import virt_env_info, virt_global


class VirtEnvironment:
    """
    VIRT模块连接环境的类
    """

    def __init__(self):
        if engine_global.project.schedule_platform == 'lava':
            result = project_lib.get_lava_device_ip_address()
            self.server = result.get('server')
            self.client = result.get('client')
        else:
            # 本地调试与CIDA调试
            for topology in virt_env_info:
                if topology.get('dut_id') == engine_global.project.dut_id:
                    self.server = topology.get("server")
                    self.client = topology.get("client")
                    break
            else:
                # 如果在特性的配置文件中未找到环境信息,则去lava的设备配置信息中去找
                result = project_lib.get_lava_device_ip_address()
                self.server = result.get('server')
                self.client = result.get('client')
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
        virt_global.server_ssh = MultiModeTerminal(self.server['ip'], self.server['port'], self.server['username'],
                                                  self.server['password'], MultiModeTerminal.TYPE_BASE_SSH, **kwargs)
        virt_global.server_ssh.open_connect()
        virt_global.client_ssh = MultiModeTerminal(self.client['ip'], self.client['port'], self.client['username'],
                                                  self.client['password'], MultiModeTerminal.TYPE_BASE_SSH, **kwargs)
        virt_global.client_ssh.open_connect()
        virt_global.server_exp = MultiModeTerminal(self.server['ip'], self.server['port'], self.server['username'],
                                                  self.server['password'], MultiModeTerminal.TYPE_PEXPECT, **kwargs)
        virt_global.server_exp.open_connect()
        virt_global.client_scp = MultiModeTerminal(self.client['ip'], self.client['port'], self.client['username'],
                                                  self.client['password'], MultiModeTerminal.TYPE_SSH, **kwargs)
        virt_global.client_scp.open_connect()

    @staticmethod
    def dut_close():
        """
        断开与测试单板的连接
        :return:
        """
        virt_global.server_ssh.close_connect()
        virt_global.client_ssh.close_connect()
        virt_global.server_exp.close_connect()
        virt_global.client_scp.close_connect()
