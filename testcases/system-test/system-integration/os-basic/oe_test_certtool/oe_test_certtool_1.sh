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
# @Date      :   2025-8-4
# @License   :   Mulan PSL v2
# @Desc      :   Command certtool01
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    TEST_DIR="/tmp/certtool_test"
    CA_KEY="$TEST_DIR/ca.key"
    CA_CERT="$TEST_DIR/ca.crt"
    USER_KEY="$TEST_DIR/user.key"
    USER_CSR="$TEST_DIR/user.csr"
    USER_CERT="$TEST_DIR/user.crt"
    TMPFILE1=$(mktemp)
    TMPFILE2=$(mktemp)
    TMPFILE3=$(mktemp)
    TMPFILE4=$(mktemp)
    rm -rf $TEST_DIR
    mkdir -p $TEST_DIR

    certtool --generate-privkey --outfile $CA_KEY
    cat <<EOF > "$TMPFILE1"
cn = Test CA
ca
cert_signing_key
EOF
    certtool --generate-self-signed --load-privkey "$CA_KEY" --template "$TMPFILE1" > "$CA_CERT"

    certtool --generate-privkey --outfile $USER_KEY
    cat <<EOF > "$TMPFILE2"
cn = Test User
EOF
    certtool --generate-request --load-privkey $USER_KEY --template "$TMPFILE2" > "$USER_CSR"

cat <<EOF > "$TMPFILE3"
serial = 0x01
expiration_days = 100
tls_www_client
signing_key
encryption_key
EOF
    certtool --generate-certificate --load-request $USER_CSR --load-ca-certificate $CA_CERT  --load-ca-privkey $CA_KEY --outfile $USER_CERT  --template "$TMPFILE3"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    certtool --certificate-info --infile $USER_CERT
    CHECK_RESULT $? 0 0 "Certificate info test failed"  
    certtool --pubkey-info --infile $USER_CERT
    CHECK_RESULT $? 0 0 "Public key info test failed"
    certtool --fingerprint --infile $USER_CERT
    CHECK_RESULT $? 0 0 "Fingerprint test failed"
    certtool --key-id --infile $USER_CERT
    CHECK_RESULT $? 0 0 "Key ID test failed"
    cat <<EOF > "$TMPFILE4"
cn = "Self-Signed Certificate"
serial = 0x01
expiration_days = 100
tls_www_server
signing_key
encryption_key
EOF
    certtool --generate-self-signed --load-privkey $USER_KEY --outfile $TEST_DIR/selfsigned.crt --template "$TMPFILE4"
    CHECK_RESULT $? 0 0 "Self-signed cert generation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG=$cur_lang
    rm -rf $TEST_DIR "$TMPFILE1" "$TMPFILE2" "$TMPFILE3" "$TMPFILE4"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
