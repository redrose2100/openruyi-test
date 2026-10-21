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
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/17
# @License   :   Mulan PSL v2
# @Desc      :   Common helpers for ima-evm-utils test cases.
# #############################################

# Generate RSA private key and self-signed X509 certificate for IMA/EVM
# v2 signing and verification (v1 --rsa scheme is deprecated, returns 125).
# Produces privkey.pem (signing) and x509_evm.der (verification).
# Usage: evmctl_gen_key <keydir>
function evmctl_gen_key() {
    local keydir=$1
    cat > "${keydir}"/x509_evm.genkey <<EOF
[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = myexts

[ req_distinguished_name ]
O = TestOrg
CN = Test signing key
emailAddress = test@test.com

[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
extendedKeyUsage=critical,codeSigning
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid
EOF
    openssl req -new -nodes -utf8 -sha256 -days 36500 -batch \
        -x509 -config "${keydir}"/x509_evm.genkey \
        -outform DER -out "${keydir}"/x509_evm.der -keyout "${keydir}"/privkey.pem
    return $?
}
