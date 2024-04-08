#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   hukun
#@Contact   	:   hu_kun@hoperun.com
#@Date      	:   2024-3-11
#@License   	:   Mulan PSL v2
#@Desc      	:   Test libsemanage
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ ! -f ./tmp_test/tests/libsemanage-tests ]; then
        LOG_ERROR "Please compile it first!"
        exit 1
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pushd ./tmp_test/tests || exit 1
    LD_LIBRARY_PATH=$(pwd)
    export LD_LIBRARY_PATH
    # init test-policy dir
    ./libsemanage-tests &>/dev/null
    # actual test
    ./libsemanage-tests
    CHECK_RESULT "$?" 0 0 "libsemanage test failed!!!"
    popd || return
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp_test
    LOG_INFO "End to restore the test environment."
}

main "$@"
