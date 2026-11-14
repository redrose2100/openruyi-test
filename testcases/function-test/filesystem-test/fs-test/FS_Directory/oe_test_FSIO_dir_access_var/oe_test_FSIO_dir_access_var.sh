#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /var
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    cur_lang="$LANG"
    export LANG=en_US.UTF-8
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # crash、kerberos、account 等目录由 crash、krb5-libs、psacct 等独立包提供，
    # openEuler RISC-V 镜像与 openRuyi 等精简发行版默认不安装这些包。缺少目录
    # 属于安装包差异而非目录权限异常，跳过而不判失败。
    optional_var_dir="crash kerberos account"
    actual_name=$(ls /var)
    while read -r rows; do
        [ -n "$rows" ] || continue
        if [[ $actual_name =~ $rows ]]; then 
            continue
        fi
        if [[ " $optional_var_dir " == *" $rows "* ]]; then
            LOG_WARN "/var/$rows is not provided by this distribution, skip it."
            continue
        fi
        CHECK_RESULT 1 0 0 "The file under /var is error."
        break
    done <./expect_name
    actual_access=$(find /var -maxdepth 1  ! -name "." ! -name ".." ! -name ".*"  ! -name "named" -exec stat -c "%A" {} + | grep -Ev "^total$" | sort | uniq)
    while read rows; do
        if [[ $actual_access =~ $rows ]]; then 
            continue
        fi
        CHECK_RESULT 1 0 0 "The access of file under /var is error."
        break
    done <./expect_access
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$cur_lang
    LOG_INFO "End to restore the test environment."
}

main "$@"

