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
# @Desc      :   Test pmc
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "linuxptp tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    ptp4l -i ${NODE1_NIC} -m -S > message 2>&1 &
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    pmc -h 2>&1 |grep "usage: pmc"
    CHECK_RESULT $? 0 0 "Check pmc -h failed"
    pmc -v
    CHECK_RESULT $? 0 0 "Check pmc -v failed"
    pmc -i ${NODE1_NIC} -u -b 0 'GET CURRENT_DATA_SET' | grep "RESPONSE MANAGEMENT CURRENT_DATA_SET"
    CHECK_RESULT $? 0 0 "Check pmc -b failed"
    pmc -i ${NODE1_NIC} -u -b 1 -d 0 'GET TIME_STATUS_NP' | grep "master_offset"
    CHECK_RESULT $? 0 0 "Check pmc -i failed"
    pmc -i ${NODE1_NIC} -u -b 1 -d 0 'GET DOMAIN' | grep "domainNumber 0"
    CHECK_RESULT $? 0 0 "Check pmc -d failed"
    pmc -i ${NODE1_NIC} -u -b 1 -d 0 'GET DOMAIN' -s /var/run/ptp4l | grep "domainNumber 0"
    CHECK_RESULT $? 0 0 "Check pmc -s failed"
    pmc -i ${NODE1_NIC} -u -b 1 'GET PORT_DATA_SET' -t 0x0 | grep "portIdentity"
    CHECK_RESULT $? 0 0 "Check pmc -t failed"
    pmc -i ${NODE1_NIC} -u -b 1 'GET CLOCK_DESCRIPTION' -z | grep "clockType"
    CHECK_RESULT $? 0 0 "Check pmc -z failed"
    pmc -i ${NODE1_NIC} -2 -b 1 'GET CLOCK_DESCRIPTION'
    CHECK_RESULT $? 0 0 "Check pmc -2 failed"
    pmc -i ${NODE1_NIC} -4 -b 1 'GET CLOCK_DESCRIPTION'
    CHECK_RESULT $? 0 0 "Check pmc -4 failed"
    pmc -i ${NODE1_NIC} -6 -b 1 'GET CLOCK_DESCRIPTION'
    CHECK_RESULT $? 0 0 "Check pmc -6 failed"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    kill -9 $(pgrep -f "ptp4l")
    rm -rf message ./data
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
           
