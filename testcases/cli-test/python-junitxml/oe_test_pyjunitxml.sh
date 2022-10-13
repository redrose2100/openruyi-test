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
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/9/15
#@License   :   Mulan PSL v2
#@Desc      :   Test "pyjunitxml" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "python-junitxml"
    LOG_INFO "End to prepare the test environment"
}
##########################################################
#Usage: pyjunitxml [options] [tests]
#
#Options:
#  -h, --help            Show option summary and exit
#  -o OUTPUT, --output-file=OUTPUT
#                        Specify name of output XML file. (Default:
#                        ./junit.xml)
#
#  Discovery options:
#    Used to control discovery (when no tests specified).
#
#    -s START, --start-directory=START
#                        Directory to start discovery ('.' default)
#    -p PATTERN, --pattern=PATTERN
#                        Pattern to match tests ('test*.py' default)
#    -t TOP, --top-level-directory=TOP
#                        Top level directory of project (defaults to start
#                        directory)
#
#<xml file> is the name of a file used for output.
#[tests] can be a list of any number of test modules, classes and test
#methods. If no tests are specified, automatic discovery is performed.
#
#Example for executing specific tests:
#  /usr/bin/pyjunitxml -o junit.xml test_module
#  /usr/bin/pyjunitxml test_module.TestClass
#  /usr/bin/pyjunitxml test_module.TestClass.test_method
#
#Example for test discovery:
#  /usr/bin/pyjunitxml
#  /usr/bin/pyjunitxml -o junit.xml -s tests/ -p '*.py'
#  /usr/bin/pyjunitxml -t myproj/ -s myproj/tests/ -p '*.py'
#
#For test discovery all test modules must be importable from the top
#level directory of the project.
#
#It is an error to specify discovery options and specific tests.
##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_pyjunitxml."
    ### -h ###
    pyjunitxml --h | grep "Usage: pyjunitxml"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### --help ###
    pyjunitxml --help | grep "Usage: pyjunitxml"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    ### -o ###
    pyjunitxml -o ./junit.xml 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
    ### --output-file ###
    pyjunitxml --output-file=./junit.xml 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --output-file No Pass"
    ### -s ###
    pyjunitxml -s . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    ### --start-directory ###
    pyjunitxml --start-directory . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --start-directory No Pass"
    ### -t ###
    pyjunitxml -t . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    ### --top-level-directory ###
    pyjunitxml --top-level-directory . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --top-level-directory No Pass"
    ### -p ###
    pyjunitxml -p test*.py 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    ### --pattern ###
    pyjunitxml --pattern test*.py 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --pattern No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
