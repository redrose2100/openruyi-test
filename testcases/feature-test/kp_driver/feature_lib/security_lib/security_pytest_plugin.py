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

import pytest

from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.security_config.security_config import SECURITY
from .security_env import SecurityEnv
from test_config.feature_config.security_config.security_config import polestar_env_info
from test_config.global_config.global_config import lava_global


@pytest.fixture(scope="session", autouse=True)
def security_env_connect():
    security_env = SecurityEnv()
    msg_center.info("start to connect to server:%s", polestar_env_info.get("server"))
    security_env.dut_init()
    project_lib.set_run_env_type_by_dut_platform()
    SECURITY.terminal = security_env.terminal
    yield
    msg_center.info("关闭句柄连接")
    security_env.dut_close()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='function', autouse=True)
def security_case_function():
    """
    security模块中支持用例前后置运行的插件
    """
    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg = ('%s start run' % engine_global.pytest.case_name).center(100, '=')
    msg_center.title('{}模块自定义的function级别前置动作'.format(engine_global.project.feature_name))
    # 将每个用例的日志开始信息写入到dmesg日志中
    lava_global.feature_global.server_ssh.send_command('echo %s > /dev/kmsg' % msg)
    yield
    msg_center.title('{}模块自定义的function级别后置动作'.format(engine_global.project.feature_name))
    project_lib.function_pytest_teardown(terminal_dict={"server": SECURITY.terminal})
