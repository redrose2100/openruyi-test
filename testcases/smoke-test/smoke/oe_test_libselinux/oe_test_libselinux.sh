#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyangmei
# @Contact   :   liuyangmei@h-partners.com
# @Date      :   2024-10-31
# @License   :   Mulan PSL v2
# @Desc      :   Command test-libselinux
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libselinux
    # 对selinux是否被禁用进行判断
    setenforce 1  #如果在内核层禁用了selinux,那么这里是无法打开的
    if [ "$(getenforce)" == "Disabled" ]; then
        LOG_WARN "Testing cannot be performed if selinux cannot be enabled."
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -q libselinux
    CHECK_RESULT $? 0 0 "check libselinux install"
    fc_file=/etc/selinux/targeted/contexts/files/file_contexts
    sefcontext_compile -o test_file_contexts.bin "${fc_file}"
    CHECK_RESULT $? 0 0 "check sefcontext_compile -o"
    test -f /etc/selinux/targeted/active/policy.kern && policy_file=/etc/selinux/targeted/active/policy.kern
    test -f /var/lib/selinux/targeted/active/policy.kern && policy_file=/var/lib/selinux/targeted/active/policy.kern
    sefcontext_compile -p "${policy_file}" "${fc_file}"
    CHECK_RESULT $? 0 0 "check sefcontext_compile -p"
    sefcontext_compile "${fc_file}"
    CHECK_RESULT $? 0 0 "check sefcontext_compile"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f test_file_contexts.bin
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
