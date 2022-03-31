#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test restorecond.service restart
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    LOG_INFO "No pkgs need to install."

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    fixfiles onboot |grep "System"
    CHECK_RESULT $? 0 0 "failed to fixfiles onboot"
    fixfiles -v -F check |grep "Checking"
    CHECK_RESULT $? 0 0 "failed to check"
    fixfiles -v -F restore |grep "Relabeling"
    CHECK_RESULT $? 0 0 "failed to restore"
    touch N
    echo N > N
    fixfiles relabel < N|grep  "Relabeling"
    CHECK_RESULT $? 0 0 "failed to rekabel"
    #检查bc的安全上下文
    fixfiles -R bc check 
    CHECK_RESULT $? 0 0 "failed to bc"
    fixfiles -R bc restore 
    CHECK_RESULT $? 0 0 "failed to bc restore"
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    test -f N && rm -rf N

    LOG_INFO "End to restore the test environment."
}

main "$@"
