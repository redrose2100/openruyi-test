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


import pytest
import os
import sys

from feature_lib.hns_lib.hns_environment import Hns3Environment
from test_config.feature_config.hns_config.hns_config import hns_global
from feature_lib.sys_lib.sys_clean import SysClean
from common_lib.testengine_lib.engine_utils import check_result
from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from feature_lib.hns_lib import hns_test_envir
from feature_lib.hns_lib import hns_common
from test_config.feature_config.hns_config import hns_config
from test_config.feature_config.hns_config.hns_config import global_param as ssh
from test_config.global_config import global_config
from test_config.global_config.global_config import lava_global
from test_config.global_config.global_config_lib import project_lib


@pytest.fixture(scope='session', autouse=True)
def hns3_case_session():
    """
    HNS3模块中支持框架前后置运行的插件
    """
    msg_center.info('HNS3模块自定义的session级别前置动作')
    project_lib.set_run_env_type_by_dut_platform()

    msg_center.info("远程连接的服务端ip是:%s", Hns3Environment().server['ip'])
    Hns3Environment().dut_init()

    # 查看当前环境
    uname_r = hns_global.server_ssh.send_command("uname -r")
    hns_global.modules = "/lib/modules/{}".format(uname_r)
    # 检查网口环境
    ret = SysClean().fn_nic_environment_clean()
    check_result(ret, True, pass_str="前置环境检查成功，环境ready", fail_str="前置环境检查失败，存在环境未恢复，退出用例执行")

    yield

    msg_center.info('{}模块自定义的session级别后置动作'.format(engine_global.project.feature_name))
    project_lib.move_log_to_local(hns_global.server_scp)
    msg_center.info("关闭远程的句柄连接")
    Hns3Environment().dut_close()
    project_lib.frame_pytest_teardown()


def syspath_append():
    """
    =====================================================================
    函数说明: 添加路径到pythonpath中
    =====================================================================
    """
    current_dir = os.path.dirname(__file__)
    if current_dir not in sys.path:
        sys.path.append(current_dir)


@pytest.hookimpl
def pytest_addoption(parser):
    """
    自定义测试框架的传参
    @param parser:
    @return:
    """
    syspath_append()
    parser.addoption("-E",
                     "--environment",
                     default='client',
                     help='test_case run environment')
    parser.addoption("--sd",
                     default=None,
                     help='shell run with dic')

    parser.addoption("--SI", "--server_ifaces",
                     type=str,
                     nargs="+",
                     default=[],
                     help="specified server iface to test")
    parser.addoption("--CI", "--client_ifaces",
                     type=str,
                     nargs="+",
                     default=[],
                     help="specified client iface to test")
    parser.addoption("--CE", "--check_env",
                     action="store_true",
                     help="check environment when debug")
    parser.addoption("--case_running_time", type=int, default=0, help="specified case running time")


@pytest.fixture(scope="session", name="parse_args")
def get_cmd_args(pytestconfig):
    """
    解析命令行的参数，之后测试用例中可以以传参的形式进行调用参数
    @param request:
    @return:
    """
    hns_config.ENVIRONMENT = pytestconfig.getoption('--environment').strip().lower()
    hns_config.SD = pytestconfig.getoption('--sd')
    if hns_config.SD:
        hns_config.SD = pytestconfig.getoption('--sd').strip()
    # D06上vm启动超时时间设为5分钟
    hns_config.vtimeout = 300
    if lava_global.run_env_type in (2, 3):
        hns_config.lmatch = hns_config.vmatch
        # FPGA上vm启动超时时间设为45分钟
        hns_config.vtimeout = 2700
    hns_config.check_nev = pytestconfig.getoption("--check_env")
    hns_config.CASE_RUNNING_TIME = pytestconfig.getoption("--case_running_time")
    hns_config.server_ifaces = pytestconfig.getoption("--server_ifaces")
    hns_config.client_ifaces = pytestconfig.getoption("--client_ifaces")


