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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2026-5-6
# @License   :   Mulan PSL v2
# @Desc      :   Command certutil test
# ############################################
# shellcheck disable=SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nss-util
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    
    # Create test directories and files
    TEST_DIR="/tmp/certutil_test"
    DB_DIR="$TEST_DIR/nss_db"
    SRC_DB_DIR="$TEST_DIR/src_nss_db"
    TMP_DIR="$TEST_DIR/tmp"
    mkdir -p "$DB_DIR" "$SRC_DB_DIR" "$TMP_DIR"
    
    # Temporary files
    CERT_FILE="$TMP_DIR/test_cert.pem"
    CSR_FILE="$TMP_DIR/test_csr.pem"
    BATCH_FILE="$TMP_DIR/certutil_batch.txt"
    PASS_FILE="$TMP_DIR/db_pass.txt"
    echo "testpass" > "$PASS_FILE"  # Default password for database
    
    # Generate test key and certificate using openssl (for test materials)
    openssl genrsa -out "$TMP_DIR/test_key.pem" 2048
    openssl req -new -key "$TMP_DIR/test_key.pem" -out "$CSR_FILE" -subj "/CN=testcert"

    # 新增：将 PEM 格式 CSR 转换为 DER 格式（关键步骤）
    CSR_DER_FILE="$TMP_DIR/test_csr.der"  # 定义 DER 格式文件路径
    openssl req -in "$CSR_FILE" -out "$CSR_DER_FILE" -outform DER  # 转换格式
    openssl x509 -req -in "$CSR_FILE" -signkey "$TMP_DIR/test_key.pem" -out "$CERT_FILE" -days 1
    
    # Prepare batch file for -B command
    cat <<EOF > "$BATCH_FILE"
-A -n batch_cert -t "CT,C,C" -i $CERT_FILE -d $DB_DIR
-L -d $DB_DIR
EOF
    
    # Create new database (-N)
    certutil -N -d "$DB_DIR" -f "$PASS_FILE"

    #  Add certificate (-A)
    certutil -A -n test_cert -t "CT,C,C" -i "$CERT_FILE" -d "$DB_DIR" -f "$PASS_FILE"
    certutil -E -n email_cert -t "P,P,P" -i "$CERT_FILE" -d "$DB_DIR" -f "$PASS_FILE"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    #  List certificates (-L)
    certutil -L -d "$DB_DIR" | grep -q "test_cert"
    CHECK_RESULT $? 0 0 "Failed to list certificates (-L)"   
    
    #  List modules (-U)
    certutil -U -d "$DB_DIR"
    CHECK_RESULT $? 0 0 "Failed to list modules (-U)"
    
    # Modify trust attributes (-M)
    certutil -M -n test_cert -t "P,P,P" -d "$DB_DIR" -f "$PASS_FILE"
    CHECK_RESULT $? 0 0 "Failed to modify trust attributes (-M)"
    
    #  Print certificate chain (-O)
    certutil -O -n test_cert -d "$DB_DIR"
    CHECK_RESULT $? 0 0 "Failed to print certificate chain (-O)"
   
    #  Reset key database (-T)
    certutil -T -d "$DB_DIR" -f "$PASS_FILE"
    CHECK_RESULT $? 0 0 "Failed to reset key database (-T)"

    #  Delete key and certificate (-F)
    certutil -A -n del_cert -t "CT,C,C" -i "$CERT_FILE" -d "$DB_DIR" -f "$PASS_FILE"  # Re-add for deletion
    CHECK_RESULT $? 0 0 "Failed to delete key and certificate (-F)"
 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf "$TEST_DIR"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
