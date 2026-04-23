#!/usr/bin/bash
# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Elvis-surfing
# @Contact   :   liuhuiqian@uniontech.com
# @Date      :   2023-08-13
# @License   :   Mulan PSL v2
# @Desc      :   验证 true 命令的返回值、重定向、管道及 shell 控制流行为
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "1111" > /tmp/test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # ========================
    # 1. 基础行为
    # ========================

    true > /tmp/test.txt

    # 返回值
    CHECK_RESULT $? 0 0 "true return value error"

    # 文件内容应被清空
    grep "1111" /tmp/test.txt
    CHECK_RESULT $? 0 1 "true redirection behavior error"

    # 文件存在且为空
    [ -f /tmp/test.txt ]
    CHECK_RESULT $? 0 0 "file not exist after redirection"

    [ -s /tmp/test.txt ]
    CHECK_RESULT $? 1 0 "file should be empty after true redirection"
    
    # ========================
    # 2. 管道行为
    # ========================

    true | false
    CHECK_RESULT $? 1 0 "pipe return value error (true | false)"

    true | true
    CHECK_RESULT $? 0 0 "pipe return value error (true | true)"
 
    # ========================
    # 3. && 行为（应执行后续）
    # ========================

    true && echo "run" > /tmp/and.txt
    grep "run" /tmp/and.txt
    CHECK_RESULT $? 0 0 "&& logic failed for true"

    # ========================
    # 4. || 行为（不应执行）
    # ========================

    true || echo "should_not_run" > /tmp/or.txt
    [ -f /tmp/or.txt ]
    CHECK_RESULT $? 1 0 "|| short-circuit failed for true"

    # ========================
    # 5. 混合逻辑
    # ========================

    true && echo "good" || echo "bad" > /tmp/mix.txt
    grep "good" /tmp/mix.txt
    CHECK_RESULT $? 0 1 "mixed logic failed for true"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt /tmp/and.txt /tmp/or.txt /tmp/mix.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
