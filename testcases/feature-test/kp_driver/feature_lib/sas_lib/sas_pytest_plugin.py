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

from feature_lib.sas_lib.sas_environment import SasEnvironment
from feature_lib.sas_lib.sas_util import SasUtil
from feature_lib.sas_lib import sas_fio as sfio

from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.sas_config.sas_config import sas_global
from test_config.feature_config.sas_config import sas_config as scfg


@pytest.fixture(scope='session', autouse=True)
def sas_case_session():
    """
    SAS模块中支持框架前后置运行的插件
    """
    msg_center.info('SAS模块自定义的session级别前置动作')
    project_lib.set_run_env_type_by_dut_platform()

    msg_center.info("远程连接的服务端ip是:%s", SasEnvironment().server.get('ip'))
    SasEnvironment().dut_init()

    # 当在windows环境执行用例时,判断日志路径不存在的话就去创建日志文件夹
    sas_global.server_ssh.send_command('mkdir -p {}'.format(engine_global.project.base_dir_path))
    msg_center.info(f"The log path is {engine_global.project.base_dir_path}")

    # FIO配置文件和日志路径
    sas_global.fio_cfg = "{}/fio.conf".format(engine_global.project.base_dir_path)
    sas_global.fio_log = "{}/fio_{}.log".format(engine_global.project.base_dir_path,
                                                engine_global.pytest.case_name.lower())

    # 查看当前环境
    uname_r = sas_global.server_ssh.send_command("uname -r")

    # 获取bios版本
    sas_global.bios_version = sas_global.server_ssh.send_command(
        "dmidecode -t bios | grep Version")

    # 如果是polerstar版本则驱动路径是"/lib/modules/{}/updates/drivers/scsi/hisi_sas".format(uname_r)
    # 查找SAS模块路径
    sas_global.modules = "/lib/modules/{}/updates/drivers/scsi/hisi_sas".format(uname_r)
    sas_global.server_ssh.send_command(f"ls {sas_global.modules}")
    if sas_global.server_ssh.ret_code != 0:
        sas_global.modules = "/lib/modules/{}/kernel/drivers/scsi/hisi_sas".format(uname_r)


    # 检查驱动v3是否存在，不存在则加载
    if not sas_global.server_ssh.send_command("lsmod | grep hisi_sas_v3_hw"):
        msg_center.error("SAS driver is not loaded. Going to load SAS driver")
        if not SasUtil.sas_insmod_ko():
            msg_center.error("SAS driver is not loaded. Please check environment")

    # # 检查磁盘全部加载完毕
    if not SasUtil.check_disk_num(seconds=60):
        msg_center.error("Disk load is not completed. Please check environment")

    # 检查硬盘，获取所接的SAS控制器
    msg_center.info('检查硬盘，且是否挂载SAS驱动下')
    disknum = SasUtil.get_disk_num()
    check_result(disknum > 0, True, fail_str="获取硬盘个数")
    sas_global.devices = SasUtil.get_devices_name()

    # 获取控制器基地址
    check_result(SasUtil.get_test_device(), True, fail_str="测试控制器和控制器基地址获取失败")

    # 获取单签环境控制器个数
    sas_global.server_ssh.send_command(
        "ls {} | grep '0000*' | wc -l".format(scfg.v3hw_path))
    sas_global.controller_num = int(sas_global.server_ssh.stdout)

    # 清除dmesg
    msg_center.info("清除dmesg")
    sas_global.server_ssh.send_command("dmesg -C")

    # 创建FIO配置文件
    msg_center.info('创建FIO配置文件')
    sfio.init()

    # 拷贝工具
    SasUtil.check_cp_tools()

    yield

    msg_center.info('{}模块自定义的session级别后置动作'.format(engine_global.project.feature_name))
    project_lib.move_log_to_local(sas_global.server_scp)
    msg_center.info("关闭远程的句柄连接")
    SasEnvironment().dut_close()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='function', autouse=True)
def sas_case_function():
    """
    sas模块中支持用例前后置运行的插件
    """

    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg = '%s start run'.center(100, '=')
    msg_center.title('{}模块自定义的function级别前置动作'.format(engine_global.project.feature_name))
    # 拷贝工具到日志文件夹
    sas_global.sas_tool_check = SasUtil.init_tools()
    # 将每个用例的日志开始信息写入到dmesg日志中
    sas_global.server_ssh.send_command('echo %s > /dev/kmsg' % msg)
    cmdos = CmdOs(terminal=sas_global.server_ssh)
    SasUtil.sas_kill_process(cmd_os=cmdos)

    # 检查所有phy（规避前面用例异常phy关闭没打开的情况）
    SasUtil.check_phy_enable()

    yield

    msg_center.title('{}模块自定义的function级别后置动作'.format(engine_global.project.feature_name))
    msg_center.info('环境日志：保存dmesg日志')
    sas_global.server_ssh.send_command('dmesg -c >> {}/dmesg.log'.format(
        engine_global.project.base_dir_path))
    project_lib.function_pytest_teardown(terminal_dict={"server": sas_global.server_scp})
