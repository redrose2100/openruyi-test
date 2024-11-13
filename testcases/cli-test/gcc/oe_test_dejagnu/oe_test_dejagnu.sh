#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################################################
# @Author    :   xiongzhou
# @Contact   :   xiongzhou4@huawei.com
# @Date      :   2024/07/27
# @License   :   Mulan PSL v2
# @Desc      :   DejaGnu test of all self-developed features in openEuler GCC
# #############################################################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

exec_dir="gcc-test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc gcc-c++ gcc-gfortran dejagnu"
    rm -rf "${exec_dir}"
    mkdir "${exec_dir}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd "${exec_dir}" || exit

    LOG_INFO "Running tests..."
    gcc_version=$(gcc -dumpversion)
    if [[ "${gcc_version}" == "10.3.1" ]]; then
        runtest --tool gcc --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc10
        runtest --tool g++ --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc10
        runtest --tool gfortran --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc10
    elif [[ "${gcc_version}" == "12" ]]; then
        runtest --tool gcc --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc12
        runtest --tool g++ --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc12
        runtest --tool gfortran --srcdir "${OET_PATH}"/testcases/cli-test/gcc/oe_test_dejagnu/testsuite-gcc12
    else
        LOG_WARN "GCC version doesn't match, please use openEuler GCC 10.3.1 or 12.3.1 ."
        return
    fi

    LOG_INFO "Checking results..."
    grep -E '# of (unexpected|unresolved|unsupported)' ./*.sum > /dev/null
    CHECK_RESULT $? 1 0 "Some tests failed, please check."

    cd - || exit
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${exec_dir}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
