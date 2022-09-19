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
#@Date      :   2022/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "yapp" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "yapp"
    systemctl restart sshd.service
    touch savefile
    cp /etc/yapp/example.yp ./
    LOG_INFO "End to prepare the test environment"
}
##########################################################
# Usage:  yapp [options] grammar[.yp]
#   or    yapp -V
#   or    yapp -h

#     -m module   Give your parser module the name <module>
#                 default is <grammar>
#     -v          Create a file <grammar>.output describing your parser
#     -s          Create a standalone module in which the driver is included
#     -n          Disable source file line numbering embedded in your parser
#     -o outfile  Create the file <outfile> for your parser module
#                 Default is <grammar>.pm or, if -m A::Module::Name is
#                 specified, Name.pm
#     -t filename Uses the file <filename> as a template for creating the parser
#                 module file.  Default is to use internal template defined
#                 in Parse::Yapp::Output
#     -b shebang  Adds '#!<shebang>' as the very first line of the output file

#     grammar     The grammar file. If no suffix is given, and the file
#                 does not exists, .yp is added

#     -V          Display current version of Parse::Yapp and gracefully exits
#     -h          Display this help screen

##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_yapp."
    ### -V ###
    yapp -V | grep -E "This is Parse::Yapp"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -h ###
    yapp -h | grep -E "Usage:  yapp \[options\]"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -m ###
    yapp -m example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    ### -v ###
    yapp -v example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -s ###
    yapp -s example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -g No Pass"
    ### -n ###
    yapp -n example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -G No Pass"
    ### -o ###
    yapp -o example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    ### -t ###
    yapp -t example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -C No Pass"
    ### -b ###
    yapp -b shebang example.yp
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf savefile result example.yp
    LOG_INFO "End to restore the test environment."
}

main "$@"
