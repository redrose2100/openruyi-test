#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   shilei
# @Contact   :   shileib@uniontech.com
# @Date      :   2022-2-16
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-tail
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test() {
    LOG_INFO "Start testing..."
    tail --version | grep -E "^tail *"
    CHECK_RESULT $? 0 0 "tail --version display error"

    tail --help | grep "standard output"
    CHECK_RESULT $? 0 0 "tail --help display error"

    tail /etc/passwd | wc -l | grep "10"
    CHECK_RESULT $? 0 0 "tail /etc/passwd display error"

    tail -n 5 /etc/passwd | wc -l | grep "5"
    CHECK_RESULT $? 0 0 "tail -n 5 /etc/passwd display error"


}

main $@
