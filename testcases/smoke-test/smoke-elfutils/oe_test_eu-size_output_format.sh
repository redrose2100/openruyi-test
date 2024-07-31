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
# @Date      :   2024/06/04
# @License   :   Mulan PSL v2
# @Desc      :   eu-size 输出格式
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    which eu-size || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-size -A $bin_dir/test_main &> ${test_log}_A
    CHECK_RESULT $? 0 0
    grep "$bin_dir/test_main:" ${test_log}_A
    CHECK_RESULT $? 0 0
    grep "section *size *addr" ${test_log}_A
    CHECK_RESULT $? 0 0
    grep "^.text *[0-9]* *[0-9]*" ${test_log}_A
    CHECK_RESULT $? 0 0
    text_size_A="$(grep '^.text' ${test_log}_A | awk '{print $2}')"
    grep "^.data *[0-9]* *[0-9]*" ${test_log}_A
    CHECK_RESULT $? 0 0
    data_size_A="$(grep '^.data' ${test_log}_A | awk '{print $2}')"
    grep "^.bss *[0-9]* *[0-9]*" ${test_log}_A
    CHECK_RESULT $? 0 0
    bss_size_A="$(grep '^.bss' ${test_log}_A | awk '{print $2}')"
    grep "^Total *[0-9]*" ${test_log}_A
    CHECK_RESULT $? 0 0
    total_size="$(grep '^Total' ${test_log}_A | awk '{print $2}')"
    total_size_hex="$(printf '%x' "${total_size}")"
    eu-size --format=sysv $bin_dir/test_main &> ${test_log}_sysv
    CHECK_RESULT $? 0 0
    diff ${test_log}_A ${test_log}_sysv
    CHECK_RESULT $? 0 0

    eu-size -B $bin_dir/test_main &> ${test_log}_B
    CHECK_RESULT $? 0 0
    grep "text *data *bss *dec *hex *filename" ${test_log}_B
    CHECK_RESULT $? 0 0
    grep "[0-9]* *[0-9]* *[0-9]* *${total_size} *${total_size_hex}* *$bin_dir/test_main" ${test_log}_B
    CHECK_RESULT $? 0 0
    eu-size --format=bsd $bin_dir/test_main &> ${test_log}_bsd
    CHECK_RESULT $? 0 0
    diff ${test_log}_B ${test_log}_bsd
    CHECK_RESULT $? 0 0
    text_size_B="$(grep "$bin_dir/test_main" ${test_log}_B | awk '{print $1}')"
    data_size_B="$(grep "$bin_dir/test_main" ${test_log}_B | awk '{print $2}')"
    bss_size_B="$(grep "$bin_dir/test_main" ${test_log}_B | awk '{print $3}')"

    eu-size -f $bin_dir/test_main &> ${test_log}_f
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_f | awk '{print $1}')" -eq "1"
    CHECK_RESULT $? 0 0
    grep "+ $text_size_A(.text)" ${test_log}_f
    CHECK_RESULT $? 0 0
    grep "+ $data_size_A(.data)" ${test_log}_f
    CHECK_RESULT $? 0 0
    grep "+ $bss_size_A(.bss)" ${test_log}_f
    CHECK_RESULT $? 0 0
    grep " = ${total_size}$" ${test_log}_f
    CHECK_RESULT $? 0 0

    eu-size -d $bin_dir/test_main &> ${test_log}_d
    CHECK_RESULT $? 0 0
    diff ${test_log}_d ${test_log}_B
    CHECK_RESULT $? 0 0

    eu-size -o $bin_dir/test_main &> ${test_log}_o
    CHECK_RESULT $? 0 0
    grep "text *data *bss *dec *hex *filename" ${test_log}_o
    CHECK_RESULT $? 0 0
    if version_compare "${ETS_VERSION}" "<" "V200R010C00"; then
        grep "[0-9]* *[0-9]* *[0-9]* *${total_size} *${total_size_hex}* *$bin_dir/test_main"             ${test_log}_o
        CHECK_RESULT $? 0 0
    else
        grep "$(printf '0%o' "$text_size_B") *$(printf '0%o' "$data_size_B") *$(printf '0%o'             "$bss_size_B") *${total_size} *${total_size_hex} *$bin_dir/test_main" ${test_log}_o
        CHECK_RESULT $? 0 0
    fi

    eu-size -x $bin_dir/test_main &> ${test_log}_x
    CHECK_RESULT $? 0 0
    grep "text *data *bss *dec *hex *filename" ${test_log}_x
    CHECK_RESULT $? 0 0
    if version_compare "${ETS_VERSION}" "<" "V200R010C00"; then
        grep "[0-9]* *[0-9]* *[0-9]* *${total_size} *${total_size_hex}* *$bin_dir/test_main"             ${test_log}_x
        CHECK_RESULT $? 0 0
    else
        grep "$(printf '0x%x' "$text_size_B") *$(printf '0x%x' "$data_size_B") *$(printf '0x%x'          "$bss_size_B") *${total_size} *${total_size_hex} *$bin_dir/test_main" ${test_log}_x
        CHECK_RESULT $? 0 0
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    cat ${test_log}_A # debug info
    cat ${test_log}_B # debug info
    cat ${test_log}_f # debug info
    cat ${test_log}_d # debug info
    cat ${test_log}_o # debug info
    cat ${test_log}_x # debug info
    yum -y remove elfutils
}


main "$@"
