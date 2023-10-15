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
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test argus
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "argus argus-clients tar net-tools"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    argus -f -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -f failed"
    kill -9 $(pgrep -f "argus -f -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -F failed"
    kill -9 $(pgrep -f "argus -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -i lo -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    test -f package.argus
    CHECK_RESULT $? 0 0 "Check argus -i failed"
    kill -9 $(pgrep -f "argus -i lo")
    rm -f package.argus && SLEEP_WAIT 1
    argus -F ./data/argus.conf -J -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -J failed"
    kill -9 $(pgrep -f "argus -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -M 30 -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -M failed"
    kill -9 $(pgrep -f "argus -M")
    rm -f package.argus && SLEEP_WAIT 1
    argus -m -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -m failed"
    kill -9 $(pgrep -f "argus -m -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -O -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -O failed"
    kill -9 $(pgrep -f "argus -O -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -p -F ./data/argus.conf -w package.argus -d 
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -p failed"
    kill -9 $(pgrep -f "argus -p -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -P 2251 -F ./data/argus_noport.conf -w package.argus -d
    SLEEP_WAIT 10
    netstat -nap | grep 2251
    CHECK_RESULT $? 0 0 "Check argus -P failed"
    kill -9 $(pgrep -f "argus -P")
    rm -f package.argus && SLEEP_WAIT 1
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}
main "$@"
