#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-07-31
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    jjs -help 2>&1 | grep options
    CHECK_RESULT $? 0 0 "jjs -help failed"
    expect -c "
    log_file testlog1
    spawn jjs -strict
    set timeout 60
    expect \"jjs>\"
    send \"a=10\r\"
    expect \"jjs>\"
    send \"exit()\r\"
    expect eof
"
    cat < testlog1 | grep -i "is not defined"
    CHECK_RESULT $? 0 0 "testlog1 is defined"

    jmap -h 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "jmap -h failed"
    jps | grep '[0-9] Jps'
    CHECK_RESULT $? 0 0 "jps -version failed"
    jps -help 2>&1 | grep usage
    CHECK_RESULT $? 0 0 "jps -help failed"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf testlog*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
