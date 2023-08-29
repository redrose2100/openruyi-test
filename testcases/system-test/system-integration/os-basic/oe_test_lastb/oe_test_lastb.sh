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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023-03-27
# @License   :   Mulan PSL v2
# @Desc      :   Command test-lastb
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    lastb |grep -i btmp
    CHECK_RESULT $? 0 0 "default option result failed "
    lastb -n 5
    CHECK_RESULT $? 0 0 "-n option result failed"
    lastb -h |grep -E "Usage|用法"
    CHECK_RESULT $? 0 0 "-h option result failed"
    lastb -V |grep -i lastb
    CHECK_RESULT $? 0 0 "-V option result failed"
    LOG_INFO "End to run test."
}

main "$@"



