#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-4-4
# @License   :   Mulan PSL v2
# @Desc      :   Command openssl hmac
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "start to run test."
    echo -n "abc" | openssl dgst -sm3 -hmac "01234567890123456789012345678901" | grep "(stdin)= ce68f88b05a45a87303a2a3eca942e46d4dce6d06596fa52b3fc0ce43440d5dc"
    CHECK_RESULT $? 0 0 "hmac algorithm with sm3  fail"
    echo -n "abc" | openssl dgst -sha256 -hmac "qwert" | grep "(stdin)= 426053e0418fbaf787e5f8ffcca6a8d10f645eeb77fcfaa11127c716d1c68a35"
    CHECK_RESULT $? 0 0 "hmac algorithm with sha256  fail"
    echo -n "abc" | openssl dgst -sha512 -hmac "qwert" | grep "(stdin)= 85f2c7b305799862f98736ee2f54c311c01038fee2c0ee721da7955bd17f2ce076464d1dcc5349d96b1a80fa8c7d1d0a4187f661be6d199230b4b0a9d0a28929"
    CHECK_RESULT $? 0 0 "hmac algorithm with sha512  fail"
    echo -n "abc" | openssl dgst -md5 -hmac "qwert" | grep "(stdin)= 02ee5c8b3b23be6f68a9113b416a02d5"
    CHECK_RESULT $? 0 0 "hmac algorithm with md5 fail"
    LOG_INFO "End to run test."
}

main "$@"
