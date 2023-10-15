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
    mkdir test && cp test.rrd ./test/test.rrd
    rrdcached -l unix:/tmp/rrdcached.sock -b /base
    cp test.rrd /base/test_daemon.rrd
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rrdtool list -d unix:/tmp/rrdcached.sock / | grep "test_daemon.rrd"
    CHECK_RESULT $? 0 0 "rrdtool list: faild to test option --daemon"
    rrdtool list ./ --noflush | grep "test.rrd"
    CHECK_RESULT $? 0 0 "rrdtool list: faild to test option --noflush"
    rrdtool list ./ --recursive | grep "test/test.rrd"
    CHECK_RESULT $? 0 0 "rrdtool list: faild to test option --recursive"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf test.rrd ./test /base /tmp/rrdcached.sock
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"