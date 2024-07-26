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
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-15 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run luatestsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    sed -i.orig -e '/db.lua/d;/errors.lua/d;' ./tmp_test/lua-*-tests/all.lua
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run sed test."

    pushd ./tmp_test/lua-*-tests/ || exit
    lua -e"_U=true" all.lua
    CHECK_RESULT $? 0 0 "run lua test fail"
    popd || return

    LOG_INFO "End to run lua test."
}

main "$@"
