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
# @Author    :   fuyh2020
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2022-09-19
# @License   :   Mulan PSL v2
# @Desc      :   Command test ksh
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL ksh
    LOG_INFO "End of environmental preparation!"

}

function run_test() {
    LOG_INFO "Start to run test."

    ksh -c 'echo "ksh is working"' | grep -q "ksh is working"
    CHECK_RESULT $? 0 0 "ksh shell failed to start"
    ksh -c 'ls /' | grep -q "bin"
    CHECK_RESULT $? 0 0 "ksh failed to execute basic shell command"
    ksh -c 'export MY_VAR="Hello, ksh"; echo $MY_VAR'  | grep -q "Hello, ksh"
    CHECK_RESULT $? 0 0 "ksh failed to handle environment variable"

    chmod 750 ./testfile
    ./testfile > tmp.log
    CHECK_RESULT $? 0 0 "excute testfile error"
    grep "hello world" tmp.log
    CHECK_RESULT $? 0 0 "query msg error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp.log
    DNF_REMOVE  "$@"
    LOG_INFO "Finish environment cleanup!"

}
main "$@"
