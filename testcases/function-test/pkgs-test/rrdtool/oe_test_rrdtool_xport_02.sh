#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -O.
# #############################################
# @Author    :   chenzirui
# @Contact   :   ziruichen@126.com
# @Date      :   2022/10/01
# @License   :   Mulan PSL v2
# @Desc      :   Test rrdtool
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rrdtool"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --step
    rrdtool xport --step automatic DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --step"
    # test option: --json
    rrdtool xport --json DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "graph JSON output"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --json"
    # test option: --enumds
    rrdtool xport --enumds DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --enumds"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"