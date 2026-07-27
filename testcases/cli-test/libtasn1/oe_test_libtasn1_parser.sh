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
# @Desc      :   libtasn1 asn1Parser command test
# ############################################
# shellcheck disable=SC2119
set -o pipefail
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR=$(dirname "${BASH_SOURCE[0]}")

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "libtasn1"
    cat > "$TEST_DIR/test.asn1" << 'EOF'
Test DEFINITIONS EXPLICIT TAGS ::=
BEGIN
    TestType ::= SEQUENCE {
        id INTEGER,
        name UTF8String
    }
END
EOF
    # 创建非法的 ASN.1 定义文件
    cat > "$TEST_DIR/invalid.asn1" << 'EOF'
Test DEFINITIONS ::= BEGIN
    TestType SEQUENCE {
        id INTEGER
    }
END
EOF
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # 验证 --help 参数输出帮助信息
    asn1Parser --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Parser --help failed"
    # 验证 -h 参数输出帮助信息
    asn1Parser -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "asn1Parser -h failed"
    # 验证 --version 参数输出版本信息
    asn1Parser --version | grep -qE "^asn1Parser \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Parser --version failed"
    # 验证 -v 参数输出版本信息
    asn1Parser -v | grep -qE "^asn1Parser \(libtasn1\) [0-9]+\.[0-9]+\.[0-9]+$"
    CHECK_RESULT $? 0 0 "asn1Parser -v failed"
    # 验证基本解析功能-默认生成 test_asn1_tab.c 文件
    asn1Parser "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser basic failed"
    # 验证生成的C文件非空
    [ -s "$TEST_DIR/test_asn1_tab.c" ]
    CHECK_RESULT $? 0 0 "asn1Parser output file empty"
    # 验证生成的C文件包含模块名
    grep -q '"Test"' "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser output missing module name"
    # 验证生成的C文件包含类型定义
    grep -q '"TestType"' "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser output missing TestType"
    # 验证生成的C文件包含字段名
    grep -q '"id"' "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser output missing id field"
    grep -q '"name"' "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser output missing name field"
    # 验证生成的C文件包含数组定义
    grep -q "asn1_static_node test_asn1_tab\[\]" "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser output missing array definition"
    # 验证 -c参数(语法检查模式）- 能检查合法文件
    asn1Parser -c "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser -c valid failed"
    # 验证 -c 参数拒绝非法文件（缺少 ::=）
    asn1Parser -c "$TEST_DIR/invalid.asn1"
    CHECK_RESULT $? 1 0 "asn1Parser -c should reject invalid"
    # 验证 --check 参数（语法检查模式）- 能检查合法文件
    asn1Parser --check "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser --check valid failed"
    # 验证 --check 参数拒绝非法文件（缺少 ::=）
    asn1Parser --check "$TEST_DIR/invalid.asn1"
    CHECK_RESULT $? 1 0 "asn1Parser --check should reject invalid"
    # 验证 -o 参数（输出C数组文件）
    asn1Parser -o "$TEST_DIR/parser_output.h" "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser -o failed"
    # 验证输出文件非空
    [ -s "$TEST_DIR/parser_output.h" ]
    CHECK_RESULT $? 0 0 "asn1Parser -o file empty"
    # 验证 --output 参数（输出 C 数组文件）
    asn1Parser --output "$TEST_DIR/parser_output.h" "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser --output failed"
    # 验证输出文件非空
    [ -s "$TEST_DIR/parser_output.h" ]
    CHECK_RESULT $? 0 0 "asn1Parser --output file empty"
    # 验证 -n 参数（自定义数组名称）
    asn1Parser -n "test_array" "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser -n failed"
    # 验证生成的文件包含自定义数组名称
    grep -q "asn1_static_node test_array\[\]" "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser -n output missing array name"
    # 验证 --name 参数（自定义数组名称）
    asn1Parser --name "test_array" "$TEST_DIR/test.asn1"
    CHECK_RESULT $? 0 0 "asn1Parser --name failed"
    # 验证生成的文件包含自定义数组名称
    grep -q "asn1_static_node test_array\[\]" "$TEST_DIR/test_asn1_tab.c"
    CHECK_RESULT $? 0 0 "asn1Parser --name output missing array name"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$TEST_DIR/test.asn1" "$TEST_DIR/invalid.asn1" "$TEST_DIR/parser_output.h" "$TEST_DIR/test_asn1_tab.c"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
