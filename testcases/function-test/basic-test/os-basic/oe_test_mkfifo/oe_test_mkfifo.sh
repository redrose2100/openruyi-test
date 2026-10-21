#!/usr/bin/bash
# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024-04-22
# @License   :   Mulan PSL v2
# @Desc      :   mkfifo命令 – 创建FIFO文件
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test()
{
    LOG_INFO "Start to run test."
    mkfifo /tmp/testfifo
    CHECK_RESULT $? 0 0 "mkfifo function error"
    ls /tmp/testfifo
    CHECK_RESULT $? 0 0 "mkfifo function error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/testfifo
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
