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
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --start
    rrdcreate ./common/test.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 --start 12 && test -f ./common/test.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --start"
    # test option: -b
    rrdcreate ./common/test1.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 -b 12 && test -f ./common/test1.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -b"
    # test option: --step
    rrdcreate ./common/test2.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 --step 300 && test -f ./common/test2.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --step"
    # test option: -s
    rrdcreate ./common/test3.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 -s 300 && test -f ./common/test3.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -s"
    # test option: --no-overwrite
    rrdcreate ./common/test4.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 --no-overwrite && test -f ./common/test4.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --no-overwrite"
    # test option: -O
    rrdcreate ./common/test5.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 -O && test -f ./common/test5.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -O"
    # test option: --source
    rrdcreate --source ./common/test.rrd ./common/test6.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 && test -f ./common/test6.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --source"
    # test option: -r
    rrdcreate -r ./common/test.rrd ./common/test7.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 && test -f ./common/test7.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -r"
    # test option: --template
    rrdcreate --template ./common/test.rrd ./common/test8.rrd && test -f ./common/test8.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --template"
    # test option: -t
    rrdcreate -t ./common/test.rrd ./common/test9.rrd && test -f ./common/test9.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -t"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf common/test*.rrd /var/run/rrdcached.pid
    LOG_INFO "End to restore the test environment."
}

main "$@"