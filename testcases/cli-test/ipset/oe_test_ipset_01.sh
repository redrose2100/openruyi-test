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
# @Author    :   kouhuiying
# @Contact   :   kouhuiying@uniontech.com
# @Date      :   2022/12/15
# @License   :   Mulan PSL v2
# @Desc      :   The named set create/add/rename/set/swap/flush function
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL ipset
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    local random=$(echo $RANDOM)
    ipset create aa${random} hash:net maxelem 1000000
    ipset add aa${random} 10.7.10.10
    ipset test aa${random} 10.7.10.10
    CHECK_RESULT $? 0 0 "Add aa${random} entry to the named set fail"
    ipset create bb${random} hash:net maxelem 1000000
    ipset add bb${random} 10.7.10.11
    ipset list bb${random} | grep "10.7.10.11"
    CHECK_RESULT $? 0 0 "Add bb${random} entry to the named set fail"
    ipset rename aa${random} cc${random}
    CHECK_RESULT $? 0 0 "Rename the named set fail"
    ipset list cc${random} | grep "10.7.10.10"
    CHECK_RESULT $? 0 0 "Check the named entry set fail"
    ipset swap cc${random} bb${random}
    CHECK_RESULT $? 0 0 "Swap the named set fail"
    ipset list cc${random} | grep "10.7.10.11"
    CHECK_RESULT $? 0 0 "Check the named entry set fail after swap"
    ipset list bb${random} | grep "10.7.10.10"
    CHECK_RESULT $? 0 0 "Check the named entry set fail after swap"
    ipset flush
    ipset list cc${random} | grep "10.7.10.11"
    CHECK_RESULT $? 1 0 "Flus the named set fail"
    ipset list bb${random} | grep "10.7.10.10"
    CHECK_RESULT $? 1 0 "Flus the named set fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
