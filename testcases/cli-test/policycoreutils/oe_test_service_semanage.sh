#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test restorecond.service restart
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test -f var/lib/selinux/targeted/semanage.trans.LOCK && rm -rf var/lib/selinux/targeted/semanage.trans.LOCK
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # HTTPD 在 5000 端口上监听
    semanage port -m -t http_port_t -p tcp 5000
    CHECK_RESULT $? 0 0 "failed to listen port 5000"
    #查看 SELinux 和 Linux 用户之间的映射
    semanage login -l |grep "Login"
    CHECK_RESULT $? 0 0 "failed to check"
    #配置单个进程（域）运行在许可模式
    semanage permissive -a httpd_t
    CHECK_RESULT $? 0 0 "failed to configure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "Nothing to do."

    LOG_INFO "End to restore the test environment."
}

main "$@"
