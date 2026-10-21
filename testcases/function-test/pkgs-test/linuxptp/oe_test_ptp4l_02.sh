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
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test ptp4l
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "linuxptp tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    ptp4l -i ${NODE1_NIC} -m -S &>> tmp.txt &
    SLEEP_WAIT 20
    grep "ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES" tmp.txt
    CHECK_RESULT $? 0 0 "Check ptp4l -m failed"
    kill -9 $(pgrep "ptp4l -i")
    rm -f tmp.txt
    ptp4l -i ${NODE1_NIC} -S -q &
    SLEEP_WAIT 10
    pgrep -f "ptp4l"
    CHECK_RESULT $? 0 0 "Check ptp4l -q failed"
    kill -9 $(pgrep "ptp4l -i")
    ptp4l -v
    CHECK_RESULT $? 0 0 "Check ptp4l -v failed"
    ptp4l -h 2>&1 | grep "usage: ptp4l"
    CHECK_RESULT $? 0 0 "Check ptp4l -h failed"
    ptp4l -f ./data/ptp4l.conf -i ${NODE1_NIC} &>> tmp.txt &
    SLEEP_WAIT 20
    pgrep -f "ptp4l"
    CHECK_RESULT $? 0 0 "Check ptp4l -f failed"
    kill -9 $(pgrep "ptp4l -f")
    rm -f tmp.txt
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
