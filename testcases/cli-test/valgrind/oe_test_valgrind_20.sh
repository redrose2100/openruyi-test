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

    ### --check-stack-var=<yes|no> ###
    valgrind --tool=drd --check-stack-var=no ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --check-stack-var No Pass"

    ### --exclusive-threshold=<n> ###
    valgrind --tool=drd --exclusive-threshold=5 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --exclusive-threshold No Pass"
    
    ### --first-race-only=<yes|no> ###
    valgrind --tool=drd --first-race-only=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --first-race-only No Pass"

    ### --free-is-write=yes|no ###
    valgrind --tool=drd --free-is-write=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --free-is-write No Pass"

    ### --join-list-vol=<n> ###
    valgrind --tool=drd --join-list-vol=1 ./valgrind_test 
    CHECK_RESULT $? 0 0 "L$LINENO: --join-list-vol No Pass"

    ### --report-signal-unlocked=yes|no ###
    valgrind --tool=drd --report-signal-unlocked=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --report-signal-unlocked No Pass"

    ### --segment-merging=<yes|no> ###
    valgrind --tool=drd --segment-merging=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --segment-merging No Pass"

    ### --segment-merging-interval=<n> ###
    valgrind --tool=drd --segment-merging-interval=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --segment-merging-interval No Pass"

    ### --shared-threshold=<n> ###
    valgrind --tool=drd --shared-threshold=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --shared-threshold No Pass"

    ### --show-confl-seg=<yes|no> ###
    valgrind --tool=drd --show-confl-seg=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "L$LINENO: --show-confl-seg No Pass"

    LOG_INFO "End to run test."
}   


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"