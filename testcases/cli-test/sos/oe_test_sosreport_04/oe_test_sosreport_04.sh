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
    VERSION_ID=$(grep "VERSION_ID" /etc/os-release | awk -F '\"' '{print$2}')
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sos report --batch -s "/tmp"
    LAST_RESULT=$?
    if [ "${NODE1_FRAME}" == "riscv64" ]; then
        name="sosreport-openeuler-riscv64"
        CHECK_RESULT $LAST_RESULT
    else
        name="sosreport-localhost"
        CHECK_RESULT $LAST_RESULT 1
    fi

    sos report -s "/" --batch --label sysroot
    CHECK_RESULT $?
    test -f /var/tmp/$name-sysroot-"$(date +%Y-%m-%d)"-*.tar.xz
    CHECK_RESULT $?

    if [ "$VERSION_ID" != "22.03" ]; then
        sos report --batch --case-id 666
        CHECK_RESULT $?
        test -f /var/tmp/$name-666-"$(date +%Y-%m-%d)"-*.tar.xz
        CHECK_RESULT $?
        mkdir temp
        CHECK_RESULT $?
        sos report --batch --tmp-dir temp --case-id temp
        CHECK_RESULT $?
        test -f temp/$name-temp-"$(date +%Y-%m-%d)"-*.tar.xz
        CHECK_RESULT $?
        sos report --batch --tmp-dir temp -v --case-id verbose
        CHECK_RESULT $?
        test -f temp/$name-verbose-"$(date +%Y-%m-%d)"-*.tar.xz
        CHECK_RESULT $?
        sos report --batch --verify --tmp-dir temp --case-id verify
        CHECK_RESULT $?
        test -f temp/$name-verify-"$(date +%Y-%m-%d)"-*.tar.xz
        CHECK_RESULT $?
        sos report -z gzip --batch --tmp-dir temp --case-id gzipForm
        CHECK_RESULT $?
        test -f temp/$name-gzipForm-"$(date +%Y-%m-%d)"-*.tar.gz
        CHECK_RESULT $?
        sos report --threads 6 --batch --tmp-dir temp --case-id threads
        CHECK_RESULT $?
        test -f temp/$name-threads-"$(date +%Y-%m-%d)"-*.tar.xz
        CHECK_RESULT $?
    else
        LOG_INFO "Obsolete version command"
    fi

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
