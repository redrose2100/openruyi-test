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

source "../common/common_lib.sh"
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
    sanlock direct init -s  test:0:./dev:0
    sanlock direct init -r  test:testres:./res:0
    sanlock client init -s  test:0:./dev:0
    sanlock client init -r  test:testres:./res:0
    sanlock client add_lockspace -s test:1:./dev:0
    systemctl start wdmd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    wdmd -h 2>&1 | fgrep "wdmd [options]"
    CHECK_RESULT $? 0 0 "Check wdmd -h failed"

    wdmd --help 2>&1 | fgrep "wdmd [options]"
    CHECK_RESULT $? 0 0 "Check wdmd --help failed"

    wdmd --version 2>&1 | grep "wdmd version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check wdmd --version failed"

    wdmd -V 2>&1 | grep "wdmd version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check wdmd -V failed"

    wdmd -d -D | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -d -D failed"

    wdmd -d -p | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -d -p failed"

    wdmd -d -H 0 | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -d -HD failed"

    wdmd -d -G sanlock | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -d -G failed"

    wdmd -d -S 1 | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -d -S failed"

    wdmd -d -s /etc/wdmd.d -k 1000 -w /dev/watchdog0 | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd -s -k -w failed"

    wdmd --dump --probe | grep "client 0 name signal pid"
    CHECK_RESULT $? 0 0 "Check wdmd --dump --probe failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pgrep -f "sanlock daemon")
    cd ..
    rm -rf sanlocktest
    systemctl stop wdmd
    LOG_INFO "Finish restore the test environment."
}

main "$@"
