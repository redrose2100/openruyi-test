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
# @Author    :   Songsong Wang
# @Contact   :   1693764552@qq.com
# @Date      :   2022/03/19
# @License   :   Mulan PSL v2
# @Desc      :   Test faillock 
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    faillock --user ${NODE1_USER} |grep "Source"
    CHECK_RESULT $? 0 0 "failed to faillock user test"
    faillock --dir /var/run/faillock |grep "Valid"
    CHECK_RESULT $? 0 0 "failed to faillock dir test"
    faillock --reset
    CHECK_RESULT $? 0 0 "failed to faillock reset"
    LOG_INFO "End to run test."
}
main "$@"
