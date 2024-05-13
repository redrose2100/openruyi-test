#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-03-26
#@License   	:   Mulan PSL v2
#@Desc      	:   test renice
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare environment."
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    p_nice1=`ps -l |awk '{print $8}' | awk 'NR==2'`
    pid=`ps -l |awk '{print $4}' | awk 'NR==2'`
    nice_list=(7 18)
    for nice0 in "${nice_list[@]}";do
        renice -n ${nice0} -p ${pid}
        p_nice2=`ps -l |awk '{print $8}' | awk 'NR==2'`
        test "${p_nice2}" == "${nice0}"
        CHECK_RESULT $? 0 0 "test renice nice fail"
    done
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    renice -n ${p_nice1} -p ${pid}
    LOG_INFO "Finish restoring environment."
}

main "$@"



