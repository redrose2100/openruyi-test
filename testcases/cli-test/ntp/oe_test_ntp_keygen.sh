#!/usr/bin/bash
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   郑威
# @Contact   :   zhengwei@uniontech.com
# @Date      :   2026/5/25
# @License   :   Mulan PSL v2
# @Desc      :   Test ntp-keygen for generating authentication keys for NTP
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

TEST_DIR="/tmp/ntp_keygen_test"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    if ! command -v ntp-keygen &> /dev/null; then
        LOG_WARN "ntp-keygen not found, install ntp or ntpsec first"
        CHECK_RESULT 1 0 0 "ntp-keygen command missing"
        return 1
    fi
    rm -rf "${TEST_DIR}"
    mkdir -p "${TEST_DIR}"
    cd "${TEST_DIR}" || LOG_ERROR "Failed to enter test directory"
    LOG_INFO "End of environmental preparation!"
}

function test_help_and_version() {
    LOG_INFO "test: help and version output"
    ntp-keygen --help 2>&1 | grep -q "ntp-keygen"
    CHECK_RESULT $? 0 0 "ntp-keygen --help output missing expected string"
    
    ntp-keygen --version 2>&1 | grep -qE "[0-9]+\.[0-9]"
    CHECK_RESULT $? 0 0 "ntp-keygen --version output missing version number"
}

function test_generate_md5_key() {
    LOG_INFO "test: generate MD5 key file"
    rm -f ntpkey_MD5key_* 2>/dev/null
    
    ntp-keygen -M > keygen.out 2>&1
    CHECK_RESULT $? 0 0 "ntp-keygen -M failed, output: $(cat keygen.out)"
    
    local md5_file=$(ls ntpkey_MD5key_* 2>/dev/null | head -1)
    if [ -z "$md5_file" ]; then
        LOG_ERROR "No MD5 key file generated"
        CHECK_RESULT 1 0 0 "MD5 key file not found"
        return
    fi
    
    if [ ! -s "$md5_file" ]; then
        LOG_ERROR "MD5 key file is empty"
        CHECK_RESULT 1 0 0 "MD5 key file empty"
        return
    fi
    
    LOG_INFO "MD5 key file generated: $md5_file (size: $(stat -c %s "$md5_file") bytes)"
    # 业务验证成功，无需额外 CHECK_RESULT
}

function test_generate_rsa_key() {
    LOG_INFO "test: generate RSA key pair using -T"
    rm -f ntpkey_*host* ntpkey_*RSA* 2>/dev/null
    
    ntp-keygen -T > keygen.out 2>&1
    CHECK_RESULT $? 0 0 "ntp-keygen -T failed, output: $(cat keygen.out)"
    
    # 查找生成的 RSA 相关文件（包含 host 或 RSA）
    local rsa_files=$(ls ntpkey_*host* ntpkey_*RSA* 2>/dev/null)
    if [ -z "$rsa_files" ]; then
        LOG_ERROR "No RSA key files generated (expected ntpkey_*host* or ntpkey_*RSA*)"
        CHECK_RESULT 1 0 0 "No RSA key files generated"
        return
    fi
    
    for f in $rsa_files; do
        if [ ! -s "$f" ]; then
            LOG_ERROR "RSA key file $f is empty"
            CHECK_RESULT 1 0 0 "RSA key file empty"
            return
        fi
        LOG_INFO "RSA key file: $f (size: $(stat -c %s "$f") bytes)"
    done
    
    LOG_INFO "RSA key generation successful"
}

function test_generate_default_key() {
    LOG_INFO "test: generate default host key (no options)"
    local default_dir="${TEST_DIR}/default"
    mkdir -p "${default_dir}"
    pushd "${default_dir}" > /dev/null || return 1
    rm -f ntpkey_* 2>/dev/null
    
    ntp-keygen > keygen.out 2>&1
    CHECK_RESULT $? 0 0 "ntp-keygen (default) failed, output: $(cat keygen.out)"
    
    local default_files=$(ls ntpkey_* 2>/dev/null)
    if [ -z "$default_files" ]; then
        LOG_ERROR "Default ntp-keygen produced no key files"
        CHECK_RESULT 1 0 0 "No default key files"
        popd > /dev/null || return 1
        return
    fi
    
    local found=false
    for f in $default_files; do
        if [ -s "$f" ]; then
            LOG_INFO "Default key file: $f (size: $(stat -c %s "$f") bytes)"
            found=true
        fi
    done
    
    if [ "$found" = false ]; then
        LOG_ERROR "All default key files are empty"
        CHECK_RESULT 1 0 0 "Default key files empty"
    else
        LOG_INFO "Default key generation successful"
    fi
    
    popd > /dev/null || return 1
    rm -rf "${default_dir}"
}

function run_test() {
    LOG_INFO "Start to run test."
    test_help_and_version
    test_generate_md5_key
    test_generate_rsa_key
    test_generate_default_key
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd /tmp
    rm -rf "${TEST_DIR}"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
