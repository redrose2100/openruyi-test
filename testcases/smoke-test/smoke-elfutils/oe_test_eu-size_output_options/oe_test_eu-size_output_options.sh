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
# @Date      :   2024/06/05
# @License   :   Mulan PSL v2
# @Desc      :   eu-size 输出选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=../usr

function pre_test() {
    which eu-size || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    cp $bin_dir/test_main tmp_test_main_1
    eu-size -t $bin_dir/test_main tmp_test_main_1 &> ${test_log}_t
    CHECK_RESULT $? 0 0
    grep "text *data *bss *dec *hex *filename" ${test_log}_t
    CHECK_RESULT $? 0 0
    test "$(grep $bin_dir/test_main ${test_log}_t | awk '{$NF="";print}')" = "$(grep tmp_test_main_1 ${test_log}_t | awk '{$NF="";print}')"
    CHECK_RESULT $? 0 0
    text_size="$(grep $bin_dir/test_main ${test_log}_t | awk '{print $1}')"
    date_size="$(grep $bin_dir/test_main ${test_log}_t | awk '{print $2}')"
    bss_size="$(grep $bin_dir/test_main ${test_log}_t | awk '{print $3}')"
    total_size="$(expr "$text_size" + "$date_size" + "$bss_size")"
    grep "$((text_size + text_size)) *$((date_size + date_size)) *$((bss_size + bss_size)) *$((total_size + total_size)) *$(printf "%x" $((total_size + total_size))) *(TOTALS)" ${test_log}_t
    CHECK_RESULT $? 0 0

    eu-size -F $bin_dir/test_main tmp_test_main_1 &> ${test_log}_F
    CHECK_RESULT $? 0 0
    test "$(wc -l ${test_log}_F | awk '{print $1}')" -eq "2"
    CHECK_RESULT $? 0 0
    head -1 ${test_log}_F | grep "[0-9]*([rwx-]\{3\}) + [0-9]*([rwx-]\{3\}) = [0-9]*"
    CHECK_RESULT $? 0 0
    test "$(head -1 ${test_log}_F)" = "$(tail -1 ${test_log}_F)"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    cat ${test_log}_t # debug info
    cat ${test_log}_F # debug info
    yum -y remove elfutils
}

main "$@"
