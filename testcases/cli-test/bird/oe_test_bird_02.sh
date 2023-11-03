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
    pushd ./data
    bird -l
    SLEEP_WAIT 2
    ls | grep "bird.ctl"
    CHECK_RESULT $? 0 0 "check bird -l failed"
    kill -9 $(pgrep "bird -l")
    rm -f bird.ctl
    popd
    bird -p
    CHECK_RESULT $? 0 0 "check bird -p failed"
    bird -c ./data/bird.conf -P pid.file
    SLEEP_WAIT 2
    grep -e "[0-9]*" pid.file
    CHECK_RESULT $? 0 0 "check bird -P failed"
    kill -9 $(cat pid.file)
    rm -f pid.file
    bird -c ./data/bird.conf -R
    birdc show pro | grep "ospf1      OSPF"
    CHECK_RESULT $? 0 0 "check bird -R failed"
    kill -9 $(pgrep "bird -l")
    bird -c ./data/bird.conf -s tmp.socket
    SLEEP_WAIT 2
    ls | grep "tmp.socket"
    CHECK_RESULT $? 0 0 "check bird -s failed"
    kill -9 $(pgrep "bird -c")
    rm -f tmp.socket
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./sim_*
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
