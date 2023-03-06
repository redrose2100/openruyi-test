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
    nohup sanlock daemon -D -Q 0 -R 1 -H 60 -L -1 -S 3 -U sanlock -G sanlock -t 4 -g 20 -w 0 -h 1 -l 2 -b 12 -e test >./info.log 2>&1 &
    SLEEP_WAIT  10
    sanlock client init -s test:0:./dev:0
    sanlock client init -r test:testres:./res:0
    sanlock client format -x test:./res:0 -Z 512 -A 1M
    sanlock client create -x test:./res:0 -e testres1
    sanlock client add_lockspace -s test:1:./dev:0
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sanlock direct lookup -x test:./res:0 -e testres1:0 | grep "lookup done"
    CHECK_RESULT $? 0 0 "Check sanlock direct lookup -x -e failed"

    sanlock direct init -s test:0:./dev:0 | grep "init done 0"
    CHECK_RESULT $? 0 0 "Check sanlock direct init -s test:0:./dev:0 failed"

    sanlock direct init -r test:testres:./res:0 -Z 512 -A 1M | grep "init done 0"
    CHECK_RESULT $? 0 0 "Check sanlock direct init -r test:testres:./res:0 -Z 512 -A 1M failed"

    sanlock direct read_leader -r test:testres:./res:0 -a 1 -o 1 -Z 512 -A 1M | grep "resource_name testres"
    CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -r test:testres:./res:0 -a 1 -o 1 -Z 512 -A 1M failed"

    sanlock direct read_leader -s test:1:./dev:0 | grep "space_name test"
    CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -s test:1:./dev:0 failed"

    sanlock direct read_leader -r test:testres:./res:0 | grep "resource_name testres"
    CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -r test:testres:./res:0 failed"

    sanlock direct dump ./res:0 | grep "testres"
    CHECK_RESULT $? 0 0 "Check sanlock direct dump ./res:0 failed"

    sanlock direct format -x test:./res:0 -Z 512 -A 1M | grep "format done 0"
    CHECK_RESULT $? 0 0 "Check sanlock direct format -x test:./res:0 -Z 512 -A 1M failed"

    sanlock direct update -x test:./res:0 -e testres1:0 -z 0 | grep "update done"
    CHECK_RESULT $? 0 0 "Check sanlock direct update -x -e -z failed"

    sanlock direct rebuild -x test:./res:0 | grep "rebuild done 0"
    CHECK_RESULT $? 0 0 "Check sanlock direct rebuild -x failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pgrep -f "sanlock daemon")
    cd ..
    rm -rf sanlocktest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
