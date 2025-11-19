#!/usr/bin/bash

# Copyright (c) 2024  INSPUR Co., Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   koulq
# @Contact   :   koulq@inspur.com
# @Date      :   2024.4.15
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-httplib2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "gnutls-utils"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep gnutls
    CHECK_RESULT $? 0 0 "Return value error"
    gnutls-cli --insecure www.baidu.com
    CHECK_RESULT $? 0 0 "connection fail" 
    gnutls-cli --version
    CHECK_RESULT $? 0 0 "Failed to get gnutls-cli version"
    gnutls-cli --print-cert --insecure www.baidu.com </dev/null | grep -i "Certificate"
    CHECK_RESULT $? 0 0 "Failed to retrieve certificate information"
    gnutls-cli --priority NORMAL --insecure www.baidu.com </dev/null | grep -i "Handshake was completed"
    CHECK_RESULT $? 0 0 "Handshake failed"
    gnutls-cli --list </dev/null | grep -i "Ciphers"
    CHECK_RESULT $? 0 0 "Failed to list cipher suites"
    gnutls-cli --priority-list </dev/null | grep -i "NORMAL"
    CHECK_RESULT $? 0 0 "Failed to show priority list"
    gnutls-cli --benchmark-ciphers </dev/null | grep -i "Cipher"
    CHECK_RESULT $? 0 0 "Cipher benchmark failed"
    export cert_file=$(mktemp)
    gnutls-cli --save-cert="${cert_file}" --insecure www.baidu.com </dev/null
    CHECK_RESULT $? 0 0 "Failed to save certificate"
    test -s "${cert_file}"
    CHECK_RESULT $? 0 0 "Saved certificate file is empty"
    rm -f "${cert_file}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"

