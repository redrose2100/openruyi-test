#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "rhino" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "rhino"
    LOG_INFO "End to prepare the test environment"
}
##############################################
#Usage: java org.mozilla.javascript.tools.shell.Main [options...] [files]
#Valid options are:
#    -?, -help          Displays help messages.
#    -w                 Enable warnings.
#    -version 100|110|120|130|140|150|160|170|180|200
#                       Set a specific language version.
#    -opt [-1|0-9]      Set optimization level.
#    -f script-filename Execute script file, or "-" for interactive.
#    -e script-source   Evaluate inline script.
#    -modules [uri]     Add a single path or URL element to the CommonJS
#                       module search path. (implies -require)
#    -require           Enable CommonJS module support.
#    -sandbox           Enable CommonJS sandbox mode. (implies -require)
#    -debug             Generate debug code.
#    -strict            Enable strict mode warnings.
#    -fatal-warnings    Treat warnings as errors.
#    -encoding charset  Use specified character encoding as default when reading scripts.
##############################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_tuna."
    ### -w ###
    rhino -w&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -w No Pass"
    ### -version ###
    rhino -version 100&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"
    ### -opt ###
    rhino -opt 0&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -opt No Pass"
    ### -modules ###
    rhino -modules /usr/share&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -modules No Pass"
    ### -require ###
    rhino -require&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -require No Pass"
    ### -sandbox ###
    rhino -sandbox&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -sandbox No Pass"
    ### -debug ###
    rhino -debug&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -debug No Pass"
    ### -strict ###
    rhino -strict&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -strict No Pass"
    ### -fatal-warnings ###
    rhino -fatal-warnings&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -fatal-warnings No Pass"
    ### -encoding charset ###
    rhino -encoding utf-8&
    SLEEP_WAIT 1
    ps -ef | grep $!
    CHECK_RESULT $? 0 0 "L$LINENO: -encoding charset No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"