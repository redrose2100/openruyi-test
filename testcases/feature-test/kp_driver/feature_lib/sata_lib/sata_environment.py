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
from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config import project_global
from test_config.global_config.global_config_lib import project_lib

from test_config.feature_config.sata_config.sata_config import sata_env_info
from test_config.feature_config.sata_config.sata_config import sata_global, local_addr



class SataEnvironment:
    """
    功能描述：SATA模块连接环境的类
    """
    def __init__(self):
        if engine_global.project.schedule_platform == 'lava':
            result = project_lib.get_lava_device_ip_address()
            if project_global.dut_platform.lower() == "fpga":
                self.server = result.get('server')
            else:
                self.server = result.get('server', local_addr)
        else:
            # 本地调试与CIDA调试
            for topology in sata_env_info:
                if topology.get('dut_id') == engine_global.project.dut_id:
                    self.server = topology.get("server", local_addr)
                    break
            else:
                # 如果在特性的配置文件中未找到环境信息,则认为本地执行，用127.0.0.1连接
                self.server = local_addr
        if self.server is None:
            msg_center.error('未找到对应的测试单板信息,终止测试流程,请检查配置文件!!!')
            exit(-1)

    def dut_init(self, **kwargs):
        """
        功能描述：初始化并连接测试单板
        :param kwargs:
        :return: None
        """
        MultiModeTerminal.realtime_output = True
        MultiModeTerminal.cmd_result = True
        MultiModeTerminal.ssh_prompt = project_global.ssh_prompt
        sata_global.server_ssh = MultiModeTerminal(
            self.server.get('ip'), self.server.get('port'),
            self.server.get('username'),
            self.server.get('password'), MultiModeTerminal.TYPE_BASE_SSH, **kwargs)
        sata_global.server_ssh.open_connect()
        sata_global.client_ssh = MultiModeTerminal(
            self.server.get('ip'), self.server.get('port'),
            self.server.get('username'),
            self.server.get('password'), MultiModeTerminal.TYPE_BASE_SSH, **kwargs)
        sata_global.client_ssh.open_connect()
        sata_global.server_ftp = MultiModeTerminal(
            self.server.get('ip'), self.server.get('port'),
            self.server.get('username'),
            self.server.get('password'), MultiModeTerminal.TYPE_SSH, **kwargs)
        sata_global.server_ftp.open_connect()

    @staticmethod
    def dut_close():
        """
        功能描述：断开与测试单板的连接
        :return:
        """
        sata_global.server_ssh.close_connect()
        sata_global.client_ssh.close_connect()
        sata_global.server_ftp.close_connect()
