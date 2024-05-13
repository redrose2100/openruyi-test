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
from kp_comm import CmdOs
from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.testengine_lib.engine_utils import check_result
from feature_lib.sata_lib.sata_environment import SataEnvironment
from test_config.feature_config.sata_config.sata_config import sata_global
from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.sata_config import sata_config as scfg
from feature_lib.sata_lib.sata_util import SataLib as sutil


@pytest.fixture(scope='session', autouse=True)
def sata_case_session():
    """
    功能描述：sata模块中支持框架前后置运行的插件
    """
    msg_center.info('sata模块自定义的session级别前置动作')
    project_lib.set_run_env_type_by_dut_platform()

    msg_center.info('远程连接的服务端ip是:%s', SataEnvironment().server.get('ip'))
    SataEnvironment().dut_init()

    # 当在windows环境执行用例时,判断日志路径不存在的话就去创建日志文件夹
    sata_global.server_ssh.send_command(
        'mkdir -p {}'.format(engine_global.project.base_dir_path))

    # FIO配置文件和日志路径
    sata_global.fio_cfg = "{}/fio.conf".format(engine_global.project.base_dir_path)
    sata_global.fio_log = "{}/fio_{}.log".format(engine_global.project.base_dir_path,
                                                engine_global.pytest.case_name.lower())

    # 去执行清理
    sata_global.server_ssh.send_command(
        f'{scfg.DMESG} -c >> {engine_global.project.base_dir_path}/dmesg.log')
    sata_global.server_ssh.send_command("uname -a")

    # 查询内存
    sata_global.server_ssh.send_command("free -m")
    sata_global.server_ssh.send_command('env')

    # 检查拷贝工具
    sutil.check_cp_tools(tool_names=[scfg.DISKTOOL, scfg.SG_RAW])

    yield
    msg_center.info('sas模块自定义的session级别后置动作')
    project_lib.move_log_to_local(sata_global.server_ftp)
    msg_center.info("关闭远程的句柄连接")
    SataEnvironment().dut_close()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='function', autouse=True)
def sata_case_function():
    """
    功能描述：sata模块中支持用例前后置运行的插件
    """
    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg_center.title('sata模块自定义的function级别前置动作')
    msg = '{} start run'.format(engine_global.pytest.case_name.lower()).center(100, '=')
    # 将每个用例的日志开始信息写入到dmesg日志中
    sata_global.server_ssh.send_command('echo {} > /dev/kmsg'.format(msg))
    # 检查硬盘，SATA控制器下有盘
    check_result(len(sutil.get_all_disks()) > 0, True, fail_str="当前环境上SATA控制器下无盘")
    cmdos = CmdOs(terminal=sata_global.server_ssh)
    cmdos.kill_process("fio")

    yield
    msg_center.title('sata模块自定义的function级别后置动作')
    msg_center.info('环境日志：保存dmesg日志')
    sata_global.server_ssh.send_command(
        f'{scfg.DMESG} -c >> {engine_global.project.base_dir_path}/dmesg.log')
    project_lib.function_pytest_teardown(terminal_dict={"server": sata_global.server_ftp})
