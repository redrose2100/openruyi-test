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
# @Desc      :   Test bsdjson
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client mysql-server bacula-common tar"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bsdjson -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bsdjson -? failed"
    bsdjson -r Device /etc/bacula/bacula-sd.conf | grep '"Device":'
    CHECK_RESULT $? 0 0 "test bsdjson -r failed"
    bsdjson -n bacula-dir /etc/bacula/bacula-sd.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bsdjson -n failed"
    bsdjson -r Device -l /dev/null /etc/bacula/bacula-sd.conf | grep 'FileChgr2-Dev1'
    CHECK_RESULT $? 0 0 "test bsdjson -l failed"
    bsdjson -D /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bsdjson -D failed" 
    bsdjson -c /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bsdjson -c failed"
    bsdjson -d 21 /etc/bacula/bacula-sd.conf | grep 'bacula-sd: address_conf.c:' 
    CHECK_RESULT $? 0 0 "test bsdjson -d failed"
    bsdjson -dt -d 21 /etc/bacula/bacula-sd.conf | grep '.*-.*-.* .*:.*:.* bacula-sd:'
    CHECK_RESULT $? 0 0 "test bsdjson -dt failed"
    bsdjson -t /etc/bacula/bacula-sd.conf
    CHECK_RESULT $? 0 0 "test bsdjson -t failed"
    bsdjson -v /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bsdjson -v failed"
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
