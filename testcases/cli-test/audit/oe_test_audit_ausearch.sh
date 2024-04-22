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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2022-12-16
# @License   :   Mulan PSL v2
# @Desc      :   Command audit ausearch
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    USER1=$(< /dev/urandom sed 's/[^a-zA-Z]//g' |strings -n 6 |head -1)
    useradd "${USER1}"
    chmod 755 /home/"${USER1}"
    auditctl -w /home/"${USER1}"/testfile -p rwxa -k testfile_audit_"${USER1}"
    auditctl -l
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    ausearch --format csv > test.csv
    file test.csv |grep -i  "CSV text"
    CHECK_RESULT $? -1 1 "format check fail"
    ausearch -m ADD_USER
    CHECK_RESULT $? -1 1 "AVC check fail"
    uid=$(id -u "${USER1}")
    ausearch -ua "$uid" 2>&1  |grep "no matches"
    CHECK_RESULT $? -1 1 "ua check fail"
    su - "${USER1}" -c "touch /home/'${USER1}'/testfile"
    ausearch -f /home/"${USER1}"/testfile
    CHECK_RESULT $? -1 1 "ausearch -f fail"
    ausearch -k testfile_audit
    CHECK_RESULT $? -1 1 "testfile_audit check fail"
    ausearch -sv yes
    CHECK_RESULT $? -1 1 "sv yes check fail"
    ausearch -sv no
    CHECK_RESULT $? -1 1 "sv no check fail"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf "${USER1}"
    auditctl -D
    rm -rf test.csv
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
