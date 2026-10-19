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
#@Desc      	:   Take the test compare build data comparison between dbs
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/aarch64/x86_64/g" ./conf.yaml
    fi
    INIT_CONF ./conf.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # test 1 db
    pkgship compare -t build -dbs openeuler1 >testlog1
    grep -q "\[WARNING\] There is only one input database, and only dependent information files will be generated without data comparison" testlog1
    CHECK_RESULT $? 0 0 "Execute compare build command failed when set 1 dbs."
    compare_dir=$(tail -n 1 testlog1 | cut -d '(' -f 2 | cut -d ')' -f 1)
    ls "${compare_dir}"/openeuler1.csv
    CHECK_RESULT $? 0 0 "Check openeuler1.csv created failed."

    # test 2 dbs
    pkgship compare -t build -dbs openeuler1 fedora >testlog2
    compare_dir=$(CHECK_COMPARE testlog2 openeuler1)
    COMPARE_BUILD_PKG build "$compare_dir" openeuler1 Judy
    COMPARE_BUILD_PKG build "$compare_dir" fedora Judy

    # test 3 dbs
    pkgship compare -t build -dbs openeuler1 openeuler2 fedora >testlog3
    compare_dir=$(CHECK_COMPARE testlog3 openeuler1)
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler1 Judy
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler2 Judy
    COMPARE_BUILD_PKG build "${compare_dir}" fedora Judy

    # test 4 dbs
    pkgship compare -t build -dbs openeuler1 openeuler2 openeuler3 fedora >testlog4
    compare_dir=$(CHECK_COMPARE testlog4 openeuler1)
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler1 Judy
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler2 Judy
    COMPARE_BUILD_PKG build "${compare_dir}" openeuler3 Judy
    COMPARE_BUILD_PKG build "${compare_dir}" fedora Judy

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /opt/pkgship/compare/* testlog* expect* actual*
    REVERT_ENV
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/x86_64/aarch64/g" ./conf.yaml
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
