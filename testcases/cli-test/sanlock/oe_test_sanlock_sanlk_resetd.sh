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
    DNF_INSTALL "sanlock sanlk-reset"
    mkdir sanlocktest
    cd sanlocktest
    dd if=/dev/zero bs=1048576 count=1 of=./dev
    dd if=/dev/zero bs=1048576 count=1 of=./res
    chown sanlock:sanlock ./*
    nohup sanlock daemon -D -Q 0 -R 1 -H 60 -L -1 -S 3 -U sanlock -G sanlock -t 4 -g 20 -w 0 -h 1 -l 2 -b 12 -e test > ./info.log 2>&1 &
    SLEEP_WAIT  10
    sanlock direct init -s  test:0:./dev:0
    sanlock direct init -r  test:testres:./res:0
    sanlock client add_lockspace -s test:1:./dev:0
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sanlk-resetd -h | fgrep "sanlk-resetd [options]"
    CHECK_RESULT $? 0 0 "Check sanlk-resetd -h failed"

    sanlk-resetd --help | fgrep "sanlk-resetd [options]"
    CHECK_RESULT $? 0 0 "Check sanlk-resetd --help failed"

    sanlk-resetd -V | grep "sanlk-resetd version: [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check sanlk-resetd -V failed"

    sanlk-resetd --version | grep "sanlk-resetd version: [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check sanlk-resetd --version failed"

    nohup sanlk-resetd -f -D -w 0 -b 0 -R 0 -d 2 test > ./info1.log 2>&1 &
    SLEEP_WAIT  10
    grep "reg_event 0 fd 6 ls test" ./info1.log
    CHECK_RESULT $? 0 0 "Check sanlk-resetd -f -D -w -b -R -d failed"

    nohup sanlk-resetd --foreground --daemon-debug --watchdog 0 --sysrq-reboot 0 --resource-mode 0 --sysrq-delay 2 test > ./info2.log 2>&1 &
    SLEEP_WAIT  10
    grep "reg_event 0 fd 6 ls test" ./info2.log
    CHECK_RESULT $? 0 0 "Check sanlk-resetd --foreground --daemon-debug --watchdog --sysrq-reboot --resource-mode --sysrq-delay failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pgrep -f "sanlock daemon")
    kill -9 $(pgrep -f "sanlk-resetd -f -D")
    kill -9 $(pgrep -f "sanlk-resetd --foreground")
    cd ..
    rm -rf sanlocktest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
