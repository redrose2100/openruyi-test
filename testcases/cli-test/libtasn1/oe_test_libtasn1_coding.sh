#!/usr/bin/bash
set -o pipefail
# shellcheck disable=SC2119
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
# @Desc      :   libtasn1 asn1Coding command test
# ############################################
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
        name UTF8String
    }
END
EOF
    cat > "$TEST_DIR/test.asn1val" << 'EOF'
test Test.TestType
id 123
name "test"
EOF
    cat > "$TEST_DIR/invalid.asn1val" << 'EOF'
id 123
name "test"
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # 验证 --help 参数输出帮助信息
    asn1Coding --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Coding --help failed"
    # 验证 -h 参数输出帮助信息
    asn1Coding -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Coding -h failed"
    # 验证 --version 参数输出版本信息
    asn1Coding --version | grep -qE "^asn1Coding \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Coding --version failed"
    # 验证 -v 参数输出版本信息
    asn1Coding -v | grep -qE "^asn1Coding \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Coding -v failed"
    # 验证 -c 参数（语法检查模式）- 能检查合法文件
    asn1Coding -c "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" 2>&1 | grep "Coding: SUCCESS"
    CHECK_RESULT $? 0 0 "asn1Coding -c valid failed"
    # 验证 -c 参数拒绝非法文件（缺少类型声明）
    asn1Coding -c "$TEST_DIR/test.asn1" "$TEST_DIR/invalid.asn1val" > "$TEST_DIR/coding_error.txt" 2>&1
    CHECK_RESULT $? 1 0 "asn1Coding -c should fail for invalid input"
    grep -q "libtasn1 ERROR" "$TEST_DIR/coding_error.txt"
    CHECK_RESULT $? 0 0 "asn1Coding -c should output error message"
    # 验证 --check 参数（语法检查模式）- 能检查合法文件
    asn1Coding --check "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" 2>&1 | grep "Coding: SUCCESS"
    CHECK_RESULT $? 0 0 "asn1Coding --check valid failed"
    # 验证 --check 参数拒绝非法文件（缺少类型声明）
    asn1Coding --check "$TEST_DIR/test.asn1" "$TEST_DIR/invalid.asn1val" > "$TEST_DIR/coding_error.txt" 2>&1
    CHECK_RESULT $? 1 0 "asn1Coding --check should fail for invalid input"
    grep -q "libtasn1 ERROR" "$TEST_DIR/coding_error.txt"
    CHECK_RESULT $? 0 0 "asn1Coding --check should output error message"
    # 验证 -o 参数（输出 DER 编码文件）
    asn1Coding "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" -o "$TEST_DIR/output.der" > "$TEST_DIR/coding_output.txt" 2>&1
    CHECK_RESULT $? 0 0 "asn1Coding -o failed"
    # 验证编码成功
    grep -q "Coding: SUCCESS" "$TEST_DIR/coding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Coding -o Coding SUCCESS failed"
    # 验证输出文件路径
    grep -q "OutputFile=" "$TEST_DIR/coding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Coding -o OutputFile failed"
    # 验证输出文件非空
    [ -s "$TEST_DIR/output.der" ]
    CHECK_RESULT $? 0 0 "asn1Coding output file empty"
    # 验证 --output 参数（输出 DER 编码文件）
    asn1Coding "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" --output "$TEST_DIR/output.der" > "$TEST_DIR/coding_output.txt" 2>&1
    CHECK_RESULT $? 0 0 "asn1Coding --output failed"
    # 验证编码成功
    grep -q "Coding: SUCCESS" "$TEST_DIR/coding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Coding --output Coding SUCCESS failed"
    # 验证输出文件路径
    grep -q "OutputFile=" "$TEST_DIR/coding_output.txt"
    CHECK_RESULT $? 0 0 "asn1Coding --output OutputFile failed"
    # 验证输出文件非空
    [ -s "$TEST_DIR/output.der" ]
    CHECK_RESULT $? 0 0 "asn1Coding --output file empty"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$TEST_DIR/test.asn1" "$TEST_DIR/test.asn1val" "$TEST_DIR/invalid.asn1val" "$TEST_DIR/output.der" "$TEST_DIR/coding_output.txt" "$TEST_DIR/coding_error.txt"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
