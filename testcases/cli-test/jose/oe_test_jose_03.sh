#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Test jose jwe use
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	DNF_INSTALL "jose"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    # 生成RSA密钥
    jose jwk gen -i '{"alg":"RSA-OAEP"}' -o rsa.jwk
    CHECK_RESULT $? 0 0 "生成RSA私钥失败"
    jose jwk pub -i rsa.jwk -o rsa.pub.jwk
    CHECK_RESULT $? 0 0 "生成RSA公钥失败"

    # 加密
    echo "secret message" > plain.txt
    jose jwe enc -I plain.txt -k rsa.pub.jwk -o cipher.jwe
    CHECK_RESULT $? 0 0 "加密失败"
    test -s cipher.jwe
    CHECK_RESULT $? 0 0 "密文文件未生成"

    # 解密
    jose jwe dec -i cipher.jwe -k rsa.jwk -O decrypted.txt
    CHECK_RESULT $? 0 0 "解密失败"
    diff plain.txt decrypted.txt
    CHECK_RESULT $? 0 0 "解密内容与原文不一致"

    # 错误密钥解密
    jose jwk gen -i '{"alg":"RSA-OAEP"}' -o wrong.jwk
    jose jwe dec -i cipher.jwe -k wrong.jwk -O /dev/null 2>&1 | grep -i "failed"
    CHECK_RESULT $? 0 0 "错误密钥解密未报错"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf rsa.jwk rsa.pub.jwk wrong.jwk plain.txt cipher.jwe decrypted.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
