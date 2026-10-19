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
#@Date      	:   2021-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test QUERY_LIST
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
    LOG_INFO "Start to run test. "

    # Search fedora
    actual1=$(QUERY_LIST fedora33 | grep fedora33 | sort | wc -l)
    fedora_num=$(dnf list --installroot=/home --releasever=1 --repo=fedora-Binary | grep -v "B/s" | grep fedora-Binary | awk -F '.src' '{print $1}' | sort | wc -l)
    CHECK_RESULT "$actual1" "$fedora_num" 0 "Check the query for fedora failed."

    actual2=$(QUERY_LIST fedora33 -s | grep fedora33 | sort | wc -l)
    fedora_num=$(dnf list --installroot=/home --releasever=1 --repo=fedora-Source | grep -v "B/s" | grep fedora-Source | awk -F '.src' '{print $1}' | sort | wc -l)
    CHECK_RESULT "$actual2" "$fedora_num" 0 "Check the query for fedora -s failed."

    # Search openEuler
    QUERY_LIST openeuler-20_09-os >/dev/null
    CHECK_RESULT $? 0 0 "Check the query for openeuler-20_09-os failed."
    QUERY_LIST openeuler-20_09-os -s >/dev/null
    CHECK_RESULT $? 0 0 "Check the query for openeuler-20_09-os -s failed."
    
    QUERY_LIST openeuler-20_03 >/dev/null
    CHECK_RESULT $? 0 0 "Check the query for openeuler-20_03 failed."
    QUERY_LIST openeuler-20_03 -s >/dev/null
    CHECK_RESULT $? 0 0 "Check the query for openeuler-20_03 failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV
    if [ "${NODE1_FRAME}" = "x86_64" ]; then
        sed -i "s/x86_64/aarch64/g" ./conf.yaml
    fi

    LOG_INFO "End to restore the test environment."
}

main "$@"
