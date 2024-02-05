#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/2/16
#@License   :   Mulan PSL v2
#@Desc      :   Test "rdate" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "rdate xinetd"
    sed -i 's/disable.*/disable = no/g' /etc/xinetd.d/time-stream
    systemctl start xinetd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    rdate -p "${NODE1_IPV4}" | grep "\[${NODE1_IPV4}\]"
    CHECK_RESULT $? 0 0 'Failed option: -p'
    rdate -s "${NODE1_IPV4}" 2>&1 | grep -i "[a-z]"
    CHECK_RESULT $? 0 1 'Failed option: -s'
    rdate -l "${NODE1_IPV4}" | grep rdate
    CHECK_RESULT $? 0 0 'Failed option: -l'
    rdate -u -t 1 "${NODE1_IPV4}" 2>&1 | grep "1 seconds"
    CHECK_RESULT $? 0 0 'Failed option: -t'
    rdate -a "${NODE1_IPV4}" | grep "$(date +"%Y")"
    CHECK_RESULT $? 0 0 'Failed option: -a'
    LOG_INFO "End to run testcase."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop xinetd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
