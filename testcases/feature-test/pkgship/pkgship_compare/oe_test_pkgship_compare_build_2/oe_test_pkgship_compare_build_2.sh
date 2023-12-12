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
#@Desc      	:   Take the test compare build to set output path
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    mkdir /opt/test_build1 && chmod 777 /opt/test_build1
    mkdir /opt/test_build2 && chown pkgshipuser:pkgshipuser /opt/test_build2

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship compare -t build -dbs openeuler-lts fedora33 -o /opt/test_build1 >testlog1
    compare_dir=$(CHECK_COMPARE testlog1 openeuler-lts)
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler-lts Judy
    COMPARE_BUILD_PKG build "${compare_dir}" fedora33 Judy

    pkgship compare -t build -dbs openeuler-lts fedora33 -o /opt/test_build2 >testlog2
    compare_dir=$(CHECK_COMPARE testlog2 openeuler-lts)
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler-lts Judy
    COMPARE_BUILD_PKG build "${compare_dir}" fedora33 Judy

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /opt/test_build1 /opt/test_build2 testlog* expect* actual*
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
