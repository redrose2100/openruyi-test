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
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   验证filecap参数
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
path="$PATH"
testfile=test"$RANDOM"
location=$(pwd)/"$testfile"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which filecap || DNF_INSTALL "libcap libcap-ng libcap-ng-utils"
    cat /sys/kernel/tracing/buffer_size_kb
    def_val=$(awk '{print $NF}' /sys/kernel/tracing/buffer_size_kb | cut -d ')' -f 1)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    #创建一个文件并添加capabilities
    touch "$testfile" && filecap "$location" sys_time

    #验证-d参数
    capsh --print | grep Bounding | awk -F"=" '{print $2}' | sed 's/cap_//g;s/,/ /g' > set_info 2>&1
    filecap -d > filecap_d_info 2>&1
    while read -r line || [[ -n $line ]];do 
         grep -i "$line" set_info
         CHECK_RESULT $? 0 0 "Check filecap -d failed"
    done < filecap_d_info

    #验证filecap -a参数
    filecap -a > filecap_a_info 2>&1
    grep "$testfile" < filecap_a_info && grep "sys\_time" < filecap_a_info
    CHECK_RESULT $? 0 0 "Check filecap -a failed"

    #验证filecap命令
    filecap | grep "$testfile" | grep "sys\_time"
    CHECK_RESULT $? 1 0 "Check filecap failed"
    #添加到环境变量后验证filecap命令
    PATH="$PATH":$(pwd)
    filecap | grep "$testfile" | grep "sys\_time"
    CHECK_RESULT $? 0 0 "After add PATH,check filecap failed"
}

function post_test() {
    echo "${def_val}" > /sys/kernel/tracing/buffer_size_kb
    cat /sys/kernel/tracing/buffer_size_kb
    filecap "$location" none
    rm -rf set_info filecap_d_info filecap_a_info longfile /root/testdir "$testfile"
    PATH="$path"
    DNF_REMOVE "$@"
}

main "$@"