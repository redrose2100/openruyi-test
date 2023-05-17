#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.4.6
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-atune
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "./common/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    deploy_autund
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "do test"
    atune-adm analysis > analysis_file
    CHECK_RESULT $? 0 0 "atune-adm analysis failure"
    workload=$(grep "Current System Workload Characterization" analysis_file | awk '{print $(NF-1)}')
    atune-adm list |grep -w  $workload |grep true
    CHECK_RESULT $? 0 0 "atune-adm list failure"
    atune-adm check > temp.log
    CHECK_RESULT $? 0 0 "atune-adm check failure"
    grep -i "Check finished" temp.log
    CHECK_RESULT $? 0 0 "Check finished not found"
    # Help info
    atune-adm check -h > temp.log
    grep "check system basic information" temp.log
    CHECK_RESULT $? 0 0 "check system basic information not found"
    # Extra input
    atune-adm check extra_input > temp.log
    grep "Incorrect Usage." temp.log
    CHECK_RESULT $? 0 0 "Incorrect Usage not found"
}
function post_test() {
    clean_autund
    rm -fr analysis_file temp.log
}

main $@

