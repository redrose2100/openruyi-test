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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Test init when set memory stress
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    INSTALL_STRESS
    MEM_STRESS

    LOG_INFO "Finish to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship list openeuler-lts | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "Query list while memory suppress failed."
    pkgship pkginfo glibc openeuler-lts | grep "Binary Name    :glibc" >/dev/null
    CHECK_RESULT $? 0 0 "Query pkginfo while memory suppress failed."
    pkgship installdep glibc | grep glibc >/dev/null
    CHECK_RESULT $? 0 0 "Query installdep while memory suppress failed."
    pkgship builddep glibc | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "Query builddep while memory suppress failed."
    pkgship selfdepend glibc -s -w | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "Query selfdepend while memory suppress failed."
    pkgship bedepend openeuler-lts glibc -w | grep openeuler >/dev/null
    CHECK_RESULT $? 0 0 "Query bedepend while memory suppress failed."
    pkgship compare -t install -dbs openeuler-lts fedora33 | grep "successful" >/dev/null
    CHECK_RESULT $? 0 0 "Query compare while memory suppress failed."

    LOG_INFO "Start to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    kill -9 "$(pgrep -a -f stress | grep -Ev "bash|grep|mugen.sh" | awk '{print $1}')"
    REVERT_ENV
    CLEAN_STRESS

    LOG_INFO "End to restore the test environment."
}

main "$@"
