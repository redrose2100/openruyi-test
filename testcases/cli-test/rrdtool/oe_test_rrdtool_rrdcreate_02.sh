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
    rrdtool update ./common/test.rrd 920804700:12345 920805000:12357 920805300:12363
    rrdtool update ./common/test.rrd 920805600:12363 920805900:12363 920806200:12373
    rrdtool update ./common/test.rrd 920806500:12383 920806800:12393 920807100:12399
    rrdtool update ./common/test.rrd 920807400:12405 920807700:12411 920808000:12415
    rrdtool update ./common/test.rrd 920808300:12420 920808600:12422 920808900:12423
    rrdcached -l unix:/root/mugen/testcases/cli-test/rrdtool/common:9999
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --daemon
    rrdcreate --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common ./common/test.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 && test -f ./common/test.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option --daemon"
    # test option: -d
    rrdcreate -d unix:/root/mugen/testcases/cli-test/rrdtool/common ./common/test1.rrd DS:probe1-temp:GAUGE:600:55:95 RRA:MIN:0.5:12:1440 && test -f ./common/test1.rrd
    CHECK_RESULT $? 0 0 "rrdcreate: faild to test option -d"
    # test command: rrdinfo
    # test option: --daemon
    rrdinfo ./common/test.rrd --daemon unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 | grep filename
    CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --daemon"
    # test option: -d
    rrdinfo ./common/test.rrd -d unix:/root/mugen/testcases/cli-test/rrdtool/common:9999 | grep filename
    CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -d"
    # test option: --noflush
    rrdinfo ./common/test.rrd --noflush | grep filename
    CHECK_RESULT $? 0 0 "rrdtool info: faild to test option --noflush"
    # test option: -F
    rrdinfo ./common/test.rrd -F | grep filename
    CHECK_RESULT $? 0 0 "rrdtool info: faild to test option -F"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep rrdcached)
    rm -rf common/test*.rrd /root/mugen/testcases/cli-test/rrdtool/common:9999 /var/run/rrdcached.pid
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"