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
    rrdtool create test.rrd --start 920804400 DS:speed:COUNTER:600:U:U RRA:AVERAGE:0.5:1:24
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rrdupdate test.rrd 920804700:12345 && rrdtool info test.rrd | grep "last_update = 920804700"
    CHECK_RESULT $? 0 0 "rrdupdate: faild to test option time:value"
    rrdupdate test.rrd 920804300:12345 --skip-past-updates
    CHECK_RESULT $? 0 0 "rrdupdate: faild to test option --skip-past-updates"
    rrdupdate test.rrd 920804800@12345 && rrdtool info test.rrd | grep "last_update = 920804800"
    CHECK_RESULT $? 0 0 "rrdupdate: faild to test option at-time@value"
    rrdupdate test.rrd --template speed N:42 && rrdtool info test.rrd | grep "ds\[speed].last_ds = \"42\""
    CHECK_RESULT $? 0 0 "rrdupdate: faild to test option --template"
    rrdupdate test.rrd N:123 && rrdtool info test.rrd | grep "ds\[speed].last_ds = \"123\""
    CHECK_RESULT $? 0 0 "rrdupdate: faild to test option time|N:value"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test.rrd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"