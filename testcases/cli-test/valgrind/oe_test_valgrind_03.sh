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
# @Author    :   jiangchenyang
# @Contact   :   jiangcy1129@163.com
# @Date      :   2023-08-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo"

    cat > valgrind_test.cpp << EOF
#include <iostream>
#include <unistd.h>

int main() {
    std::cout << "Main process: PID = " << getpid() << std::endl;

    pid_t childPid = fork(); // Create a child process

    if (childPid == 0) {
        // This is the child process
        std::cout << "Child process: PID = " << getpid() << std::endl;
        char* const args[] = {"ls", "-l", nullptr};
        execvp("ls", args); // Replace the child process with "ls -l"
        std::cerr << "Failed to exec 'ls'" << std::endl;
        return 1;
    } else if (childPid > 0) {
        // This is the parent process
        std::cout << "Parent process: Created child with PID = " << childPid << std::endl;
    } else {
        std::cerr << "Failed to fork" << std::endl;
        return 1;
    }

    return 0;
}
EOF

cat > valgrind_test_fork.cpp << EOF
#include <iostream>
#include <unistd.h>
#include <stdio.h>
int main() {
    std::cout << "Main process: PID = " << getpid() << std::endl;

    pid_t childPid = fork(); // Create a child process

    fprintf(stdout, "This is standard output.\n");
    fprintf(stderr, "This is standard error.\n");
    if (childPid == 0) {
        // This is the child process
        std::cout << "Child process: PID = " << getpid() << std::endl;
        return 1;
    } else if (childPid > 0) {
        // This is the parent process
        std::cout << "Parent process: Created child with PID = " << childPid << std::endl;
    } else {
        std::cerr << "Failed to fork" << std::endl;
        return 1;
    }

    return 0;
}
EOF

    g++ -g -o valgrind_test valgrind_test.cpp
    g++ -g -o valgrind_test_fork valgrind_test_fork.cpp 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    ### -q -quiet ###  
    valgrind -q ./valgrind_test | grep "Command: ./valgrind_test"
    CHECK_RESULT $? 1 0 "execute valgrind -q error" 
    valgrind --quiet ./valgrind_test | grep "Command: ./valgrind_test"
    CHECK_RESULT $? 1 0 "execute valgrind -q error" 

    ### -v --verbose ###
    valgrind -v ./valgrind_test > valgrind_test.log 2>&1
    grep "Valgrind options:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind -v error" 
    valgrind --verbose ./valgrind_test > valgrind_test.log 2>&1
    grep "Valgrind options:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind -v error" 

    ### --trace-child ###
    valgrind --trace-children=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Child process:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --trace-children error" 

    ###  --trace-children-skip ###
    valgrind --trace-children=yes  --trace-children-skip=* ./valgrind_test > valgrind_test.log 2>&1
    grep "Command: /usr/bin/ls -l" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --trace-children-skip error" 

    ###  --trace-children-skip-by-arg ###
    valgrind --trace-children=yes  --trace-children-skip-by-arg=* ./valgrind_test > valgrind_test.log 2>&1
    grep "Command: /usr/bin/ls -l" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --trace-children-skip-by-arg error" 

    ### --child-silent-after-fork ###
    valgrind --child-silent-after-fork=yes ./valgrind_test_fork > valgrind_test.log 2>&1
    CHECK_RESULT "$(grep -c 'HEAP SUMMARY' valgrind_test.log)" 1 0 "execute valgrind --child-silent-after-fork error"
    
    ### --vgdb ###
    valgrind --vgdb=no --vgdb-error=1 ./valgrind_test_fork > valgrind_test.log 2>&1
    grep "TO DEBUG THIS PROCESS USING GDB: start GDB like this" valgrind_test.log
    CHECK_RESULT $? 1 0 "execute valgrind --vgdb error" 

    ### --vgdb-error ### 
    valgrind --vgdb-error=1 ./valgrind_test_fork > valgrind_test.log 2>&1
    grep "TO DEBUG THIS PROCESS USING GDB: start GDB like this" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb error" 
    
    ### --track-fds ###
    valgrind --track-fds=yes ./valgrind_test_fork > valgrind_test.log 2>&1
    grep "Open file descriptor" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --track-fds error" 

    ### --time-stamp ###
    valgrind --time-stamp=yes ./valgrind_test_fork > valgrind_test.log 2>&1
    grep -E "[0-99]+:[0-99]+:[0-99]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --time-stamp error"
    
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
