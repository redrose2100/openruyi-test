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
# @Desc      :   Test bsdjson
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
    bsdjson -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -?"
    bsdjson -r Device /etc/bacula/bacula-sd.conf | grep '"Device":'
    CHECK_RESULT $? 0 0 "Failed option: -r"
    bsdjson -n bacula-dir /etc/bacula/bacula-sd.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    bsdjson -r Device -l /dev/null /etc/bacula/bacula-sd.conf | grep 'FileChgr2-Dev1'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    bsdjson -D /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "Failed option: -D" 
    bsdjson -c /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
    CHECK_RESULT $? 0 0 "Failed option: -C"
    bsdjson -d 21 /etc/bacula/bacula-sd.conf | grep 'bacula-sd: address_conf.c:' 
    CHECK_RESULT $? 0 0 "Failed option: -d"
    bsdjson -dt -d 21 /etc/bacula/bacula-sd.conf | grep '.*-.*-.* .*:.*:.* bacula-sd:'
    CHECK_RESULT $? 0 0 "Failed option: -dt"
    bsdjson -t /etc/bacula/bacula-sd.conf && echo $? | grep '0'
    CHECK_RESULT $? 0 0 "Failed option: -t"
    bsdjson -v /etc/bacula/bacula-sd.conf | grep '"Name": "bacula-dir"'
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
