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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of sanlock command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL sanlock
    mkdir sanlocktest
    cd sanlocktest
    dd if=/dev/zero bs=1048576 count=1 of=./dev
    dd if=/dev/zero bs=1048576 count=1 of=./res
    chown sanlock:sanlock ./*
    nohup sanlock daemon -D -Q 0 -R 1 -H 60 -L -1 -S 3 -U sanlock -G sanlock -t 4 -g 20 -w 0 -h 1 -l 2 -b 12 -e test > ./info.log 2>&1 &
    SLEEP_WAIT  10
    sanlock client init -s test:0:./dev:0
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sanlock client init -r test:testres:./res:0 | grep "init done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client init -r failed"

    sanlock client add_lockspace -s test:1:./dev:0 | grep "add_lockspace done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client add_lockspace -s failed"

    sanlock client command -r test:testres:./res:0 -c ./res 1 | grep "acquire done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client command -r failed"

    sanlock client set_config -s test:0:./dev:0 -u 0 -O 1 | grep "set_config done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client set_config -s -u -O failed"

    sanlock client log_dump | grep "sanlock daemon started"
    CHECK_RESULT $? 0 0 "Check sanlock client log_dump failed"

    sanlock client shutdown -f 0 -w 0 | grep "shutdown done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client shutdown -f -w failed"

    sanlock client read -s test:0:./dev:0 | grep "s test:1:./dev:0"
    CHECK_RESULT $? 0 0 "Check sanlock client read -s failed"

    nohup sanlock client command -r test:testres:./res:0 >./info1.log 2>&1 &
    SLEEP_WAIT  10
    sanlock client init -r test:testres1:./res:0
    sanlock client acquire -r test:testres1:./res:0 -p $(pgrep -f "sanlock client command") | grep "acquire done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client acquire -r -p failed"

    sanlock client inq_lockspace -s test:0:./dev:0 | grep "inq_lockspace done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client inq_lockspace -s failed"

    sanlock client rem_lockspace -s test:0:./dev:0 | grep "rem_lockspace done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client rem_lockspace -s failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pgrep -f "sanlock daemon")
    kill -9 $(pgrep -f "sanlock client command")
    cd ..
    rm -rf sanlocktest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
