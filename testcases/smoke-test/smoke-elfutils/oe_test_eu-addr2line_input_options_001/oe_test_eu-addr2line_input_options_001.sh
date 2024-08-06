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
# @Desc      :   eu-addr2line 输入选择选项 -e -k -M -p
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh > /dev/null
bin_dir=../usr

function pre_test() {
    yum -y install elfutils eu-addr2line
}

function run_test() {
    LOG_INFO "Start to run test."
    # 1 -e  --executable
    main_addr=$(grep -w 'main' $bin_dir/addr2line_main.map | awk '{gsub(/^\s+|\s+$/, "");print $1}')
    line_num=$(grep -nr -A3 'main(' ../usr/addr2line_main.c | grep '{' | awk -F':|-' '{print $1}')
    e_output=$(eu-addr2line "$main_addr" -e $bin_dir/addr2line_main) || el_err "-e exec failed"
    e_expect="package_test/elfutils/usr/addr2line_main.c:$line_num"
    echo "$e_output" | grep -w "$e_expect" || el_err "-e test failed"

    e1_output=$(eu-addr2line "$main_addr" --executable=$bin_dir/addr2line_main) || el_err "--          executable exec failed"
    [ "$e_output" = "$e1_output" ] || el_err "-e and --executable not same"

    # 2 -M   --linux-process-map
    $bin_dir/addr2line_main &
    wait_cmd_ok "ps aux | grep addr2line_main| grep -v grep" 0.5 5
    M_output=$(eu-addr2line "$main_addr" -M /proc/$!/maps) || el_err "-M exec failed"
    [ "$e_output" = "$M_output" ] || el_err "-e and -M not same"

    M1_output=$(eu-addr2line "$main_addr" --linux-process-map=/proc/$!/maps) || el_err "--linux-       process-map exec failed"
    [ "$M_output" = "$M1_output" ] || el_err "-M and --linux-process-map not same"

    # 3 -p  --pid
    p_output=$(eu-addr2line "$main_addr" -p $!) || el_err "-P exec failed"
    [ "$e_output" = "$p_output" ] || el_err "-e and -p not same"

    p1_output=$(eu-addr2line "$main_addr" --pid=$!) || el_err "--pid exec failed"
    [ "$p_output" = "$p1_output" ] || el_err "-p and --pid not same"
    kill -9 $!

    # repo mod
    DNF_INSTALL kernel-debuginfo

    # 4 -k  --kernel
    local fun_name="iov_iter_init"
    test_addr=$(grep -w "${fun_name}" /proc/kallsyms | awk '{print $1}')
    eu-addr2line "$test_addr" -k | grep "??" && el_err "-k exec failed"
    eu-addr2line "$test_addr" --kernel | grep "??" && el_err "--kernel exec failed"

    # 5 -A  --absolute
    A_output=$(eu-addr2line "$test_addr" -k -A) || el_err "-A exec failed"
    echo "$A_output" | grep "??" && el_err "-A test failed"

    A1_output=$(eu-addr2line "$test_addr" -k --absolute) || el_err "--absolute exec failed"
    echo "$A1_output" | grep "??" && el_err "-A test failed"

    [ "$A_output" = "$A1_output" ] || el_err "-A and --absolute not same"
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils eu-addr2line
}

main "$@"
