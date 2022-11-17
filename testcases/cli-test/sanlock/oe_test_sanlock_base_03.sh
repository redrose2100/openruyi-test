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
    sanlock client add_lockspace -s test:1:./dev:0
    nohup sanlock client command -r test:testres:./res:0 >./info1.log 2>&1 &
    SLEEP_WAIT  10
    sanlock client init -r test:testres1:./res:0
    sanlock client acquire -r test:testres1:./res:0 -p $(pgrep -f "sanlock client command")
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sanlock client release -r test:testres1:./res:0 -p $(pgrep -f "sanlock client command") | grep "release done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client release -r -p failed"

    sanlock client inquire -p $(pgrep -f "sanlock client command") | grep "test:testres:./res:0:1"
    CHECK_RESULT $? 0 0 "Check sanlock client inquire -p failed"

    sanlock client request -r test:testres:./res:0 -f res:0 | grep "request done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client request -r failed"

    sanlock client examine -r test:testres:./res:0 | grep "examine done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client examine -r failed"

    sanlock client examine -s test:0:./dev:0 | grep "examine done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client examine -s failed"

    sanlock client format -x test:./res:0 -Z 512 -A 1M | grep "format done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client format -x -Z -A failed"

    sanlock client create -x test:./res:0 -e testres1 | grep "create_resource done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client create -x -e failed"

    sanlock client lookup -x test:./res:0 -e testres1:0 | grep "lookup done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client lookup -x -e failed"

    sanlock client delete -x test:./res:0 -e testres1:0 | grep "delete_resource done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client delete -x -e failed"

    sanlock client rebuild -x test:./res:0 | grep "rebuild done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client rebuild -x failed"
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
