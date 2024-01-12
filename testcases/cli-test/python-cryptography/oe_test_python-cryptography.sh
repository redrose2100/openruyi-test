#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2024/1/12
# @License   :   Mulan PSL v2
# @Desc      :   test sox
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python-cryptography-help python-cryptography"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > /tmp/test.py << EOF
from cryptography.fernet import Fernet

# 生成加密密钥
key = Fernet.generate_key()

# 使用密钥加密数据
fernet = Fernet(key)
encrypted = fernet.encrypt(b"Hello, world!")

# 使用密钥解密数据
decrypted = fernet.decrypt(encrypted)

# 打印输出结果
print("Original message:\n", "Hello, world!")
print("Encrypted message:\n", encrypted)
print("Decrypted message:\n", decrypted)
EOF
    CHECK_RESULT $? 0 0 "Error,Please check the file 'test.py'"
    python3 /tmp/test.py > /tmp/test.txt
    grep "b'gAAAAAB" /tmp/test.txt
    CHECK_RESULT $? 0 0 "Encryption failure"
    grep "b'Hello, world" /tmp/test.txt
    CHECK_RESULT $? 0 0 "Decryption failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm /tmp/test.py /tmp/test.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
