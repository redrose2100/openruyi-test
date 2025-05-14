#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/09/10
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of augeas
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL augeas
    LOG_INFO "End to prepare the test environment."
}

function ver() {
    # version to number: 2.1.0 -> 200100000
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

function run_test() {
    LOG_INFO "Start to run test."
    local version exp
    version=$(rpm -q augeas | cut -d "-" -f 2)
    exp="1.14.0"
    if [[ $(ver "$version") -ge $(ver "$exp") ]]; then
        augprint /etc/hosts | grep "127.0.0.1"
        CHECK_RESULT $? 0 0 "augprint failed."
        augprint --lens=simplelines /etc/hosts | grep simplelines
        CHECK_RESULT $? 0 0 "Simplelines camera failed to parse/etc/hosts file"
        augprint --regexp=12 /etc/hosts | grep Loopback
        CHECK_RESULT $? 0 0 "Find and output the content or node error that matches regular expression 12 in the/etc/hosts file"
        augprint --pretty /etc/hosts | grep localhost
        CHECK_RESULT $? 0 0 "The generated output command script will have a more readable format for error reporting"
        augprint --noseq /etc/hosts | grep localhost
        CHECK_RESULT $? 0 0 "Using * instead of seq:: * in path expression yields an error message"
    else
        LOG_ERROR "augeas version $version lower than $exp"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
