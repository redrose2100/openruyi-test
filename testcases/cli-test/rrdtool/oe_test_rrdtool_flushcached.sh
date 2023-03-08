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
    rrdtool create ./common/test.rrd --start 920804400 DS:speed:COUNTER:600:U:U RRA:AVERAGE:0.5:1:24 RRA:AVERAGE:0.5:6:10
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --daemon
    rrdtool flushcached --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 ./common/test.rrd
    CHECK_RESULT $? 0 0 "rrdtool flushcached: faild to test option --daemon"
    # test option: -d
    rrdtool flushcached -d unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 ./common/test.rrd
    CHECK_RESULT $? 0 0 "rrdtool flushcached: faild to test option -d"
    # test option: -f
    rrdcgi -f ./common/cgi.html | grep "<HEAD><TITLE>RRDCGI Demo</TITLE></HEAD>" && test -f speed.png
    CHECK_RESULT $? 0 0 "rrdcgi: faild to test option -f"
    rm -rf speed.png
    # test option: --filter
    rrdcgi --filter ./common/cgi.html | grep "<HEAD><TITLE>RRDCGI Demo</TITLE></HEAD>" && test -f speed.png
    CHECK_RESULT $? 0 0 "rrdcgi: faild to test option --filter"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf ./common/test.rrd /root/mugen/testcases/cli-test/rrdtool/common:9999 /var/run/rrdcached.pid speed.png
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"