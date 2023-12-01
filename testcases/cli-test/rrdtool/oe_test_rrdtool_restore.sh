#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-dNFRINGEMENT,
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
    rrdtool create ./common/test.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440
    rrdtool dump ./common/test.rrd ./common/test.xml
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --range-check
    rrdtool restore ./common/test.xml ./common/test1.rrd --range-check && test -f ./common/test1.rrd
    CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option --range-check"
    # test option: -r
    rrdtool restore ./common/test.xml ./common/test2.rrd -r && test -f ./common/test2.rrd
    CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option -r"
    # test option: --force-overwrite
    rrdtool restore ./common/test.xml ./common/test1.rrd --force-overwrite
    CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option --force-overwrite"
    # test option: -f
    rrdtool restore ./common/test.xml ./common/test1.rrd -f
    CHECK_RESULT $? 0 0 "rrdtool restore: faild to test option -f"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf common/test*.rrd common/test.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"