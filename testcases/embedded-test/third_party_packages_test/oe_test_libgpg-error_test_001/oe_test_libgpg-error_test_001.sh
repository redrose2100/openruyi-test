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
#@Desc      	:   Run libgpg-error testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run libgpg-error test."
    if pkg-config -h; then
        ./gpg-error-config-test.sh
        CHECK_RESULT $? 0 0 "run libgpg-error failed!"
    fi

    pushd ./tmp_test/tests || exit
    list=(t-version t-strerror t-syserror t-lock t-printf t-poll t-b64 t-argparse t-logging t-stringutils t-malloc)
    for onetest in "${list[@]}"; do
        ./"$onetest"
        CHECK_RESULT $? 0 0 "run libgpg-error $onetest failed!"
    done
    popd || return

    LOG_INFO "End to run libgpg-error test."
}

main "$@"
