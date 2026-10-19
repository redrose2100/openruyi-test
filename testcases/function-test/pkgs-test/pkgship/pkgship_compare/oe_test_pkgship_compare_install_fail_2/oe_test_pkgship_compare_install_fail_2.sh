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
#@Desc      	:   Take the test compare install data comparison between dbs failed
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    mkdir /opt/test_install && chmod 600 /opt/test_install
    ori_num=$(wc -l /opt/pkgship/compare | awk '{print $1}')

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    su pkgshipuser -c "pkgship compare -t install -dbs openeuler-lts fedora33 -o /opt/test_install 2>&1 | grep \"\[ERROR\] Output path (/opt/test_install) not exist or does not support user pkgshipuser writing\""
    CHECK_RESULT $? 0 0 "The message is error when output path has no access."
    CHECK_RESULT "$(wc -l /opt/pkgship/compare | awk '{print $1}')" "$ori_num" 0 "It created comparison file unexpectly."
    
    pkgship compare -t install -dbs openeuler-lts fedora33 -o /opt/test_installlll 2>&1 | grep "\[ERROR\] Output path (/opt/test_installlll) not exist or does not support user pkgshipuser writing."
    CHECK_RESULT $? 0 0 "The message is error when set output path not exist."
    pkgship compare -t install -dbs openeuler-lts fedora33 -o 2>&1 | grep "expected one argument"
    CHECK_RESULT $? 0 0 "The message is error when no -o paramter."
    pkgship compare -t install -dbs -o 2>&1 | grep "expected one argument"
    CHECK_RESULT $? 0 0 "The message is error when no paramter."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /opt/test_install
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
