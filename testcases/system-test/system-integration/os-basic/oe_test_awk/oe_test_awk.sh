#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei1
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2022-09-27
# @License   :   Mulan PSL v2
# @Desc      :   Command test-awk 
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    awk  -F ':'  '{print $1}' /etc/passwd |grep root
    CHECK_RESULT $? 0 0  "check root result fail"
    awk '{print$1}' /proc/cpuinfo |grep -iE "cpu|hart"
    CHECK_RESULT $? 0 0  "check cpuid result fail"
    awk --help | grep "Usage: awk"
    CHECK_RESULT $? 0 0 "check Tail's help manual fail"
    awk -F: '{print NF}' /etc/passwd
    CHECK_RESULT $? 0 0  "check count the number of rows per row after segmentation result fail"
    awk -F: '{print $NF}' /etc/passwd
    CHECK_RESULT $? 0 0  "check the last column of each row after segmentation result fail"
    awk '{print NR}' /etc/passwd
    CHECK_RESULT $? 0 0  "check print line numbers result fail"
    awk 'NR==1 {print $0}' /etc/passwd
    CHECK_RESULT $? 0 0  "check specify line content result fail"
    awk 'BEGIN{FS=":"}{print $NF, $1}' /etc/passwd
    CHECK_RESULT $? 0 0  "check the last and first columns of each row after colon splitting result fail"
    awk -F: 'BEGIN{OFS=" >>> "}{print $NF, $1}' /etc/passwd
    CHECK_RESULT $? 0 0  "check the printed delimiters result fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"


