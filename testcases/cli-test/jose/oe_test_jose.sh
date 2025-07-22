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
# @Desc      :   Test jose jwk use
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	DNF_INSTALL "jose"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
	LOG_INFO "Start testing..."
	#generate RSA private key
	jose jwk gen -i '{"alg":"RS256"}' -o rsa.jwk
	CHECK_RESULT $? 0 0 "jose jwk gen rsa failed"
    test -s rsa.jwk
    CHECK_RESULT $? 0 0 "rsa.jwk not generated"

	#convert RSA JWK to PEM
	jose jwk pub -i rsa.jwk -o rsa.pub.pem
	CHECK_RESULT $? 0 0 "jose jwk pub to pem failed"
	test -s rsa.pub.pem    
	CHECK_RESULT $? 0 0 "rsa.pub.pem not generated"

	#generate ES(P-256) private key
	jose jwk gen -i '{"alg":"ES256"}' -o ec.jwk
	CHECK_RESULT $? 0 0 "jose jwk gen ec failed"
    test -s ec.jwk
    CHECK_RESULT $? 0 0 "ec.jwk not generated"

	# 异常场景
    jose jwk gen -i '{"alg":"INVALID"}' 2>&1 | grep -i "JWK generation failed!"
    CHECK_RESULT $? 0 0 "invalid alg not detected"
	
	LOG_INFO "Finish test!"
}

function post_test() {
	LOG_INFO "start environment cleanup."
	rm -rf rsa.jwk rsa.pub.pem ec.jwk
	DNF_REMOVE "$@"
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
