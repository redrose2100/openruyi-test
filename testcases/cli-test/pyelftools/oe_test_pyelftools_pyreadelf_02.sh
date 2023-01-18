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

    pyreadelf --segments sample_exe64.elf | grep "PHDR"
    CHECK_RESULT $? 0 0 "Check pyreadelf --segments sample_exe64.elf  failed"

    pyreadelf -S sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf -S sample_exe64.elf  failed"

    pyreadelf --section-headers sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf --section-headers sample_exe64.elf  failed"

    pyreadelf --sections sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf --sections sample_exe64.elf  failed"

    pyreadelf -e -A sample_exe64.elf | grep "PHDR"
    CHECK_RESULT $? 0 0 "Check pyreadelf -e -A  sample_exe64.elf  failed"

    pyreadelf --headers --arch-specific sample_exe64.elf | grep "PHDR"
    CHECK_RESULT $? 0 0 "Check pyreadelf --headers  --arch-specific sample_exe64.elf   failed"

    pyreadelf -s sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf -s sample_exe64.elf  failed"

    pyreadelf --symbols sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf --symbols sample_exe64.elf  failed"

    pyreadelf --syms sample_exe64.elf | grep "init"
    CHECK_RESULT $? 0 0 "Check pyreadelf --syms sample_exe64.elf  failed"

    pyreadelf -n sample_exe64.elf | grep "GNU"
    CHECK_RESULT $? 0 0 "Check pyreadelf -n sample_exe64.elf  failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf sample_exe64.elf
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
