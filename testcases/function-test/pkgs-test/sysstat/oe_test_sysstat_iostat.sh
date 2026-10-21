#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2022-12-15
# @License   :   Mulan PSL v2
# @Desc      :   package sysstat_iostat test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL sysstat
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    iostat  | grep avg-cpu    
    CHECK_RESULT $? 0 0 "iostat Display statistics of error CPU and disk"
    iostat  -c | grep avg-cpu   
    CHECK_RESULT $? 0 0 "iostat  -c Do not display cpu statistics" 
    iostat -d | grep Device 
    CHECK_RESULT $? 0 0 "iostat -d  Do not display disk statistics"
    iostat -k | grep Device 
    CHECK_RESULT $? 0 0 "iostat -k Does not display the number of disk requests per second in K, the default unit is block"
    iostat --help  | grep  iostat
    CHECK_RESULT $? 0 1 "iostat --help Display iostat command error help information"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
