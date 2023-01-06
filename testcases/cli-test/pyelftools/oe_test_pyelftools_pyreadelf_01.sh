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

    pyreadelf -v | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check pyreadelf -v  failed"

    pyreadelf --version | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check pyreadelf --version  failed"

    pyreadelf -d sample_exe64.elf | grep "Dynamic section"
    CHECK_RESULT $? 0 0 "Check pyreadelf -d sample_exe64.elf  failed"

    pyreadelf --dynamic sample_exe64.elf | grep "Dynamic section"
    CHECK_RESULT $? 0 0 "Check pyreadelf --dynamic sample_exe64.elf  failed"

    pyreadelf -H 2>&1 | grep "usage: readelf.py"
    CHECK_RESULT $? 0 0 "Check pyreadelf -H  failed"

    pyreadelf --help 2>&1 | grep "usage: readelf.py"
    CHECK_RESULT $? 0 0 "Check pyreadelf --help  failed"

    pyreadelf -h sample_exe64.elf | grep "Class"
    CHECK_RESULT $? 0 0 "Check pyreadelf -h sample_exe64.elf  failed"

    pyreadelf --file-header sample_exe64.elf | grep "Class"
    CHECK_RESULT $? 0 0 "Check pyreadelf --file-header sample_exe64.elf  failed"

    pyreadelf -l sample_exe64.elf | grep "PHDR"
    CHECK_RESULT $? 0 0 "Check pyreadelf -l sample_exe64.elf  failed"

    pyreadelf --program-headers sample_exe64.elf | grep "PHDR"
    CHECK_RESULT $? 0 0 "Check pyreadelf --program-headers sample_exe64.elf  failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf sample_exe64.elf
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
