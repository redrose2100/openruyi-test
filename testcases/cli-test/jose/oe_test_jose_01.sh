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
# @Date      :   2025/04/30
# @License   :   Mulan PSL v2
# @Desc      :   Test jose jwk use 01 
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	DNF_INSTALL "jose"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
	LOG_INFO "Start testing..."
	# jose alg 测试
    jose alg
    CHECK_RESULT $? 0 0 "jose alg命令失败"

	#generate RSA private key
	jose jwk gen -i '{"alg":"RS256"}' -o rsa.jwk
	CHECK_RESULT $? 0 0 "jose jwk gen rsa failed"
    test -s rsa.jwk
    CHECK_RESULT $? 0 0 "rsa.jwk not generated"

	#generate ES(P-256) private key
	jose jwk gen -i '{"alg":"ES256"}' -o ec.jwk
	CHECK_RESULT $? 0 0 "jose jwk gen ec failed"
    test -s ec.jwk
    CHECK_RESULT $? 0 0 "ec.jwk not generated"

	# 生成HS256密钥
    jose jwk gen -i '{"alg":"HS256"}' -o hs256.jwk
    CHECK_RESULT $? 0 0 "生成HS256密钥失败"
    test -s hs256.jwk
    CHECK_RESULT $? 0 0 "HS256密钥文件未生成"

	# 异常场景
    jose jwk gen -i '{"alg":"INVALID"}' 2>&1 | grep -i "JWK generation failed!"
    CHECK_RESULT $? 0 0 "invalid alg not detected"
	
	# 错误场景：格式错误
    echo '{invalid json}' > bad.json
    jose jwk gen -i bad.json -o bad.jwk 2>&1 | grep -i "Invalid input!"
    CHECK_RESULT $? 0 0 "格式错误未报错"
	
	LOG_INFO "Finish test!"
}

function post_test() {
	LOG_INFO "start environment cleanup."
	rm -rf rsa.jwk ec.jwk bad.json bad.jwk hs256.jwk
	DNF_REMOVE "$@"
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
