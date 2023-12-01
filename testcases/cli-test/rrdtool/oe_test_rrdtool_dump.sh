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
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --header
    rrdtool dump ./common/test.rrd ./common/test.xml --header dtd && test -f ./common/test.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --header"
    # test option: -h
    rrdtool dump ./common/test.rrd ./common/test1.xml -h dtd && test -f ./common/test1.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -h"
    # test option: --no-header
    rrdtool dump ./common/test.rrd ./common/test2.xml --no-header && test -f ./common/test2.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --no-header"
    # test option: -n
    rrdtool dump ./common/test.rrd ./common/test3.xml -n && test -f ./common/test3.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -n"
    # test option: --daemon
    rrdtool dump ./common/test.rrd ./common/test4.xml --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 && test -f ./common/test4.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --daemon"
    # test option: -d
    rrdtool dump ./common/test.rrd ./common/test5.xml -d unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 && test -f ./common/test5.xml
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -d"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf ./common/test.rrd ./common/test*.xml /root/mugen/testcases/cli-test/rrdtool/common:9999 /var/run/rrdcached.pid
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"