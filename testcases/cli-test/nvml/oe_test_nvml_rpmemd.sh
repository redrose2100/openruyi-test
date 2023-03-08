#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of nvml command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nvml
    cat >rpmemd.conf <<EOL
  log-file = /var/log/rpmemd.log
  poolset-dir = $HOME
  persist-apm = no
  persist-general = yes
  use-syslog = yes
  log-level = err
EOL
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpmemd -h 2>&1 | grep 'usage: rpmemd'
    CHECK_RESULT $? 0 0 "Check rpmemd -h failed"
    rpmemd --help 2>&1 | grep 'usage: rpmemd'
    CHECK_RESULT $? 0 0 "Check rpmemd --help failed"
    rpmemd -V 2>&1 | grep $(rpm -q nvml --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check rpmemd -V failed"
    rpmemd --version 2>&1 | grep $(rpm -q nvml --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check rpmemd --version failed"
    rpmemd -c rpmemd.conf &
    ps -ef | grep rpmemd | grep -v grep
    CHECK_RESULT $? 0 0 "Check rpmemd -c failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf rpmemd.conf log.* blk.*
    kill -9 $(pgrep -f "rpmemd -c rpmemd.conf")
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
