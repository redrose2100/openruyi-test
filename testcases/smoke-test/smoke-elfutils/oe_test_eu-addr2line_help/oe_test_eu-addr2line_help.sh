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
# @Date      :   2024/06/03
# @License   :   Mulan PSL v2
# @Desc      :   eu-addr2line/eu-ar/eu-elfclassify/eu-elfcmp/eu-elflint/eu-elfcompress/eu-stack/eu-strings 帮助信息
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ../common.sh
source ./help_info_local
source ./usage_info_local

function pre_test() {
    yum install -y elfutils eu-addr2line
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-addr2line -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_addr2line_help[@]}"
    eu-addr2line --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-addr2line --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_addr2line_usage[@]}"
    check_version_info eu-addr2line

    eu-ar -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_ar_help[@]}"
    eu-ar --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-ar --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_ar_usage[@]}"
    check_version_info eu-ar

    eu-elfclassify -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_elfclassify_help[@]}"
    eu-elfclassify --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-elfclassify --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_elfclassify_usage[@]}"
    check_version_info eu-elfclassify

    eu-elfcmp -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_elfcmp_help[@]}"
    eu-elfcmp --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-elfcmp --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_elfcmp_usage[@]}"
    check_version_info eu-elfcmp

    eu-elflint -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_elflint_help[@]}"
    eu-elflint --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-elflint --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_elflint_usage[@]}"
    check_version_info eu-elflint

    eu-elfcompress -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_elfcompress_help[@]}"
    eu-elfcompress --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-elfcompress --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_elfcompress_usage[@]}"
    check_version_info eu-elfcompress

    eu-stack -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_stack_help[@]}"
    eu-stack --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-stack --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_stack_usage[@]}"
    check_version_info eu-stack

    eu-strings -? &> tmp_help.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_help.log "${eu_strings_help[@]}"
    eu-strings --help &> tmp_help.log1
    CHECK_RESULT $? 0 0
    check_help_info
    eu-strings --usage &> tmp_usage.log
    CHECK_RESULT $? 0 0
    check_log_info tmp_usage.log "${eu_strings_usage[@]}"
    check_version_info eu-strings

}

function post_test() {
    yum remove -y elfutils eu-addr2line
}

main "$@"
