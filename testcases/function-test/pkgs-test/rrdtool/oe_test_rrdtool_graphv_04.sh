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
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # test option: --no-gridfit
    rrdtool graphv ./common/test.png --no-gridfit -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --no-gridfit"
    # test option: -N
    rrdtool graphv ./common/test1.png -N -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test1.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -N"
    # test option: --x-grid
    rrdtool graphv ./common/test2.png --x-grid MINUTE:10:HOUR:1:HOUR:4:0:%X -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test2.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --x-grid"
    # test option: -x
    rrdtool graphv ./common/test3.png -x MINUTE:10:HOUR:1:HOUR:4:0:%X -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test3.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -x"
    # test option: --week-fmt
    rrdtool graphv ./common/test4.png --week-fmt string -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test4.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --week-fmt"
    # test option: -y
    rrdtool graphv ./common/test5.png -y none -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test5.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -y"
    # test option: --y-grid
    rrdtool graphv ./common/test6.png --y-grid none -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test6.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --y-grid"
    # test option: --left-axis-formatter
    rrdtool graphv ./common/test7.png --left-axis-formatter numeric -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test7.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option --left-axis-formatter"
    # test option: --left-axis-format
    rrdtool graphv ./common/test8.png --left-axis-format %le -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test8.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -left-axis-format"
    # test option: -Y
    rrdtool graphv ./common/test9.png -Y -s 920804400 -e 920808000 DEF:myspeed=common/test.rrd:speed:AVERAGE LINE2:myspeed#FF0000 && test -f ./common/test9.png
    CHECK_RESULT $? 0 0 "rrdtool graphv: faild to test option -Y"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./common/test.rrd /var/run/rrdcached.pid ./common/test*.png
    LOG_INFO "End to restore the test environment."
}

main "$@"