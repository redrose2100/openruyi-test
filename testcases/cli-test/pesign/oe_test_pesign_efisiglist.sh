#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of pesign command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL pesign
    mkdir pesigntest
    cd pesigntest
    cp ../common/baidu.zip ./
    unzip baidu.zip
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    efisiglist -? 2>&1 | grep "Usage: efisiglist"
    CHECK_RESULT $? 0 0 "Check efisiglist -? failed"
    efisiglist --help 2>&1 | grep "Usage: efisiglist"
    CHECK_RESULT $? 0 0 "Check efisiglist --help failed"
    efisiglist --usage 2>&1 | grep "Usage: efisiglist"
    CHECK_RESULT $? 0 0 "Check efisiglist --usage failed"
    efisiglist -i ./baidu -o test -a -h 741a03a10f3de6b2eb81985d06b70f549e762d2e9a1895c5156ffc5e10ffde33 -t sha256 && test -f ./test
    CHECK_RESULT $? 0 0 "Check efisiglist -i -o -a -h -t failed"
    efisiglist --infile=./baidu --outfile=test1 --add --hash 741a03a10f3de6b2eb81985d06b70f549e762d2e9a1895c5156ffc5e10ffde33 --hash-type=sha256 && test -f ./test1
    CHECK_RESULT $? 0 0 "Check efisiglist --infile --outfile --add --hash --hash-type failed"
    efisiglist -i ./baidu -o test4 -c test && test -f ./test4
    CHECK_RESULT $? 0 0 "Check efisiglist -i -o -c failed"
    efisiglist -i ./baidu -o test5 --certificate=test && test -f ./test5
    CHECK_RESULT $? 0 0 "Check efisiglist -i -o --certificate failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf pesigntest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
