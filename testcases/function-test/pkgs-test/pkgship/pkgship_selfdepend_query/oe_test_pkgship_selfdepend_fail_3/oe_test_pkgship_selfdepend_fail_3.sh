#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_SELFDEPEND {binaryName} {not existing dbName}
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Set non-exist dName
    pkgship selfdepend setup -dbs test | grep "Request parameter error" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when set non-exist dName."

    # Set lower&upper characters on dbname
    pkgship selfdepend setup -dbs OPENEuler-LTS | grep "Request parameter error" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when set lower&upper characters on dName."

    # Set non-exist dblist
    pkgship selfdepend setup -dbs data1 data2 | grep "Request parameter error" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when set non-exist dblist."

    # Set part non-exist dblist
    pkgship selfdepend setip -dbs openEuler-LTS test | grep "Request parameter error" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when set part non-exist dName."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
