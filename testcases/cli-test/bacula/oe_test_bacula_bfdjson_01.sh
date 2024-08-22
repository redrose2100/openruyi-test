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
# @Desc      :   Test bfdjson
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
    bfdjson -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bfdjson -? failed"
    bfdjson -r Director /etc/bacula/bacula-fd.conf | grep '"Director":'
    CHECK_RESULT $? 0 0 "test bfdjson -r failed"
    bfdjson -n bacula-dir /etc/bacula/bacula-fd.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bfdjson -n failed"
    bfdjson -r Director -l /dev/null /etc/bacula/bacula-fd.conf | grep 'bacula-mon'
    CHECK_RESULT $? 0 0 "test bfdjson -l failed"
    bfdjson -D /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bfdjson -D failed" 
    bfdjson -c /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bfdjson -C failed"
    bfdjson -d 21 /etc/bacula/bacula-fd.conf | grep 'bacula-fd: address_conf.c:' 
    CHECK_RESULT $? 0 0 "test bfdjson -d failed"
    bfdjson -dt -d 21 /etc/bacula/bacula-fd.conf | grep '.*-.*-.* .*:.*:.* bacula-fd:'
    CHECK_RESULT $? 0 0 "test bfdjson -dt failed"
    bfdjson -t /etc/bacula/bacula-fd.conf
    CHECK_RESULT $? 0 0 "test bfdjson -t failed"
    bfdjson -v /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "test bfdjson -v failed"
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
