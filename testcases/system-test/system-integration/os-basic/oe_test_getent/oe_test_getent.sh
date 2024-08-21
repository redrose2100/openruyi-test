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
# @Date      :   2024-05-17
# @License   :   Mulan PSL v2
# @Desc      :   getent命令 – 查看系统数据库中的记录信息
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test()
{
    LOG_INFO "Start to run test."
    getent passwd root |grep root
    CHECK_RESULT $? 0 0 "getent function error"
    getent hosts localhost|grep localhost
    CHECK_RESULT $? 0 0 "getent function error"
    getent group
    CHECK_RESULT $? 0 0 "command execution failed"
    getent group root
    CHECK_RESULT $? 0 0 "root group query failed"
    getent --version|grep getent
    CHECK_RESULT $? 0 0 "version query failed"
    getent --help|grep getent
    CHECK_RESULT $? 0 0 "help query failed"
    LOG_INFO "End to run test."
}

main "$@"
