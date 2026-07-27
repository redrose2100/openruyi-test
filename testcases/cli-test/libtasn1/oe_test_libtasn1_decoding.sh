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
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-24
# @License   :   Mulan PSL v2
# @Desc      :   libtasn1 asn1Decoding command test
# ############################################
# shellcheck disable=SC2119
set -o pipefail
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR=$(dirname "${BASH_SOURCE[0]}")

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "libtasn1"
    # 创建 ASN.1 定义文件
    cat > "$TEST_DIR/test.asn1" << 'EOF'
Test DEFINITIONS EXPLICIT TAGS ::=
BEGIN
    TestType ::= SEQUENCE {
        id INTEGER,
        name UTF8String,
        time UTCTime
    }
END
EOF
    # 创建值分配文件
    cat > "$TEST_DIR/test.asn1val" << 'EOF'
test Test.TestType

id 123
name test
time 230101000000Z
EOF
    # 生成合法的 DER 编码文件
    asn1Coding "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" -o "$TEST_DIR/valid.der"
    # 创建时间字段不符合严格规则的文件（UTCTime 使用非标准格式：缺少时区标记）
    printf '\x30\x17\x02\x01\x7b\x0c\x04\x74\x65\x73\x74\x17\x0c\x32\x33\x30\x31\x30\x31\x30\x30\x30\x30\x30\x30' > "$TEST_DIR/bad_time.der"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # 验证 --help 参数输出帮助信息
    asn1Decoding --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Decoding --help failed"
    # 验证 -h 参数输出帮助信息
    asn1Decoding -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Decoding -h failed"
    # 验证 --version 参数输出版本信息
    asn1Decoding --version | grep -qE "^asn1Decoding \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Decoding --version failed"
    # 验证 -v 参数输出版本信息
    asn1Decoding -v | grep -qE "^asn1Decoding \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Decoding -v failed"
    # 验证基本解码功能-能解码合法的 DER 文件
    asn1Decoding "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType > "$TEST_DIR/decoding_output.txt" 2>&1
    CHECK_RESULT $? 0 0 "asn1Decoding basic failed"
    # 验证解码成功提示
    grep -q "Decoding: SUCCESS" "$TEST_DIR/decoding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Decoding basic success failed"
    # 验证整数解码正确（value:0x7b = 123）
    grep -q "value:0x7b" "$TEST_DIR/decoding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Decoding basic integer failed"
    # 验证字符串解码正确
    grep -q "name:name  type:UTF8_STR  value:test" "$TEST_DIR/decoding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Decoding basic string failed"
    # 验证时间类型识别正确
    grep -q "UTC_TIME" "$TEST_DIR/decoding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Decoding basic time type failed"
    # 验证时间值解码正确
    grep -q "value:230101000000Z" "$TEST_DIR/decoding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Decoding basic time value failed"
    # 验证 -s 参数（严格 DER 解码模式）- 能解码合法文件
    asn1Decoding -s "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding -s valid failed"
    # 验证 -s 参数拒绝时间字段非严格的文件）
    asn1Decoding -s "$TEST_DIR/test.asn1" "$TEST_DIR/bad_time.der" Test.TestType >/dev/null 2>&1
    CHECK_RESULT $? 1 0 "asn1Decoding -s bad_time should fail"
    # 验证 --strict 参数（严格 DER 解码模式）- 能解码合法文件
    asn1Decoding --strict "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding --strict valid failed"
    # 验证 --strict 参数拒绝时间字段非严格的文件
    asn1Decoding --strict "$TEST_DIR/test.asn1" "$TEST_DIR/bad_time.der" Test.TestType >/dev/null 2>&1
    CHECK_RESULT $? 1 0 "asn1Decoding --strict bad_time should fail"
    # 验证 -t 参数（时间字段非严格模式）- 能解码合法文件
    asn1Decoding -t "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding -t valid failed"
    # 验证 -t 参数能解码时间字段非严格的文件（缺少秒数）
    asn1Decoding -t "$TEST_DIR/test.asn1" "$TEST_DIR/bad_time.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding -t bad_time failed"
    # 验证 --no-time-strict 参数（时间字段非严格模式）- 能解码合法文件
    asn1Decoding --no-time-strict "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding --no-time-strict valid failed"
    # 验证 --no-time-strict 参数能解码时间字段非严格的文件
    asn1Decoding --no-time-strict "$TEST_DIR/test.asn1" "$TEST_DIR/bad_time.der" Test.TestType | grep -q "value:0x7b"
    CHECK_RESULT $? 0 0 "asn1Decoding --no-time-strict bad_time failed"
    # 验证 -b 参数（基准测试模式）
    asn1Decoding -b "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "asn1Decoding -b failed"
    # 验证 --benchmark 参数（基准测试模式）
    asn1Decoding --benchmark "$TEST_DIR/test.asn1" "$TEST_DIR/valid.der" Test.TestType >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "asn1Decoding --benchmark failed"
    # 验证无参数执行失败
    asn1Decoding >/dev/null 2>&1
    CHECK_RESULT $? 1 0 "asn1Decoding no args should fail"
    # 验证不存在的 DER 文件执行失败
    asn1Decoding "$TEST_DIR/test.asn1" "$TEST_DIR/nonexist.der" Test.TestType >/dev/null 2>&1
    CHECK_RESULT $? 1 0 "asn1Decoding nonexist file should fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" "$TEST_DIR/valid.der" "$TEST_DIR/bad_time.der" "$TEST_DIR/decoding_output.txt"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
