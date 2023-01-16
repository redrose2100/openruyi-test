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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    sanlock -h 2>&1 | grep "sanlock <command>"
    CHECK_RESULT $? 0 0 "Check sanlock -h failed"

    sanlock --help 2>&1 | grep "sanlock <command>"
    CHECK_RESULT $? 0 0 "Check sanlock --help failed"

    nohup sanlock daemon -D -Q 0 -R 1 -H 60 -L -1 -S 3 -U sanlock -G sanlock -e test >./start.log 2>&1 &
    SLEEP_WAIT  10
    grep "sanlock daemon started" ./start.log
    CHECK_RESULT $? 0 0 "Check sanlock daemon -D -Q -R -H -L -S -U -G -e failed"

    kill -9 $(pgrep -f "sanlock daemon")
    SLEEP_WAIT  10
    nohup sanlock daemon -D -U sanlock -G sanlock -t 4 -g 20 -w 0 -h 1 -l 2 -b 12 -e test >./start1.log 2>&1 &
    SLEEP_WAIT  10
    grep "sanlock daemon started" ./start1.log
    CHECK_RESULT $? 0 0 "Check sanlock daemon -D -U -G -t -g -w -h -l -b -e failed"

    sanlock client init -s test:0:./dev:0 -Z 512 -A 1M | grep "init done"
    CHECK_RESULT $? 0 0 "Check sanlock client init -s -Z -A failed"

    sanlock client add_lockspace -s test:1:./dev:0
    SLEEP_WAIT  10
    sanlock client host_status -s test:1:./dev:0 -D | grep "1 timestamp"
    CHECK_RESULT $? 0 0 "Check sanlock client host_status -s -D failed"

    sanlock client status -D -o p | grep "our_host_name=test"
    CHECK_RESULT $? 0 0 "Check sanlock client status -D -o failed"

    sanlock client gets -h 0 | grep "test:1:./dev:0"
    CHECK_RESULT $? 0 0 "Check sanlock client gets -h failed"

    sanlock client renewal -s test:0:./dev:0 -D | grep "read_ms=0 write_ms=0 next_timeouts=0 next_errors=0"
    CHECK_RESULT $? 0 0 "Check sanlock client renewal -s -D failed"

    sanlock client set_event -s test:0:./dev:0 -i 2000 -g gen -e 0 -d 0 | grep "set_event done 0"
    CHECK_RESULT $? 0 0 "Check sanlock client set_event -s -i -g -e -d failed"
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
