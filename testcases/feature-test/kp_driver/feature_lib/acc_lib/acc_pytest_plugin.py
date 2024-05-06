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
# @Desc      	:   add lib for acc pytest
#####################################

import pytest
import time

from common_lib.testengine_lib.engine_global import engine_global
from common_lib.testengine_lib.engine_msg_center import msg_center
from common_lib.base_lib.base_pexpect import BasePexpect2
from feature_lib.acc_lib.acc_environment import AccEnvironment

from test_config.global_config.global_config_lib import project_lib
from test_config.feature_config.acc_config.acc_config import acc_global, acc_config


@pytest.fixture(scope='session', autouse=True)
def acc_case_session():
    """
    acc模块中支持框架前后置运行的插件
    """
    msg_center.info('acc模块自定义的session级别前置动作')
    project_lib.set_run_env_type_by_dut_platform()

    msg_center.info("远程连接的服务端ip是:%s", AccEnvironment().server['ip'])
    AccEnvironment().dut_init()
    # 当在windows环境执行用例时,判断日志路径不存在的话就去创建日志文件夹
    acc_global.server_ssh.send_command('mkdir -p %s' % engine_global.project.base_dir_path)

    acc_global.server_ssh.send_command("uname -r")
    uname_r = acc_global.server_ssh.stdout
    acc_global.modules = "/lib/modules/{}".format(uname_r)

    # 如果是盘古环境，需要从远端服务器下载acc_test工具，并增加devmem可执行权限
    ret = acc_global.server_ssh.send_command("dmidecode -t bios |grep -i pangea")
    if len(ret) != 0:
        check_execute = acc_global.server_ssh.send_command("acc_test -h |grep 'alg' |grep 'hisi'")
        if "alg" not in check_execute and "hisi" not in check_execute:
            handler = BasePexpect2(ip=AccEnvironment().server['ip'], username="admin", password="Admin@storage1",
                                   expect=r'(root@localhost.*?#|Storage.*?#)')
            handler.open()
            kawrgs = dict(service_ip="10.67.164.70", username="root", password="huawei", timeout=10)
            handler.pexpect_scp_file(local_file="/usr/bin/", remote_dir="/home/acc/pangea/acc_test", pull=True, **kawrgs)
            handler.close()
            check_file = acc_global.server_ssh.send_command("ls -l /usr/bin/ |grep acc_test")
            if len(check_file) == 0:
                msg_center.error("从远端服务器获取acc_test工具失败！")
                assert False
            check_again = acc_global.server_ssh.send_command("acc_test -h |grep 'alg'")
            if len(check_again) == 0:
                msg_center.error("acc_test工具无法正常运行！")
                assert False
            acc_global.server_ssh.send_command("chmod -R 755 /usr/bin/acc_test")
        acc_global.server_ssh.send_command("chmod -R 755 /OSM/modules/devmem")
    yield

    msg_center.info('{}模块自定义的session级别后置动作'.format(engine_global.project.feature_name))
    project_lib.get_esl_gcov_data_tar_gz(acc_global.server_ftp)

    # project_lib.move_log_to_local(acc_global.server_ftp)

    msg_center.info("关闭远程的句柄连接")
    AccEnvironment().dut_close()
    project_lib.frame_pytest_teardown()


@pytest.fixture(scope='function', autouse=True)
def acc_case_function():
    """
    acc模块中支持用例前后置运行的插件
    """

    # 在日志记录用例名称
    msg_center.info(engine_global.pytest.case_item.function.__doc__)
    msg = '%s start run'.center(100, '=')
    msg_center.title('{}模块自定义的function级别前置动作'.format(engine_global.project.feature_name))
    # 将每个用例的日志开始信息写入到dmesg日志中
    acc_global.server_ssh.send_command('echo %s > /dev/kmsg' % msg)
    yield
    msg_center.title('{}模块自定义的function级别后置动作'.format(engine_global.project.feature_name))
