#!/usr/sbin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /sbin
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "diffutils"
    cur_lang="${LANG}"
    export LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    [[ "$(readlink /sbin)" == "usr/sbin" ]]
    CHECK_RESULT $? 0 0 "/sbin is not soft link of /usr/sbin "
    diff /sbin /usr/sbin
    CHECK_RESULT $? 0 0 "The /sbin doesn't same with /usr/sbin."
    # /usr/sbin 在 openRuyi 上是指向 bin 的符号链接，find 默认不跟随符号链接，
    # 会把整个目录当成空目录，因此必须加 -L；否则 actual_access 为空，
    # 下面的 here-string 会带着空串进循环，产生一条假的权限异常。
    actual_access=$(find -L /usr/sbin -mindepth 1 -maxdepth 1 -exec stat -c '%A' {} \; | sort | uniq)
    expect_file="./expect_access"
    if [ -z "$actual_access" ]; then
        CHECK_RESULT 1 0 0 "No entry found under /usr/sbin."
    else
        while IFS= read -r perm; do
            if ! grep -Fxq -- "$perm" "$expect_file"; then
                CHECK_RESULT 1 0 0 "Unexpected permission: $perm"
                break
            fi
        done <<< "$actual_access"
    fi
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

