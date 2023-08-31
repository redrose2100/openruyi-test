#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.


# #############################################
# @Author    :   cuikeyu
# @Contact   :   cky2536184321@163.com
# @Date      :   2023/08/27
# @License   :   Mulan PSL v2
# @Desc      :   Test valgrind
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo"
    # systemctl restart sshd.service

    cat > valgrind_test.cpp << EOF
#include <iostream>

void func2(int value) {
    std::cout << "Inside func2: " << value << std::endl;
}

void func1(int value) {
    std::cout << "Inside func1" << std::endl;
    func2(value);
}

int main() {
    int num = 42;
    std::cout << "Inside main" << std::endl;
    func1(num);
    return 0;
}
EOF
    g++ -o valgrind_test valgrind_test.cpp -pthread -lstdc++
    LOG_INFO "End to prepare the test environment"
}
##########################################################
#Usage: valgrind [options] prog-and-args 
# DHAT-specific command-line options are:
# --dhat-out-file=<file>                                Write the profile data to file rather than to the default output file, dhat.out.<pid>.
# --mode=<heap|copy|ad-hoc> [default: heap]             The profiling mode: heap profiling, copy profiling, or ad hoc profiling.

# Lackey-specific command-line options are:
# --basic-counts=<no|yes> [default: yes]                count instructions, jumps, etc. [yes]
# --detailed-counts=<no|yes> [default: no]              count loads, stores and alu ops [no]
# --trace-mem=<no|yes> [default: no]                    trace all loads and stores [no]
# --trace-superblocks=<no|yes> [default: no]            trace all superblock entries [no]
# --fnname=<name> [default: main]                       count calls to <name> (only used if --basic-count=yes)  [main]

# BBV-specific command-line options are:
# --bb-out-file=<name> [default: bb.out.%p]             This option selects the name of the basic block vector file. 
# --pc-out-file=<name> [default: pc.out.%p]             This option selects the name of the PC file.
# --interval-size=<number> [default: 100000000]         This option selects the size of the interval to use. 
# --instr-count-only [default: no]                      This option tells the tool to only display instruction count totals, and to not generate the actual basic block vector file.
##########################################################

function run_test() {
    LOG_INFO "Start to run test."

    ### --dhat-out-file=<file> ###
    # valgrind --tool=dhat --dhat-out-file=dhat.out ./valgrind_test && find . -type f -name 'dhat.out*'
    # CHECK_RESULT $? 0 0 "L$LINENO: --dhat-out-file=<file> No Pass"
    # rm -f massif.out*

    ### --mode=<heap|copy|ad-hoc> [default: heap] ###
    # valgrind --tool=massif --heap-admin=6 ./valgrind_test && find . -type f -name 'massif.out*'
    # CHECK_RESULT $? 0 0 "L$LINENO: --mode=<heap|copy|ad-hoc> [default: heap] No Pass"
    # rm -f massif.out*

    ### --basic-counts=<no|yes> [default: yes] ###
    valgrind --tool=lackey --basic-counts=no ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --basic-counts=<no|yes> [default: yes] No Pass"

    ### --detailed-counts=<no|yes> [default: no] ###
    valgrind --tool=lackey --detailed-counts=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --detailed-counts=<no|yes> [default: no] No Pass"

    ### --trace-mem=<no|yes> [default: no] ###
    valgrind --tool=lackey --trace-mem=no ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-mem=<no|yes> [default: no] No Pass"

    ### --trace-superblocks=<no|yes> [default: no] ###
    valgrind --tool=lackey --trace-superblocks=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-superblocks=<no|yes> [default: no] No Pass"

    ### --fnname=<name> [default: main] ###
    valgrind --tool=lackey --fnname=func1 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --fnname=<name> [default: main] No Pass"

    ### --bb-out-file=<name> [default: bb.out.%p] ###
    valgrind --tool=exp-bbv --bb-out-file=bb.out ./valgrind_test && find . -type f -name 'bb.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --bb-out-file=<name> [default: bb.out.%p] No Pass"
    rm -f bb.out*

    ### --pc-out-file=<name> [default: pc.out.%p] ###
    valgrind --tool=exp-bbv --pc-out-file=pc.out ./valgrind_test && find . -type f -name 'pc.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --pc-out-file=<name> [default: pc.out.%p] No Pass"
    rm -f pc.out*

    ### --interval-size=<number> [default: 100000000] ###
    valgrind --tool=exp-bbv --interval-size=50000000 ./valgrind_test && find . -type f -name 'bb.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --interval-size=<number> [default: 100000000] No Pass"
    rm -f bb.out*

    ### --instr-count-only [default: no] ###
    valgrind --tool=exp-bbv --instr-count-only=yes ./valgrind_test && find . -type f -name 'bb.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --instr-count-only [default: no] No Pass"
    rm -f bb.out*
    
    LOG_INFO "End to run test."
}   


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*

    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"