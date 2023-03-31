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
    DNF_INSTALL "argus argus-clients tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    argus -R -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -R failed"
    kill -9 $(pgrep -f "argus -R -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -s 10 -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -s failed"
    kill -9 $(pgrep -f "argus -s")
    rm -f package.argus && SLEEP_WAIT 1
    argus -S 3600 -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -S failed"
    kill -9 $(pgrep -f "argus -S")
    rm -f package.argus && SLEEP_WAIT 1
    argus -t -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -t failed"
    kill -9 $(pgrep -f "argus -t")
    rm -f package.argus && SLEEP_WAIT 1
    argus -u root -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -u failed"
    kill -9 $(pgrep -f "argus -u")
    rm -f package.argus && SLEEP_WAIT 1
    argus -g root -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -g failed"
    kill -9 $(pgrep -f "argus -g")
    rm -f package.argus && SLEEP_WAIT 1
    argus -U 10 -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -U failed"
    kill -9 $(pgrep -f "argus -U")
    rm -f package.argus && SLEEP_WAIT 1
    argus -X -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -X failed"
    kill -9 $(pgrep -f "argus -X")
    rm -f package.argus && SLEEP_WAIT 1
    argus -Z -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -Z failed"
    kill -9 $(pgrep -f "argus -Z")
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
