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
# @Author    :   lihuan
# @Contact   :   lihuan@uniontech.com
# @Date      :   2024-03-14
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    # 测试非文本文件：检查二进制文件
    file /bin/ls | grep "ELF"
    CHECK_RESULT $? 0 0 "file /bin/ls: not an ELF binary file"

    # 测试目录文件
    file /etc | grep "directory"
    CHECK_RESULT $? 0 0 "file /etc: not a directory file"

    # 测试不存在的文件
    file /nonexistentfile
    CHECK_RESULT $? 0 0 "file /nonexistentfile: file does not exist"

    # 测试软链接
    file /bin/sh | grep "symbolic link"
    CHECK_RESULT $? 0 0 "file /bin/sh: not a symbolic link file"

    LOG_INFO "Finish test!"
}

main "$@"