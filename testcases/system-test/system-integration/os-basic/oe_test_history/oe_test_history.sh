#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   mataotao
# @Contact   :   mataotao@uniontech.com
# @Date      :   2023-04-14
# @License   :   Mulan PSL v2
# @Desc      :   Command test-history
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    history
    CHECK_RESULT $? 0 0 "check is in history failed"
    ls ./
    history -c
    history |grep ls
    CHECK_RESULT $? 0 1 "clear history command record"
    history -w
    CHECK_RESULT $? 0 0 "history write file failed"
    help history
    CHECK_RESULT $? 0 0 "history write file failed"
    LOG_INFO "End to run test."
}

main "$@"
