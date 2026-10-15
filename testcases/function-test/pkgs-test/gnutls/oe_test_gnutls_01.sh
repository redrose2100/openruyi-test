#!/usr/bin/bash

# Copyrigiht (c) 2025  INSPUR Co., Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   koulq@inspur.com
# @Date      :   2025.10.11
# @License   :   Mulan PSL v2
# @Desc      :   Test gnutls
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gnutls-utils"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    gnutls-cli --list | grep -q "TLS_"
    CHECK_RESULT $? 0 0 "Cipher suite list function fail"
    certtool --generate-privkey --outfile /tmp/test-key.pem
    CHECK_RESULT $? 0 0 "Generate private key fail"
    test -f /tmp/test-key.pem
    CHECK_RESULT $? 0 0 "Private key file not created"
    certtool --help | grep -q "Generate"
    CHECK_RESULT $? 0 0 "Help information check fail"
    certtool --generate-dh-params --outfile /tmp/dhparams.pem --bits 512
    CHECK_RESULT $? 0 0 "Generate DH parameters fail"
    test -f /tmp/dhparams.pem
    CHECK_RESULT $? 0 0 "DH parameters file not created"
    gnutls-cli --version | grep -q "gnutls"
    CHECK_RESULT $? 0 0 "Version check fail" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f /tmp/test-key.pem /tmp/dhparams.pem
    # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

