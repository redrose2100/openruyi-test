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
    bdirjson -v -R /etc/bacula/bacula-dir.conf | grep 'Director'
    CHECK_RESULT $? 0 0 "test bdirjson -R failed"
    bdirjson -v -d 11 -dt /etc/bacula/bacula-dir.conf | grep '.*-.*-.* .*:.*:.*'
    CHECK_RESULT $? 0 0 "test bdirjson -dt failed"
    bdirjson -v -s /etc/bacula/bacula-dir.conf | grep 'Director: name=bacula-dir'
    CHECK_RESULT $? 0 0 "test bdirjson -s failed"
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
