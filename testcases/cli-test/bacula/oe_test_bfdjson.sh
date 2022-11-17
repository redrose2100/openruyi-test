#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test bfdjson
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "bacula-client mysql5-server bacula-common"
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    bfdjson -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -?"
    bfdjson -r Director /etc/bacula/bacula-fd.conf | grep '"Director":'
    CHECK_RESULT $? 0 0 "Failed option: -r"
    bfdjson -n bacula-dir /etc/bacula/bacula-fd.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    bfdjson -r Director -l /dev/null /etc/bacula/bacula-fd.conf | grep 'bacula-mon'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    bfdjson -D /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "Failed option: -D" 
    bfdjson -c /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "Failed option: -C"
    bfdjson -d 21 /etc/bacula/bacula-fd.conf | grep 'bacula-fd: address_conf.c:' 
    CHECK_RESULT $? 0 0 "Failed option: -d"
    bfdjson -dt -d 21 /etc/bacula/bacula-fd.conf | grep '.*-.*-.* .*:.*:.* bacula-fd:'
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    bfdjson -t /etc/bacula/bacula-fd.conf && echo $? | grep '0'
    CHECK_RESULT $? 0 0 "Failed option: -t"
    bfdjson -v /etc/bacula/bacula-fd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "Failed option: -v"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf config/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
