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
# @Desc      :   test cheat.sh Ordinary mode
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/test
    cd /tmp/test || exit 255
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    curl cht.sh/pwd > pwd.txt
    grep 'Show the absolute path of your current working directory' pwd.txt
    CHECK_RESULT $? 0 0 "Query pwd failed"
    curl cht.sh/~pwd > pwd2.txt
    grep 'tldr:pwdx' pwd2.txt
    CHECK_RESULT $? 0 0 "Query ~pwd failed"
    curl cht.sh/python/random+list+elements > API.txt
    grep 'https://docs.python.org/library/random.htmlrandom.choice' API.txt
    CHECK_RESULT $? 0 0 "Query API failed"
    curl cht.sh/python/random+list+elements\?Q >API-Q.txt
    grep 'https://docs.python.org/library/random.htmlrandom.choice' API-Q.txt
    CHECK_RESULT $? 0 1 "Query \?Q failed"
    curl curl cht.sh/sql+select >sql.txt
    grep "The \`CASE\` statement is the closest to IF in SQL" sql.txt
    CHECK_RESULT $? 0 0 "Query sql failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test
    LOG_INFO "Finish restoring the test environment."
}

main "$@"