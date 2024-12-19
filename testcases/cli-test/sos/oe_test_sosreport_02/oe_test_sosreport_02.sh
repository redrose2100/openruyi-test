#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2021/01/04
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of sosreport command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sos tar"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        name="sosreport-openeuler-riscv64"
    else
        name="sosreport-localhost"
    fi

    expect <<EOF
        spawn sos report --debug --case-id debug
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-debug-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    expect <<EOF
        spawn sos report --desc "test description content" --case-id desc
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-desc-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    expect <<EOF
        spawn sos report --experimental --case-id experimental
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-experimental-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    expect <<EOF
        spawn sos report -e dnf,rpm,selinux,dovecot --case-id enable-plugins
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-enable-plugins-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report -l | grep -E "on|off|inactive"
    CHECK_RESULT $?
    expect <<EOF
        spawn sos report -k dnf.history-info --case-id plugin-option
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-plugin-option-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    expect <<EOF
        spawn sos report --label test-label --case-id 001
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
    test -f /var/tmp/$name-test-label-001-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --list-presets
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    for file in *; do
        if [[ ! $file =~ \.sh$ ]]; then
            rm -rf "$file"
        fi
    done
    rm -rf /var/tmp/sos*
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
