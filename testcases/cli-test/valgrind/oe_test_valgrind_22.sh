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

    cat > valgrind_test_thread.cpp << EOF
#include <stdio.h>
#include <pthread.h>

int shared_variable = 0;

void *thread_function(void *arg) {
    for (int i = 0; i < 10000; i++) {
        shared_variable++;
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    
    pthread_create(&thread1, NULL, thread_function, NULL);
    pthread_create(&thread2, NULL, thread_function, NULL);
    
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("Final value of shared_variable: %d\n", shared_variable);
    
    return 0;
}
EOF

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

    gcc -o valgrind_test_thread valgrind_test_thread.cpp -pthread
}
##########################################################
#Usage: valgrind [options] prog-and-args 
#   --trace-rwlock=yes|no
#   --trace-semaphore=yes|no
##########################################################

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

    ### --trace-rwlock=<yes|no> ###
    valgrind --tool=drd --trace-rwlock=yes ./valgrind_test_thread
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-rwlock No Pass"

    ### --trace-semaphore=<yes|no> ###
    valgrind --tool=drd --trace-semaphore=yes ./valgrind_test_thread
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-semaphore No Pass"

    ### massif Command-line Options ###

    ### --heap=no|yes ###
    valgrind --tool=massif --heap=no ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --heap=no|yes No Pass"
    rm -f massif.out*

    ### --heap-admin=<size> ###
    valgrind --tool=massif --heap-admin=6 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --heap-admin=<size> No Pass"
    rm -f massif.out*

    ### --stacks=no|yes ###
    valgrind --tool=massif --stacks=yes ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --stacks=no|yes No Pass"
    rm -f massif.out*

    ### --pages-as-heap=no|yes ###
    valgrind --tool=massif --pages-as-heap=yes ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --pages-as-heap=no|yes No Pass"
    rm -f massif.out*

    ### --depth=<number> ###
    valgrind --tool=massif --depth=10 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --depth=<number> No Pass"
    rm -f massif.out*

    ### --alloc-fn=<name> ###
    valgrind --tool=massif --alloc-fn=func1 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --alloc-fn=<name> No Pass"
    rm -f massif.out*

    ### --ignore-fn=<name> ###
    valgrind --tool=massif --ignore-fn=func1 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: --ignore-fn=<name> No Pass"
    rm -f massif.out*

    ### --threshold=<m.n> ###
    valgrind --tool=massif --threshold=0.5 ./valgrind_test && find . -type f -name 'massif.out*'
    CHECK_RESULT $? 0 0 "L$LINENO: ---threshold=<m.n> No Pass"
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