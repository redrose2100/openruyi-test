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
# @Desc      :   eu-strip 默认执行及--remove-comment选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=../usr

function pre_test() {
    which eu-strip || yum -y install elfutils
}

function run_test() {
    LOG_INFO "Start to run test."
    cp $bin_dir/test_main ./tmp_test_default
    if ! rpm -q binutils; then
        yum -y install binutils
    fi
    readelf -S tmp_test_default > ${test_log}_elf_origin
    CHECK_RESULT $? 0 0
    size_before="$(du -b tmp_test_default | awk '{print $1}')"
    eu-strip tmp_test_default &> ${test_log}
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log})" = ""
    CHECK_RESULT $? 0 0
    size_after="$(du -b tmp_test_default | awk '{print $1}')"
    test "$size_after" -lt "$size_before"
    CHECK_RESULT $? 0 0
    readelf -S tmp_test_default > ${test_log}_elf_strip
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_strip ${test_log}_elf_origin | grep '> *\[[0-9]*\] .symtab'
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_strip ${test_log}_elf_origin | grep '> *\[[0-9]*\] .strtab'
    CHECK_RESULT $? 0 0
    grep '\[[0-9]*\] .comment' ${test_log}_elf_strip
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_strip ${test_log}_elf_origin # debug info

    cp $bin_dir/test_main ./tmp_test_comment
    readelf -S tmp_test_comment > ${test_log}_elf_origin
    CHECK_RESULT $? 0 0
    size_before_1="$(du -b tmp_test_comment | awk '{print $1}')"
    eu-strip --remove-comment tmp_test_comment &> ${test_log}_comment
    CHECK_RESULT $? 0 0
    test "$(cat ${test_log}_comment)" = ""
    CHECK_RESULT $? 0 0
    size_after_1="$(du -b tmp_test_comment | awk '{print $1}')"
    test "$size_after_1" -lt "$size_before_1"
    CHECK_RESULT $? 0 0
    readelf -S tmp_test_comment > ${test_log}_elf_comment
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_comment ${test_log}_elf_origin | grep '> *\[[0-9]*\] .symtab'
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_comment ${test_log}_elf_origin | grep '> *\[[0-9]*\] .strtab'
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_comment ${test_log}_elf_origin | grep '> *\[[0-9]*\] .comment'
    CHECK_RESULT $? 0 0
    diff ${test_log}_elf_comment ${test_log}_elf_origin # debug info
    LOG_INFO "End to run test."
}

function post_test() {
    cat ${test_log}_elf_origin # debug info
    yum -y remove elfutils binutils
}

main "$@"
