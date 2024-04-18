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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/07
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of stat
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    stat --help | grep -iE "用法|Usage"
    CHECK_RESULT $? 0 0 "Failed to execute stat --help"
    stat --version | grep "Copyright"
    CHECK_RESULT $? 0 0 "Failed to execute stat --version"
    stat -c %D /etc/passwd | grep -iE "[-0-9]|[a-z]"
    CHECK_RESULT $? 0 0 "Failed to execute stat -c"
    stat --format "%Z" /etc/passwd
    CHECK_RESULT $? 0 0 "Failed to execute stat --format"
    LOG_INFO "End to run test."
}

main "$@"
