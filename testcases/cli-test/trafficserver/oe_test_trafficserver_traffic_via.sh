#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   Yihao Lin
# @Contact   :   1165507637@qq.com 
# @Date      :   2022/03/05
# @License   :   Mulan PSL v2
# @Desc      :   Test traffic_via
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "trafficserver"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    traffic_via --version|grep "traffic_via"
    CHECK_RESULT $? 0 0 "failed to show version"
    #Decode Traffic Server Via header code
    traffic_via "[uScMsEf p eC:t cCMp sF]" | grep "Via Header Details:"
    CHECK_RESULT $? 0 0 "failed to decode traffic server via header code" 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    pkill [TS_MAIN]
    pkill traffic_m
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
