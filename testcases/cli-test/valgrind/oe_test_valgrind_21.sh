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
    gcc -o valgrind_test valgrind_test.cpp -pthread
    LOG_INFO "End to prepare the test environment"
}
##########################################################
#Usage: valgrind [options] prog-and-args 
# The following command-line options are available for controlling the behavior of the DRD tool itself:
#   --check-stack-var=<yes|no>      Whether or not to report data races on stack variables [no].
#   --exclusive-threshold=<n>     
#   --first-race-only=yes|no                       
#   --free-is-write=yes|no                  
#   --join-list-vol=<n>               
#   --report-signal-unlocked=yes|no   
#   --segment-merging=yes|no 
#   --segment-merging-interval=<n>
#   --shared-threshold=<n>
#   --show-confl-seg=yes|no
#   --show-stack-usage=yes|no
#   --ignore-thread-creation=yes|no

#  drd options for monitoring process behavior:
#   --ptrace-addr=<address>[+<length>]
#   --trace-addr=<address>
#   --trace-alloc=yes|no
#   --trace-barrier=yes|no
#   --trace-cond=yes|no
#   --trace-fork-join=yes|no
#   --trace-hb=yes|no
#   --trace-mutex=yes|no
#   --trace-rwlock=yes|no
#   --trace-semaphore=yes|no
##########################################################

function run_test() {
    LOG_INFO "Start to run test."

    ### --show-stack-usage=<yes|no> ###
    valgrind --tool=drd --show-stack-usage=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --show-stack-usage No Pass"

    ### --ignore-thread-creation=<yes|no> ###
    valgrind --tool=drd --ignore-thread-creation=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --ignore-thread-creation No Pass"

    ### --ptrace-addr=<address>[+<length>] ###
    valgrind --tool=drd --ptrace-addr=0x12345678+4 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --ptrace-addr No Pass"

    ### --trace-addr=<address> ###
    valgrind --tool=drd --trace-addr=0x12345678 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-addr No Pass"

    ### --trace-alloc=<yes|no> ###
    valgrind --tool=drd --trace-alloc=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-alloc No Pass"

    ### --trace-barrier=<yes|no> ###
    valgrind --tool=drd --trace-barrier=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-barrier No Pass"

    ### --trace-cond=<yes|no> ###
    valgrind --tool=drd --trace-cond=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-cond No Pass"

    ### --trace-fork-join=<yes|no> ###
    valgrind --tool=drd --trace-fork-join=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-fork-join No Pass"

    ### --trace-hb=<yes|no> ###
    valgrind --tool=drd --trace-hb=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-hb No Pass"

    ### --trace-mutex=<yes|no> ###
    valgrind --tool=drd --trace-mutex=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --trace-mutex No Pass"

    LOG_INFO "End to run test."
}   


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"