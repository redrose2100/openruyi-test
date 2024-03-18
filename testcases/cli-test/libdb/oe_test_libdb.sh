#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.6.11
# @License   :   Mulan PSL v2
# @Desc      :   libdb Command Test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir /tmp/test
    path=/tmp/test
    DNF_INSTALL "libdb libdb-devel gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cp ./common/testdb.c /tmp/test
    cd ${path}&&gcc -o testdb testdb.c -ldb
    test -f ${path}/testdb
    CHECK_RESULT $? 0 0 "testdb.c compile fails"
    ./testdb > ${path}/libdb.txt
    test -f ${path}/test.db
    CHECK_RESULT $? 0 0 "testdb execute fails"
    grep b1 ${path}/test.db
    CHECK_RESULT $? 0 0 " test.db file error"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ${path}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
