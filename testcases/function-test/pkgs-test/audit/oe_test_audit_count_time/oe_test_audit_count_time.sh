#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Jevons
#@Contact   	:   1557927445@qq.com
#@Date      	:   2021-04-16 11:39:43
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   collect overall user time statistics
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "audit"
    LOG_INFO "End of environmental preparation!"
}


function run_test()
{
    LOG_INFO "Start to run test."
    systemctl restart auditd
    aureport -u -i --summary > /tmp/count_time.out 2> /tmp/count_time.err
    grep "User Summary Report" /tmp/count_time.out
    CHECK_RESULT $? 0 0 "grep failed"
    grep -qE "No such file or directory|Could not open dir" /tmp/count_time.err
    CHECK_RESULT $? 0 1 "the audit log is not available"
    rm -f /tmp/count_time.out /tmp/count_time.err
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
