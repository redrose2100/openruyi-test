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
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/06/06
# @License   :   Mulan PSL v2
# @Desc      :   eu-stack 输入选项-p;输出选项 -v,-b,-1
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
test_log=tmp_test.log
bin_dir=../usr

function pre_test() {
    which eu-stack || yum -y install elfutils
}

function check_stack() {
    local test_file="$1"
    grep "^#[0-9]  0x[0-f]* main$" "$test_file"
    CHECK_RESULT $? 0 0
    grep "^#[0-9]  0x[0-f]* sd_journal_wait$" "$test_file"
    CHECK_RESULT $? 0 0
    grep "^#[0-9]  0x[0-f]* pthread_cond_wait$" "$test_file"
    CHECK_RESULT $? 0 0
}

function run_test() {
    wait_cmd_ok "systemctl status rsyslog" 1 10
    CHECK_RESULT $? 0 0
    # test option -p
    eu-stack -p "$(pidof rsyslogd)" &> ${test_log}_p
    CHECK_RESULT $? 0 0
    grep "PID $(pidof rsyslogd) - process" ${test_log}_p
    CHECK_RESULT $? 0 0 
    test "$(grep 'TID [0-9]*:' ${test_log}_p | wc -l)" -eq "3"
    CHECK_RESULT $? 0 0
    check_stack "${test_log}_p"
    # test option -v
    eu-stack --pid="$(pidof rsyslogd)" -v &> ${test_log}_v
    CHECK_RESULT $? 0 0
    grep "PID $(pidof rsyslogd) - process" ${test_log}_v
    CHECK_RESULT $? 0 0
    test "$(grep 'TID [0-9]*:' ${test_log}_v | wc -l)" -eq "3"
    CHECK_RESULT $? 0 0
    grep "#[0-9]  0x[0-f]* - 1 main - /usr/sbin/rsyslogd" ${test_log}_v
    CHECK_RESULT $? 0 0
    grep "#[0-9]  0x[0-f]* - 1 sd_journal_wait - /usr/lib64/libsystemd.so" ${test_log}_v
    CHECK_RESULT $? 0 0
    grep "#[0-9]  0x[0-f]*.*pthread_cond_wait - /usr/lib64/lib.*.so" ${test_log}_v
    CHECK_RESULT $? 0 0
    # test option -b
    eu-stack -p "$(pidof rsyslogd)" -b &> ${test_log}_b
    CHECK_RESULT $? 0 0
    grep "PID $(pidof rsyslogd) - process" ${test_log}_b
    CHECK_RESULT $? 0 0
    test "$(grep 'TID [0-9]*:' ${test_log}_b | wc -l)" -eq "3"
    CHECK_RESULT $? 0 0
    grep -A1 "#[0-9]  0x[0-f]* main" ${test_log}_b | grep '\[[0-f]*\]@0x[0-f]*+0x[0-f]*'
    CHECK_RESULT $? 0 0
    grep -A1 "#[0-9]  0x[0-f]* sd_journal_wait" ${test_log}_b | grep '\[[0-f]*\]@0x[0-f]*+0x[0-f]*'
    CHECK_RESULT $? 0 0
    grep -A1 "#[0-9]  0x[0-f]* pthread_cond_wait" ${test_log}_b | grep '\[[0-f]*\]@0x[0-f]*+0x[0-f]*'

    CHECK_RESULT $? 0 0
    # test option -1
    eu-stack -p "$(pidof rsyslogd)" -1 &> ${test_log}_1
    CHECK_RESULT $? 0 0
    grep "PID $(pidof rsyslogd) - process" ${test_log}_1
    CHECK_RESULT $? 1 0
    test "$(grep 'TID [0-9]*:' ${test_log}_1 | wc -l)" -eq "1"
    CHECK_RESULT $? 0 0
    grep "#[0-9]  0x[0-f]* main" ${test_log}_1
    CHECK_RESULT $? 0 0
    grep "#[0-9]  0x[0-f]* sd_journal_wait" ${test_log}_1
    CHECK_RESULT $? 1 0
    grep "#[0-9]  0x[0-f]* pthread_cond_wait" ${test_log}_1
    CHECK_RESULT $? 1 0

    # test option --core
    ulimit_core_bak="$(ulimit -c)"
    core_pattern_bak="$(cat /proc/sys/kernel/core_pattern)"
    selinux_bak="$(getenforce)"
    mkdir tmp_core
    ulimit -c unlimited
    setenforce 0
    echo "$(pwd)/tmp_core/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
    # shellcheck disable=SC2046
    kill -6 $(pidof rsyslogd)
    # shellcheck disable=SC2046
    ls -l $(pwd)/tmp_core/core-*
    CHECK_RESULT $? 0 0
    # shellcheck disable=SC2046
    test_core="$(ls $(pwd)/tmp_core/core-*)"
    ulimit -c "$ulimit_core_bak"
    echo "$core_pattern_bak" > /proc/sys/kernel/core_pattern
    setenforce "$selinux_bak"
    # shellcheck disable=SC2086
    eu-stack --core=${test_core} &> ${test_log}_core
    CHECK_RESULT $? 0 0
    check_stack "${test_log}_core"
}

function post_test() {
    cat ${test_log}_p    # debug info
    cat ${test_log}_v    # debug info
    cat ${test_log}_b    # debug info
    cat ${test_log}_1    # debug info
    cat ${test_log}_core # debug info
    yum -y remove elfutils
}

main "$@"

