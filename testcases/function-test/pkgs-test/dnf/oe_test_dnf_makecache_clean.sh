#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   zengcongwei
#@Contact       :   735811396@qq.com
#@Date          :   2020/5/12
#@License       :   Mulan PSL v2
#@Desc          :   Test "dnf makecache" & "dnf clean" command
###################################

source "common/common_dnf.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnf makecache 2>&1 | grep "Metadata cache created"
    CHECK_RESULT $?
    # dnf5 stores cache under ~/.cache/libdnf5/ (no /var/cache/dnf/*.solv)
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $?
    dnf clean dbcache 2>&1 | grep "Removed"
    CHECK_RESULT $?
    # clean dbcache removes solv files in dnf5
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $? 1 0
    dnf makecache 2>&1 | grep "Metadata cache created"
    # dnf5 clean expire-cache does not remove cached metadata/solv
    dnf clean expire-cache 2>&1 | grep "Removed"
    CHECK_RESULT $?
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $?
    dnf makecache 2>&1 | grep "Metadata cache created"
    dnf clean metadata 2>&1 | grep "Removed"
    CHECK_RESULT $?
    # clean metadata removes solv files in dnf5
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $? 1 0
    # dnf5: --downloadonly must be placed after the subcommand
    dnf install -y --downloadonly tree 2>&1 | grep "Complete!"
    CHECK_RESULT $?
    find ~/.cache/libdnf5 -name 'tree*' | grep tree
    CHECK_RESULT $?
    dnf clean packages 2>&1 | grep "Removed"
    CHECK_RESULT $?
    find ~/.cache/libdnf5 -name 'tree*' | grep tree
    CHECK_RESULT $? 1 0
    dnf install -y --downloadonly tree 2>&1 | grep "Complete!"
    find ~/.cache/libdnf5 -name 'tree*' | grep tree
    dnf makecache 2>&1 | grep "Metadata cache created"
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $?
    dnf clean all 2>&1 | grep "Removed"
    CHECK_RESULT $?
    find ~/.cache/libdnf5 -name 'tree*' | grep tree
    CHECK_RESULT $? 1 0
    # clean all removes solv files in dnf5
    find ~/.cache/libdnf5 -name '*.solv' | grep solv
    CHECK_RESULT $? 1 0
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to prepare the test environment."
    clear_env
    LOG_INFO "Finish preparing the test environment."
}

main "$@"
