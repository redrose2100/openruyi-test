#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/29
# @License   :   Mulan PSL v2
# @Desc      :   Test timemaster
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "linuxptp tar chrony"
    tar -xvf ./common/data.tar.gz > /dev/null
    sed -i "s/interfaces enp3s0/interfaces ${NODE1_NIC}/g" ./data/timemaster.cnf
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    timemaster -h 2>&1 | grep "usage: timemaster"
    CHECK_RESULT $? 0 0 "Check timemaster -h failed"
    timemaster -v
    CHECK_RESULT $? 0 0 "Check timemaster -v failed"
    timemaster -f ./data/timemaster.cnf -m &>> tmp.txt &
    SLEEP_WAIT 10
    grep "started: ptp4l" tmp.txt
    CHECK_RESULT $? 0 0 "Check timemaster -f failed"
    kill -9 "$(pgrep -f 'timemaster -f')"
    rm -f tmp.txt
    timemaster -f ./data/timemaster.cnf -n &>> tmp.txt
    grep "uds_address" tmp.txt
    CHECK_RESULT $? 0 0 "Check timemaster -n failed"
    rm -f tmp.txt
    timemaster -f ./data/timemaster.cnf -m -l 6 &>> tmp.txt &
    SLEEP_WAIT 10
    grep "started: ptp4l" tmp.txt
    CHECK_RESULT $? 0 0 "Check timemaster -l failed"
    kill -9 "$(pgrep -f "timemaster -f")"
    rm -f tmp.txt
    timemaster -f ./data/timemaster.cnf -m &>> tmp.txt &
    SLEEP_WAIT 10
    grep "started: ptp4l" tmp.txt
    CHECK_RESULT $? 0 0 "Check timemaster -m failed"
    kill -9 "$(pgrep -f "timemaster -f")"
    rm -f tmp.txt
    timemaster -f ./data/timemaster.cnf -q &
    SLEEP_WAIT 5
    pgrep -fl timemaster
    CHECK_RESULT $? 0 0 "Check timemaster -q failed"
    kill -9 "$(pgrep -f "timemaster -f")"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf ./data
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
