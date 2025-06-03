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
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   可维护性——journalctl命令
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test()
{
    LOG_INFO "Start testing..."
    journalctl --no-pager > all_log
    CHECK_RESULT $? 0 0 "journalctl --no-pager failed"
    grep -E "LVM|NetworkManager" all_log
    CHECK_RESULT $? 0 0 "grep LVM|NetworkManager failed"

    journalctl -k --no-pager &> kernel_log
    CHECK_RESULT $? 0 0 "journalctl -k -no-pager failed"
    grep -iE "kernel|systemd" kernel_log
    CHECK_RESULT $? 0 0 "grep kernel|systemd failed"

    journalctl -b --no-pager > boot_log
    CHECK_RESULT $? 0 0 "journalctl -b failed"
    grep -i "systemd" boot_log
    CHECK_RESULT $? 0 0 "boot log content check failed"
    
    # 测试时间范围过滤
    journalctl --since "1 hour ago" --no-pager > time_log
    CHECK_RESULT $? 0 0 "journalctl time filter failed"
    grep "localhost.localdomain" time_log
    CHECK_RESULT $? 0 0 "time filter log content check failed"
    
    # 测试优先级过滤
    journalctl -p err --no-pager > priority_log
    CHECK_RESULT $? 0 0 "journalctl priority filter failed"
    grep -i "error" priority_log
    CHECK_RESULT $? 0 0 "priority filter log content check failed"
    
    # 测试输出格式
    journalctl -o json --no-pager > json_log
    CHECK_RESULT $? 0 0 "journalctl json output failed"
    grep "{" json_log
    CHECK_RESULT $? 0 0 "json format check failed"
    
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "start environment cleanup."
    rm -rf ./*log*
    LOG_INFO "Finsh environment cleanup! "
}

main "$@"