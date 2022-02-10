#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2021-11-30
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-file
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function run_test() {
    LOG_INFO "Start testing..."
    file -v
    CHECK_RESULT $? 0 0 "file -v display error"

    file --help
    CHECK_RESULT $? 0 0 "file --help display error"

    file /etc/passwd | grep "/etc/passwd: ASCII text"
    CHECK_RESULT $? 0 0 "file /etc/passwd display error"

    file -b /etc/passwd | grep "ASCII text"
    CHECK_RESULT $? 0 0 "file -b /etc/passwd display error"

    file -i /etc/passwd  | grep "/etc/passwd: text/plain; charset=us-ascii"
    CHECK_RESULT $? 0 0 "file -i /etc/passwd display error"

}

main $@
