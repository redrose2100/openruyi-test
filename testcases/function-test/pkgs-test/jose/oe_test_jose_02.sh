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
# @Desc      :   Test jose jwk use 02
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
    DNF_INSTALL "diffutils"
	DNF_INSTALL "jose"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    # 生成ES256密钥
    jose jwk gen -i '{"alg":"ES256"}' -o ec.jwk
    CHECK_RESULT $? 0 0 "jose jwk gen ec failed"
    test -s ec.jwk
    CHECK_RESULT $? 0 0 "ec.jwk not generated"

    # 导出公钥PEM
    jose jwk pub -i ec.jwk -o ec_pub.pem
    CHECK_RESULT $? 0 0 "ec.jwk公钥导出PEM失败"

    # 导出公钥JWK
    jose jwk pub -i ec.jwk -o ec_pub.jwk
    CHECK_RESULT $? 0 0 "ec.jwk公钥导出JWK失败"

    # jwk eql 判断两个JWK是否相等（公钥JWK自比）
    jose jwk eql -i ec_pub.jwk -i ec_pub.jwk
    CHECK_RESULT $? 0 0 "jwk eql命令失败"

    # jwk thp 计算JWK thumbprint
    jose jwk thp -i ec.jwk -o ec.thp
    CHECK_RESULT $? 0 0 "jwk thp命令失败"
    test -s ec.thp
    CHECK_RESULT $? 0 0 "jwk thp未生成输出"

    # jose b64 enc 测试
    echo 'hello-jose-b64' > b64_input.txt
    jose b64 enc -I b64_input.txt -o b64_encoded.txt
    CHECK_RESULT $? 0 0 "jose b64 enc命令失败"
    encoded=$(cat b64_encoded.txt)
    echo "$encoded" | grep -E '^[A-Za-z0-9_-]+$'
    CHECK_RESULT $? 0 0 "base64编码输出格式不正确"

    # jose b64 dec 测试
    jose b64 dec -i b64_encoded.txt -O b64_decoded.txt
    CHECK_RESULT $? 0 0 "jose b64 dec命令失败"
    diff b64_input.txt b64_decoded.txt
    CHECK_RESULT $? 0 0 "base64解码结果与原文不一致"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ec.jwk ec_pub.pem ec_pub.jwk ec.thp b64_input.txt b64_encoded.txt b64_decoded.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
