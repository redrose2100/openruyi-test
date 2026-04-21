 #!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   maojiasheng
# @Contact   :   maojiasheng@uniontech.com
# @Date      :   2026.04.21
# @License   :   Mulan PSL v2
# @Desc      :   type formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "1111" > /tmp/test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # 1. 返回值测试
    false
    CHECK_RESULT $? 1 0 "false return value error"

    # 2. 重定向测试（应清空文件）
    false > /tmp/test.txt

    grep "1111" /tmp/test.txt
    CHECK_RESULT $? 1 0 "false redirection behavior error"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

