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
# @Date      :   2025/07/22
# @License   :   Mulan PSL v2
# @Desc      :   Test jose jws use
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
	# 生成RSA密钥
    jose jwk gen -i '{"alg":"RS256"}' -o rsa.jwk
    jose jwk pub -i rsa.jwk -o rsa.pub.pem

    # 签名
	echo "hello world" > data.txt
    jose jws sig -I data.txt -k rsa.jwk -o data.jws
    CHECK_RESULT $? 0 0 "JWS签名失败"
    test -s data.jws
    CHECK_RESULT $? 0 0 "JWS签名文件未生成"
    # 验签
    jose jws ver -i data.jws -k rsa.pub.pem -O verified.txt
    CHECK_RESULT $? 0 0 "JWS验签失败"
    diff data.txt verified.txt
    CHECK_RESULT $? 0 0 "验签内容不一致"

    # 异常场景：用错误密钥验签
    jose jwk gen -i '{"alg":"RS256"}' -o wrong.jwk
    jose jwk pub -i wrong.jwk -o wrong.pub.pem
    jose jws ver -i data.jws -k wrong.pub.pem -O /dev/null 2>&1 | grep -i "Signature validation failed"
    CHECK_RESULT $? 0 0 "错误密钥验签未报错"

    LOG_INFO "Finish test!"
}

function post_test() {
	LOG_INFO "start environment cleanup."
	rm -rf rsa.jwk rsa.pub.pem wrong.jwk wrong.pub.pem data.txt data.jws verified.txt
	DNF_REMOVE "$@"
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
