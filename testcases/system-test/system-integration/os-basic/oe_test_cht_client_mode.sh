#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/14
# @License   :   Mulan PSL v2
# @Desc      :   test cheat.sh client mode
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/test
    cd /tmp/test
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl https://cht.sh/:cht.sh > /tmp/test/cht.sh
    test -e cht.sh
    CHECK_RESULT $? 0 0 "Download failed"
    chmod +x /tmp/test/cht.sh
    /tmp/test/cht.sh pwd > pwd.txt
    grep 'Show the absolute path of your current working directory' pwd.txt
    CHECK_RESULT $? 0 0 "Query pwd failed"
    /tmp/test/cht.sh python string contain > string.txt
    grep 'https://docs.python.org/reference/expressions'  string.txt
    CHECK_RESULT $? 0 0 "Query string failed"
    /tmp/test/cht.sh python reverse list > reverse.txt
    grep 'https://www.python.org/dev/peps/pep-0322' reverse.txt
    CHECK_RESULT $? 0 0 "Query reverse failed"
    time curl cht.sh > time.txt
    grep 'real' time.txt
    CHECK_RESULT $? 0 0 "Query time failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test
    LOG_INFO "Finish restoring the test environment."
}

main "$@"