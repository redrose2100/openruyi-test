#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
#====================================================================================
# @
# @
# @Create time : 2022/1/27 14:54
# @FileName    : virt_pytest_plugin.py
# @Description : VIRT模块前置操作、定制插件
#====================================================================================
"""
import pytest

from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from feature_lib.virt_lib.virt_environment import VirtEnvironment
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.virt_config.virt_config import virt_global


@pytest.fixture(scope='session', autouse=True)
def virt_case_session():
    """
    virt模块中支持框架前后置运行的插件
    """
    msg_center.info('virt模块自定义的session级别前置动作')
    project_lib.set_run_env_type_by_dut_platform()

    msg_center.info("远程连接的服务端ip是:%s", VirtEnvironment().server['ip'])
    VirtEnvironment().dut_init()


    yield

    msg_center.info('{}模块自定义的session级别后置动作'.format(engine_global.project.feature_name))
    project_lib.move_log_to_local(virt_global.server_scp)
    msg_center.info("关闭远程的句柄连接")
    VirtEnvironment().dut_close()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='function', autouse=True)
def virt_case_function():
    """
    virt模块中支持用例前后置运行的插件
    """

    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg = '%s start run'.center(100, '=')
    msg_center.title('{}模块自定义的function级别前置动作'.format(engine_global.project.feature_name))
    # 将每个用例的日志开始信息写入到dmesg日志中
    virt_global.server_ssh.send_command('echo %s > /dev/kmsg' % msg)

    yield
    msg_center.title('{}模块自定义的function级别后置动作'.format(engine_global.project.feature_name))