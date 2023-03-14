#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhuwenshuo
#@Contact       :   1003254035@qq.com
#@Date          :   2023/02/21
#@License   	:   Mulan PSL v2
#@Desc      	:   verification bird command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bird tar"
    extract_data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    bird -h 2>&1 | grep "Usage: bird"
    CHECK_RESULT $? 0 0 "check bird -h failed"
    bird --help 2>&1 | grep "Usage: bird"
    CHECK_RESULT $? 0 0 "check bird --help failed"
    bird --version 2>&1 | grep "BIRD version"
    CHECK_RESULT $? 0 0 "check bird --version failed" 
    bird -c ./data/bird.conf
    SLEEP_WAIT 2
    birdc show protocols | grep "ospf1      OSPF"
    CHECK_RESULT $? 0 0 "check bird -c failed"
    kill -9 $(pgrep "bird -c")
    bird -c ./data/bird.conf -d &
    SLEEP_WAIT 2
    birdc show protocols | grep "ospf1      OSPF"
    CHECK_RESULT $? 0 0 "check bird -d failed"
    kill -9 $(pgrep "bird -c")
    bird -c ./data/bird.conf -D tmp.log
    SLEEP_WAIT 2
    test -f tmp.log
    CHECK_RESULT $? 0 0 "check bird -D failed"
    kill -9 $(pgrep "bird -c")
    rm -f tmp.log
    bird -c ./data/bird.conf -f &
    SLEEP_WAIT 2
    birdc show protocols | grep "ospf1      OSPF"
    CHECK_RESULT $? 0 0 "check bird -f failed"
    kill -9 $(pgrep "bird -c")
    useradd testdemo
    bird -c ./data/bird.conf -u testdemo -g testdemo
    SLEEP_WAIT 2
    result1=$(ps -ef | grep "bird -c" | grep -v "grep")
    if [[ $result1 == testdemo* ]]; then
	echo "aa" | grep "aa"
    else
	echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check bird -u failed"
    kill -9 $(pgrep "bird -c")
    bird -c ./data/bird.conf -u testdemo -g testdemo
    SLEEP_WAIT 2
    result2=$(ps -ef | grep "bird -c" | grep -v "grep")
    if [[ $result1 == testdemo* ]]; then
	echo "aa" | grep "aa"
    else
	echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check bird -g failed"
    kill -9 $(pgrep "bird -c")
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    userdel -r testdemo
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