@pytest.fixture(scope="session", name="ssh_handler")
def hns_env_connect(parse_args):
    """
    =====================================================================
    函数说明: 环境配置
    =====================================================================
    """
    project_lib.set_run_env_type_by_dut_platform()
    hns_config.HIARMTOOL = hns_config.HIARMTOOL.get(global_config.lava_global.run_env_type, 1)
    hns_env = hns_test_envir.HnsEnv()

    msg_center.info("start to prepare global var")
    if not hns_env.connect_dut():
        pytest.exit("部分连接创建失败")

    hns_common.exec_command("server", "uname -a")
    uname_r = hns_common.exec_command("server", "uname -r")
    if uname_r in hns_config.BIGDIPPER:
        hns_config.IMAGE_VERSION.update(dict(server=hns_config.BIGDIPPER_NAME))

    hns_common.exec_command("server", f"mkdir -p {engine_global.project.base_dir_path}")
    ssh.server.connect.cmd_result = True
    ssh.server.connect.realtime_output = True

    # 获取server端bios版本
    bios_version = hns_common.exec_command("server", "dmidecode -t bios | grep -i version:")
    if bios_version.lower().count("nezha"):
        global_config.lava_global.bios_version = hns_config.NEZHA_BIOS
    elif bios_version.lower().count("v200"):
        global_config.lava_global.bios_version = hns_config.V200_BIOS
    elif bios_version.lower().count("v100"):
        global_config.lava_global.bios_version = hns_config.V100_BIOS

    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        hns_common.exec_command("client", "uname -a")
        uname_r = hns_common.exec_command("client", "uname -r")
        if uname_r in hns_config.BIGDIPPER:
            hns_config.IMAGE_VERSION.update(dict(client="bigdipper"))
        hns_common.exec_command("client", f"mkdir -p {engine_global.project.base_dir_path}")
        ssh.client.connect.cmd_result = True
        ssh.client.connect.realtime_output = True

    yield

    for iface in hns_config.ALL_LOCAL_NETWORK_LIST_ISO:
        hns_common.exec_command("server", f"ifconfig {iface} 0")
    project_lib.move_log_to_local(ssh.ftp_server)
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        for iface in hns_config.ALL_REMOTE_NETWORK_LIST_ISO:
            hns_common.exec_command("client", f"ifconfig {iface} 0")
        project_lib.move_log_to_local(ssh.ftp_client)
    msg_center.info("关闭server端和client端句柄连接")
    hns_env.disconnect_dut()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='class', name="check_env")
def check_environment(ssh_handler):
    """
    =====================================================================
    函数说明: 本地调试检查环境
    修改时间: 2022/01/04 14:18:46
    作    者: lwx567203
    =====================================================================
    """
    if engine_global.project.schedule_platform == "lava":
        pass

    yield
    if hns_config.check_nev:
        msg_center.info("****添加代码：本地调试时检查环境信息****")
        hns_common.environment_self_check()


@pytest.fixture(scope='function', autouse=True)
def hns_case_function(check_env):
    """
    hns模块中支持用例前后置运行的插件
    """
    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg = f'start run {engine_global.pytest.case_name}'.center(50, '=')
    msg_center.title(f'{engine_global.project.feature_name}模块自定义的function级别前置动作')
    # 将每个用例的日志开始信息写入到dmesg日志中
    ssh.server.send_command(f'echo {msg} > /dev/kmsg')
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        ssh.client.send_command(f'echo {msg} > /dev/kmsg')
        project_lib.function_pytest_setup(terminal_dict={"server": ssh.client})
    project_lib.function_pytest_setup(terminal_dict={"server": ssh.server})
    yield
    msg_center.title(f'{engine_global.project.feature_name}模块自定义的function级别后置动作')
    # 清理并保存dmesg日志到本地
    hns_common.clear_dmesg_log(terminal="server")
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        hns_common.clear_dmesg_log(terminal="client")
        project_lib.function_pytest_teardown(terminal_dict={"server": ssh.client})
    project_lib.function_pytest_teardown(terminal_dict={"server": ssh.server})
    msg = f'end run {engine_global.pytest.case_name}'.center(50, '=')
    ssh.server.send_command(f'echo {msg} > /dev/kmsg')
    ssh.server.send_command("pkill -9 mz")
    if hns_config.ENVIRONMENT not in ["tesgine", "single"]:
        ssh.client.send_command(f'echo {msg} > /dev/kmsg')
        ssh.client.send_command("pkill -9 mz")
