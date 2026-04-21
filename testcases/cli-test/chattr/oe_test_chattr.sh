#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2026/04/09
# @License   :   Mulan PSL v2
# @Desc      :   test chattr
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "e2fsprogs"
    # 创建测试目录和文件
    TEST_DIR="/tmp/chattr_test"
    mkdir -p ${TEST_DIR}
    cd ${TEST_DIR}
    echo "test content" > testfile.txt
    echo "another file" > another.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 步骤1：测试 +i 属性（不可修改）
    LOG_INFO "Step 1: Test +i attribute (immutable)"
    chattr +i testfile.txt
    CHECK_RESULT $? 0 0 "chattr +i failed"
    lsattr testfile.txt | grep -q "i"
    CHECK_RESULT $? 0 0 "lsattr +i check failed"
    echo "new line" >> testfile.txt 2>/dev/null
    CHECK_RESULT $? 0 1 "Write should fail with +i attribute"
    rm -f testfile.txt 2>/dev/null
    CHECK_RESULT $? 0 1 "Delete should fail with +i attribute"
    chattr -i testfile.txt
    CHECK_RESULT $? 0 0 "chattr -i failed"

    # 步骤2：测试 +a 属性（只追加）
    LOG_INFO "Step 2: Test +a attribute (append only)"
    chattr +a testfile.txt
    CHECK_RESULT $? 0 0 "chattr +a failed"
    lsattr testfile.txt | grep -q "a"
    CHECK_RESULT $? 0 0 "lsattr +a check failed"
    echo "append line" >> testfile.txt
    CHECK_RESULT $? 0 0 "Append operation should succeed"
    echo "overwrite" > testfile.txt 2>/dev/null
    CHECK_RESULT $? 0 1 "Overwrite should fail with +a attribute"
    chattr -a testfile.txt
    CHECK_RESULT $? 0 0 "chattr -a failed"

    # 步骤3：测试递归设置属性（-R 选项）
    LOG_INFO "Step 3: Test recursive attribute with -R option"
    mkdir -p testdir/subdir
    echo "subfile content" > testdir/subdir/file.txt
    chattr -R +i testdir/
    CHECK_RESULT $? 0 0 "chattr -R +i failed"
    lsattr testdir/subdir/file.txt | grep -q "i"
    CHECK_RESULT $? 0 0 "Recursive attribute check failed"
    chattr -R -i testdir/
    CHECK_RESULT $? 0 0 "chattr -R -i failed"

    # 步骤4：测试帮助信息
    LOG_INFO "Step 4: Test help information"
    chattr -h 2>&1 | grep -qi "Usage: chattr"
    CHECK_RESULT $? 0 0 "chattr help information missing"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # 移除可能残留的属性
    chattr -R -i /tmp/chattr_test 2>/dev/null
    chattr -a /tmp/chattr_test/testfile.txt 2>/dev/null
    # 删除测试目录
    rm -rf /tmp/chattr_test
    # shellcheck disable=SC2119
    DNF_REMOVE "e2fsprogs"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

