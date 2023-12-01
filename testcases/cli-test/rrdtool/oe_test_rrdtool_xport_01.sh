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
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: -s
    rrdtool xport -s now-1h DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -s"
    # test option: --start
    rrdtool xport --start now-1h DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --start"
    # test option: -e
    rrdtool xport -e now DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -e"
    # test option: --end
    rrdtool xport --end now DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --end"
    # test option: -m
    rrdtool xport -m 400 DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -m"
    # test option: --maxrows
    rrdtool xport --maxrows 400 DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --maxrows"
    # test option: --daemon
    rrdtool xport --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --daemon"
    # test option: -d
    rrdtool xport -d unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -d"
    # test option: -t
    rrdtool xport -t DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option -t"
    # test option: --showtime
    rrdtool xport --showtime DEF:vtest=./common/xport_test.rrd:testds:AVERAGE XPORT:vtest:"num" | grep "<xport>"
    CHECK_RESULT $? 0 0 "rrdtool xport: failed to test option --showtime"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    pkill -f rrdcached
    rm -rf /root/mugen/testcases/cli-test/rrdtool/common:9999 /var/run/rrdcached.pid
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"