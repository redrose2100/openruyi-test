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
# @Author    :   lixiang
# @Contact   :   lixiang2@cmss.chinamobile.com
# @Date      :   2023.07.25
# @License   :   Mulan PSL v2
# @Desc      :   DF command test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    dir="test"
    mkdir -p ${dir}
    touch ${dir}/file1
    cur_lang=$(echo $LANG)
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    df -h ${dir} | grep ${dir}
    CHECK_RESULT $? 0 0 "Failed to view disk usage of ${dir}"
    df -hT ${dir} | grep ${dir}
    CHECK_RESULT $? 0 0 "Failed to view disk usage with file system type of ${dir}"
    df -h --total | grep 'total'
    CHECK_RESULT $? 0 0 "Failed to view total disk usage"
    df --help | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Failed to view the df command help manual"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${dir}
    rm -f ${dir}/file1
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main $@
