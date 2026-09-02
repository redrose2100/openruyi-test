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
#@Date      	:   2024-01-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run expat testsuite
#####################################
# shellcheck disable=SC1091
# shellcheck disable=SC1091
source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run expat test."
    pushd ./tmp_test || exit
    chmod +x ./*
    ./runtests | grep "Failed: 0"
    CHECK_RESULT $? 0 0 "run runtests failed!"
    if [ -f ./runtests_cxx ]; then
        ./runtests_cxx | grep "Failed: 0"
        CHECK_RESULT $? 0 0 "run runtests_cxx failed!"
    else
        LOG_INFO "runtests_cxx not available, skipping"
    fi
    popd || return
    LOG_INFO "End to run expat test."
}

main "$@"
