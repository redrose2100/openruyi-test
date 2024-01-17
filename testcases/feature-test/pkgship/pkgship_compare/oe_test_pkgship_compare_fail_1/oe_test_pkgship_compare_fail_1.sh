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
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-07-30
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test compare failed with server stop
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    ACT_SERVICE stop

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship compare -t install -dbs openeuler-lts fedora33 2>&1 | grep "\[ERROR\] The pkgship service is not started,please start the service first"
    CHECK_RESULT $? 0 0 "Query install compare unexpectly when stop server."
    
    pkgship compare -t build -dbs openeuler-lts fedora33 2>&1 | grep "\[ERROR\] The pkgship service is not started,please start the service first"
    CHECK_RESULT $? 0 0 "Query build compare unexpectly when stop server."

    ACT_SERVICE
    for i in $(pgrep -a -f "elasticsearch" | grep -Ev "bash|grep|mugen.sh" | awk '{print $1}'); do
        kill -9 "$i" 
    done    

    pkgship compare -t install -dbs openeuler-lts fedora33 2>&1 | grep "\[ERROR\] "
    CHECK_RESULT $? 0 0 "Query install compare unexpectly when stop server."
    
    pkgship compare -t build -dbs openeuler-lts fedora33 2>&1 | grep "\[ERROR\] "
    CHECK_RESULT $? 0 0 "Query build compare unexpectly when stop server."
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
