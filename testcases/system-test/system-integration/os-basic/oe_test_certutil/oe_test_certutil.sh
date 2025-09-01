#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025-9-1
# @License   :   Mulan PSL v2
# @Desc      :   Command certutil test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    TEST_DIR="/tmp/certutil_test"
    DB_DIR="$TEST_DIR/nss_db"
    SRC_DB_DIR="$TEST_DIR/src_nss_db"
    TMP_DIR="$TEST_DIR/tmp"
    mkdir -p "$DB_DIR" "$SRC_DB_DIR" "$TMP_DIR"
    CERT_FILE="$TMP_DIR/test_cert.pem"
    CSR_FILE="$TMP_DIR/test_csr.pem"
    BATCH_FILE="$TMP_DIR/certutil_batch.txt"
    PASS_FILE="$TMP_DIR/db_pass.txt"
    echo "testpass" > "$PASS_FILE"
    openssl genrsa -out "$TMP_DIR/test_key.pem" 2048
    openssl req -new -key "$TMP_DIR/test_key.pem" -out "$CSR_FILE" -subj "/CN=testcert"
    CSR_DER_FILE="$TMP_DIR/test_csr.der"
    openssl req -in "$CSR_FILE" -out "$CSR_DER_FILE" -outform DER
    openssl x509 -req -in "$CSR_FILE" -signkey "$TMP_DIR/test_key.pem" -out "$CERT_FILE" -days 1
    cat <<EOF > "$BATCH_FILE"
-A -n batch_cert -t "CT,C,C" -i $CERT_FILE -d $DB_DIR
-L -d $DB_DIR
EOF
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    certutil -N -d "$DB_DIR" -f "$PASS_FILE"
    CHECK_RESULT $? 0 0 "Failed to create new database (-N)"
expect <<EOF
spawn certutil -G -d "$DB_DIR" -f "$PASS_FILE" 
expect "progress meter is full:"
send "aaaaaaaaaaaaaaaaaaaaaaa"
expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed to generate key pair (-G)"
    certutil -A -n test_cert -t "CT,C,C" -i "$CERT_FILE" -d "$DB_DIR" -f "$PASS_FILE"
    CHECK_RESULT $? 0 0 "Failed to add certificate (-A)"
    certutil -E -n email_cert -t "P,P,P" -i "$CERT_FILE" -d "$DB_DIR" -f "$PASS_FILE"
    CHECK_RESULT $? 0 0 "Failed to add email certificate (-E)"     
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
