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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of ninja-build command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL python3-pyelftools
    cp ./common/sample_exe64.elf ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    pyreadelf --notes sample_exe64.elf | grep "GNU"
    CHECK_RESULT $? 0 0 "Check pyreadelf --notes sample_exe64.elf  failed"

    pyreadelf -r sample_exe64.elf | grep "gmon_start"
    CHECK_RESULT $? 0 0 "Check pyreadelf -r sample_exe64.elf  failed"

    pyreadelf --relocs sample_exe64.elf | grep "gmon_start"
    CHECK_RESULT $? 0 0 "Check pyreadelf --relocs sample_exe64.elf  failed"

    pyreadelf -x 1 sample_exe64.elf | grep "Hex dump"
    CHECK_RESULT $? 0 0 "Check pyreadelf -x 1 sample_exe64.elf  failed"

    pyreadelf --hex-dump 1 sample_exe64.elf | grep "Hex dump"
    CHECK_RESULT $? 0 0 "Check pyreadelf --hex-dump 1 sample_exe64.elf  failed"

    pyreadelf -p 1 sample_exe64.elf | grep "String dump"
    CHECK_RESULT $? 0 0 "Check pyreadelf -p 1 sample_exe64.elf  failed"

    pyreadelf --string-dump 1 sample_exe64.elf | grep "String dump"
    CHECK_RESULT $? 0 0 "Check pyreadelf --string-dump 1 sample_exe64.elf  failed"

    pyreadelf -V sample_exe64.elf | grep "Name"
    CHECK_RESULT $? 0 0 "Check pyreadelf -V sample_exe64.elf  failed"

    pyreadelf --version-info sample_exe64.elf | grep "Name"
    CHECK_RESULT $? 0 0 "Check pyreadelf --version-info sample_exe64.elf  failed"

    pyreadelf --debug-dump info sample_exe64.elf | grep "DW_TAG_pointer_type"
    CHECK_RESULT $? 0 0 "Check pyreadelf --debug-dump info sample_exe64.elf  failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf sample_exe64.elf
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
