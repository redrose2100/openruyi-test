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
    rrdtool create ./common/test1.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --daemon
    rrdtool update ./common/test.rrd N:23 --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --daemon"
    # test option: -d
    rrdtool update ./common/test1.rrd N:23 -d unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -d"
    # test option: --template
    rrdtool update ./common/test.rrd N:23 --template probe1-temp
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --template"
    # test option: -t
    rrdtool update ./common/test.rrd N:23 -t probe1-temp
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -t"
    # test option: --skip-past-updates
    rrdtool update ./common/test.rrd N:23 --skip-past-updates
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option --skip-past-updates"
    # test option: -s
    rrdtool update ./common/test.rrd N:23 -s
    CHECK_RESULT $? 0 0 "rrdtool update: faild to test option -s"
    # test option: --template
    rrdtool updatev ./common/test.rrd N:23 --template probe1-temp | grep "return_value = 0"
    CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option --template"
    # test option: -t
    rrdtool updatev ./common/test.rrd N:23 -t probe1-temp | grep "return_value = 0"
    CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option -t"
    # test option: --skip-past-updates
    rrdtool updatev ./common/test.rrd N:23 --skip-past-updates | grep "return_value = 0"
    CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option --skip-past-updates"
    # test option: -s
    rrdtool updatev ./common/test.rrd N:23 -s | grep "return_value = 0"
    CHECK_RESULT $? 0 0 "rrdtool updatev: faild to test option -s"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf common/test*.rrd /root/mugen/testcases/cli-test/rrdtool/common:9999 /var/run/rrdcached.pid
    LOG_INFO "End to restore the test environment."
}

main "$@"