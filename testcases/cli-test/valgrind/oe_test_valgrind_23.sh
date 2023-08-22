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
# @Date      :   2023/08/25
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
# The following command-line options are available for controlling the behavior of the DRD tool itself:
# --heap=no|yes             profile heap blocks [yes]
# --heap-admin=<size>       average admin bytes per heap block;
#                             ignored if --heap=no [8]
# --stacks=no|yes           profile stack(s) [no]
# --pages-as-heap=no|yes    profile memory at the page level [no]
# --depth=<number>          depth of contexts [30]
# --alloc-fn=<name>         specify <name> as an alloc function [empty]
# --ignore-fn=<name>        ignore heap allocations within <name> [empty]
# --threshold=<m.n>         significance threshold, as a percentage [1.0]
# --peak-inaccuracy=<m.n>   maximum peak inaccuracy, as a percentage [1.0]
# --time-unit=i|ms|B        time unit: instructions executed, milliseconds
#                             or heap bytes alloc'd/dealloc'd [i]
# --detailed-freq=<N>       every Nth snapshot should be detailed [10]
# --max-snapshots=<N>       maximum number of snapshots recorded [100]
# --massif-out-file=<file>  output file name [massif.out.%p]
##########################################################

function run_test() {
    LOG_INFO "Start to run test."

    ### massif Command-line Options ###

    ### --peak-inaccuracy=<m.n> ###
    valgrind --tool=massif --peak-inaccuracy=0.5 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --peak-inaccuracy=<m.n> No Pass"
    rm -f massif.out*
    
    ### --time-unit=i|ms|B ###
    valgrind --tool=massif --time-unit=i ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --time-unit=i|ms|B No Pass"
    rm -f massif.out*

    ### --detailed-freq=<N> ###
    valgrind --tool=massif --detailed-freq=1 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --detailed-freq=<N> No Pass"
    rm -f massif.out*

    ### --max-snapshots=<N> ###
    valgrind --tool=massif --max-snapshots=10 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --max-snapshots=<N> No Pass"
    rm -f massif.out*

    ### --massif-out-file=<file> ###
    valgrind --tool=massif --massif-out-file=massif.out ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --massif-out-file=<file> No Pass"
    rm -f massif.out*

    LOG_INFO "End to run test."
}   


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*
    rm -f massif.out*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"