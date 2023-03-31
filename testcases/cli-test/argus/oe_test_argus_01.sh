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
    argus -h | grep "usage: argus"
    CHECK_RESULT $? 0 0 "Check argus -h failed"
    argus -r data/test.pcap
    CHECK_RESULT $? 0 0 "Check argus -r failed"
    argus -r ./data/test.pcap -w package.argus
    ra -r package.argus | grep "radius"
    CHECK_RESULT $? 0 0 "Check argus -w failed"
    rm -f package.argus && SLEEP_WAIT 1
    argus -A -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -A failed"
    kill -9 $(pgrep -f "argus -A -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -b -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -b failed"
    kill -9 $(pgrep -f "argus -b -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -B 127.0.0.1 -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -B failed"
    kill -9 $(pgrep -f "argus -B")
    rm -f package.argus && SLEEP_WAIT 1
    mkdir tmp
    rootpath=$(pwd)
    argus -c ${rootpath}/tmp -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    test -f ./tmp/package.argus
    CHECK_RESULT $? 0 0 "Check argus -c failed"
    kill -9 $(pgrep -f "argus -c")
    rm -rf tmp && SLEEP_WAIT 1
    argus -C -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -C failed"
    kill -9 $(pgrep -f "argus -C -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -d failed"
    kill -9 $(pgrep -f "argus -F")
    rm -f package.argus && SLEEP_WAIT 1
    argus -e `hostname` -F ./data/argus.conf -w package.argus -d
    SLEEP_WAIT 10
    ra -r package.argus  | grep "StartTime"
    CHECK_RESULT $? 0 0 "Check argus -e failed"
    kill -9 $(pgrep -f "argus -e")
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
