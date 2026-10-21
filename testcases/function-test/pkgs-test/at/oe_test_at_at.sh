#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   deepin12
# @Contact   :   chenyia@uniontech.com
# @Date      :   2024-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test-at
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "at"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    at 15:30 -f /usr/bin/ls
    CHECK_RESULT $? 0 0 "description failed to generate log files"
    atq |grep "15:30"
    CHECK_RESULT $? 0 0 "the scheduled task at 15:30 is not checked"
    echo "hello world" | at 14:30 -m
    CHECK_RESULT $? 0 0 "the scheduled task at 14:30 is not checked"
    atq |grep "14:30"
    CHECK_RESULT $? 0 0 "failed to enter using the file"
    echo "hello world" | at -q b 15:31
    CHECK_RESULT $? 0 0 "only the root user fails to be displayed"
    atq |grep "15:31"|grep b
    CHECK_RESULT $? 0 0 "the scheduled task at 15:31 and b is not checked"
    at -V
    CHECK_RESULT $? 0 0 "failed to filter tty login users. Procedure"
    
    # 新增测试参数1：测试at命令的-l参数（列出用户的at队列）
    LOG_INFO "Testing at command with -l parameter"
    at 16:00 -f /usr/bin/date
    CHECK_RESULT $? 0 0 "Failed to create at job for -l test"
    at -l
    CHECK_RESULT $? 0 0 "Failed to list at queue with -l parameter"
    at -l | grep "16:00"
    CHECK_RESULT $? 0 0 "The scheduled task at 16:00 is not found in -l output"
    
    # 新增测试参数2：测试at命令的-d参数（删除指定的作业）
    LOG_INFO "Testing at command with -d parameter"
    at 17:00 -f /usr/bin/whoami
    CHECK_RESULT $? 0 0 "Failed to create at job for -d test"
    JOB_ID=$(at -l | grep "17:00" | awk '{print $1}')
    CHECK_RESULT $? 0 0 "Failed to get job ID for deletion"
    at -d "$JOB_ID"
    CHECK_RESULT $? 0 0 "Failed to delete at job with -d parameter"
    at -l | grep "17:00"
    CHECK_RESULT $? 0 1 "The deleted job still exists in queue"
    
    # 新增测试参数3：测试at命令的-c参数（显示作业内容）
    LOG_INFO "Testing at command with -c parameter"
    echo "echo 'test content for -c parameter'" > /tmp/test_at_c.sh
    at 18:00 -f /tmp/test_at_c.sh
    CHECK_RESULT $? 0 0 "Failed to create at job for -c test"
    JOB_ID_C=$(at -l | grep "18:00" | awk '{print $1}')
    CHECK_RESULT $? 0 0 "Failed to get job ID for content display"
    at -c "$JOB_ID_C"
    CHECK_RESULT $? 0 0 "Failed to display job content with -c parameter"
    at -c "$JOB_ID_C" | grep "test content for -c parameter"
    CHECK_RESULT $? 0 0 "Job content does not match expected output"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG=${OLD_LANG}
    # 清理测试过程中创建的临时文件
    rm -f /tmp/test_at_c.sh
    # 清理所有at作业
    atq | awk '{print $1}' | xargs -I jobID atrm jobID 2>/dev/null || true
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"


