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
    cat all_log | grep -E "LVM|NetworkManager"
    CHECK_RESULT $? 0 0 "grep LVM|NetworkManager failed"
    journalctl -k --no-pager &> kernel_log
    cat kernel_log | grep -i "NetworkManager"
    CHECK_RESULT $? 0 1 "NetworkManager exist"
    journalctl -b --no-pager > boot_log
    CHECK_RESULT $? 0 0 "journalctl -b failed"
    LOG_INFO "Finish test!"
}
function post_test()
{
    LOG_INFO "start environment cleanup."
    rm -rf *log
    LOG_INFO "Finsh environment cleanup! "
}

main $@
