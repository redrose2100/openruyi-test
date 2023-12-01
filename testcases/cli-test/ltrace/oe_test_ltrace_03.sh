# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   zu binshuo
# @Contact   	:   binshuo@isrc.iscas.ac.cn
# @Date      	:   2022-7-15
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of ltrace package
####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ltrace gcc"
    gcc ./common/tstlib.c -shared -fPIC -o libtst.so
    gcc -o tst ./common/tst.c -L. -Wl,-rpath=. -ltst
    useradd example
    passwd example <<EOF
example
example
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing."
    bash sleep 1 &
    PID="$!"
    ltrace -f -p ${PID} 2>&1 | grep "pid"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -p"
    ltrace -u example -S ls 2>&1 | grep -m 1 "SYS"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -u"
    ltrace -b bash sleep 1 2>&1 | grep -m 1 "SIGCHLD"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -b"
    ltrace --no-signals bash sleep 1 2>&1 | grep -m 1 "SIGCHLD"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --no-signals"
    ltrace -Sn 5 bash ls 2>&1 | grep -m 1 "sysinfo"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -n" 
    ltrace -S --indent=5 bash ls 2>&1 | grep -m 1 "sysinfo"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --indent" 
    ltrace -F ./common/ltrace.conf ./tst 2>&1 | grep -m 1 "func_f_lib()"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -F" 
    ltrace --config=./common/ltrace.conf ./tst 2>&1 | grep -m 1 "func_f_lib()"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace --config"
    ltrace -x 'func*' -L ./tst 2>&1 | grep "func_f_lib resumed"
    CHECK_RESULT $? 0 0 "Failed to run command: ltrace -L" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    userdel -rf example
    rm -rf tst libtst.so
    LOG_INFO "End to restore the test environment."
}

main "$@"
