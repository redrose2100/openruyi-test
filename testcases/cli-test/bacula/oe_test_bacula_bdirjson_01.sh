#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test bdirjson
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-common tar"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bdirjson -v | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bdirjson -v failed"
    bdirjson -t /etc/bacula/bacula-dir.conf
    CHECK_RESULT $? 0 0 "test bdirjson -t failed"
    bdirjson -v -r JobDefs /etc/bacula/bacula-dir.conf | grep 'JobDefs'
    CHECK_RESULT $? 0 0 "test bdirjson -r failed"
    bdirjson -v -r JobDefs -l Type /etc/bacula/bacula-dir.conf | grep 'Type'
    CHECK_RESULT $? 0 0 "test bdirjson -l failed"
    bdirjson -v -n Standard /etc/bacula/bacula-dir.conf | grep '"Name": "Standard"'
    CHECK_RESULT $? 0 0 "test bdirjson -n failed"
    bdirjson -v -D /etc/bacula/bacula-dir.conf | grep '"Name": "Daemon"'
    CHECK_RESULT $? 0 0 "test bdirjson -D failed"
    bdirjson -v -c /etc/bacula/bacula-dir.conf ./config/a.config | grep 'DefaultJob11'
    CHECK_RESULT $? 0 0 "test bdirjson -c failed"
    bdirjson -v -d 19 /etc/bacula/bacula-dir.conf | grep 'Debug level = 19'
    CHECK_RESULT $? 0 0 "test bdirjson -d failed"
    bdirjson -v -? /etc/bacula/bacula-dir.conf 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bdirjson -? failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    DNF_REMOVE
    rm -rf config/
    LOG_INFO "End to restore the test environment."
}

main "$@"
