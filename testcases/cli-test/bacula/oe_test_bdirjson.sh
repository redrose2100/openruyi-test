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
# @Desc      :   Test bconsjson
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL bacula-common
    tar -zxvf test.tar.gz
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    bdirjson -v -t /etc/bacula/bacula-dir.conf | grep 'config_file='
    CHECK_RESULT $? 0 0 "Failed option: -v"
    bdirjson -v -t /etc/bacula/bacula-dir.conf | grep '/etc/bacula/bacula-dir.conf'
    CHECK_RESULT $? 0 0 "Failed option: -t"
    bdirjson -v -r JobDefs /etc/bacula/bacula-dir.conf | grep 'JobDefs'
    CHECK_RESULT $? 0 0 "Failed option: -r"
    bdirjson -v -r JobDefs -l Type /etc/bacula/bacula-dir.conf | grep 'Type'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    bdirjson -v -n Standard /etc/bacula/bacula-dir.conf | grep '"Name": "Standard"'
    CHECK_RESULT $? 0 0 "Failed option: -n"
    bdirjson -v -D /etc/bacula/bacula-dir.conf | grep '"Name": "Daemon"'
    CHECK_RESULT $? 0 0 "Failed option: -D"
    bdirjson -v -c /etc/bacula/bacula-dir.conf ./config/a.config | grep 'DefaultJob11'
    CHECK_RESULT $? 0 0 "Failed option: -c"
    bdirjson -v -d 19 /etc/bacula/bacula-dir.conf | grep 'Debug level = 19'
    CHECK_RESULT $? 0 0 "Failed option: -d"
    bdirjson -v -? /etc/bacula/bacula-dir.conf 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed option: -?"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf config/
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
