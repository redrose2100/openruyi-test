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
# @Desc      :   verify the usage of sosreport command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sos tar hostname"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    name="sosreport-$(hostname -s)"
    sos report -h | grep -E "usage: sosreport \[options\]|-"
    CHECK_RESULT $?
    sos report --batch -a --case-id 001
    test -f /var/tmp/"${name}"-001-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch --all-logs --case-id 002
    test -f /var/tmp/"${name}"-002-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch
    CHECK_RESULT $?
    test -f /var/tmp/"${name}"-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch --build --case-id build
    test -d /var/tmp/"${name}"-build-"$(date +%Y-%m-%d)"-*
    CHECK_RESULT $?
    sos report --batch --case-id test
    test -f /var/tmp/"${name}"-test-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch -c never --case-id never
    test -f /var/tmp/"${name}"-never-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?
    sos report --batch --config-file /etc/sos.conf --case-id config
    test -f /var/tmp/"${name}"-config-"$(date +%Y-%m-%d)"-*.tar.xz
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
