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
# @Author    :   Yihao Lin;Songsong Wang
# @Contact   :   yihaolin01@foxmail.com
# @Date      :   2022/03/13
# @License   :   Mulan PSL v2
# @Desc      :   Test pam_tally
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    touch /var/log/faillog
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    #pam_tally test
    pam_tally --user ${NODE1_USER} |grep "User"
    CHECK_RESULT $? 0 0 "failed to tally test"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    test -f /var/log/faillog && rm -rf /var/log/faillog  
    LOG_INFO "End to restore the test environment."
}

main "$@"
