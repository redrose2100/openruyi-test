#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026-05-14
# @License   :   Mulan PSL v2
# @Desc      :   test dmidecode dump/handle/help/quiet/string/types
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dmidecode
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    # help
    dmidecode -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "dmidecode help check failed"

    # quiet
    dmidecode -q > quiet.txt
    CHECK_RESULT $? 0 0 "dmidecode quiet mode failed"
    [ -s quiet.txt ]
    CHECK_RESULT $? 0 0 "quiet output is empty"

    # string
    dmidecode -s system-manufacturer
    CHECK_RESULT $? 0 0 "dmidecode string query failed"

    # types
    dmidecode -t system > type.txt
    CHECK_RESULT $? 0 0 "dmidecode type query failed"
    [ -s type.txt ]
    CHECK_RESULT $? 0 0 "type output is empty"

    # handle
    handle_id=$(dmidecode | grep -m 1 "Handle" | awk '{print $2}' | tr -d ',')
    if [ -n "$handle_id" ]; then
        dmidecode -H "$handle_id"
        CHECK_RESULT $? 0 0 "dmidecode handle query failed"
    else
        LOG_WARN "No valid handle found, skip handle test."
    fi

    # dump
    dmidecode --dump-bin dump.bin
    CHECK_RESULT $? 0 0 "dmidecode dump failed"

    [ -f dump.bin ]
    CHECK_RESULT $? 0 0 "dump file not generated"

    [ -s dump.bin ]
    CHECK_RESULT $? 0 0 "dump file is empty"

    # negative case
    dmidecode -s invalid-string-key > /dev/null 2>&1
    CHECK_RESULT $? 0 1 "invalid string keyword should fail"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf quiet.txt type.txt dump.bin
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

