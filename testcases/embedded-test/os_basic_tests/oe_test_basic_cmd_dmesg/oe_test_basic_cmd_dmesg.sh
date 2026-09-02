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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   Query boot information-dmesg
# #############################################

# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."

    if command -v dmesg &>/dev/null; then
        dmesg | grep -iE "Linux version|Booting Linux on|smpboot|SBI|sbi|cpu|kernel"
        if [ $? -ne 0 ] && [ -f /var/log/kern.log ]; then
            cat /var/log/kern.log | grep -iE "Linux version|Booting Linux on|smpboot|SBI|sbi|cpu|kernel"
        fi
        CHECK_RESULT $? 0 0 "check dmesg one time fail"

        dmesg | grep -iE "Linux version|Booting Linux on|smpboot|systemd|kernel|cpu" >/dev/null
        if [ $? -ne 0 ] && [ -f /var/log/kern.log ]; then
            cat /var/log/kern.log | grep -iE "Linux version|Booting Linux on|smpboot|systemd|kernel|cpu" >/dev/null
        fi
        CHECK_RESULT $? 0 0 "check dmesg second time fail"
    else
        journalctl -k | grep -iE "Linux version|Booting Linux on|smpboot|SBI|sbi|cpu|kernel"
        CHECK_RESULT $? 0 0 "check dmesg one time fail"

        journalctl -k | grep -iE "Linux version|Booting Linux on|smpboot|systemd|kernel|cpu" >/dev/null
        CHECK_RESULT $? 0 0 "check dmesg second time fail"
    fi

    LOG_INFO "End to run test."
}

main "$@"

