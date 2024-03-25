#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023.3.9
# @License   :   Mulan PSL v2
# @Desc      :   Xmlsec1 Encrypt xml
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "xmlsec1 xmlsec1-openssl xmlsec1-openssl-devel libxml2 libxslt gcc"
    pwd=$(pwd)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ln -s /usr/include/libxml2/libxml/ /usr/include/
    CHECK_RESULT $? 0 0 "execution failed"
    ln -s /usr/include/xmlsec1/xmlsec/ /usr/include/
    CHECK_RESULT $? 0 0 "execution failed"
    unzip xmlsec1.zip
    cd xmlsec1 || exit
    gcc "$(xml2-config --cflags --libs)" "$(xslt-config --cflags --libs)" -lxmlsec1 -g -D__XMLSEC_FUNCTION__=__FUNCTION__ -DXMLSEC_NO_XKMS=1 -DXMLSEC_CRYPTO_OPENSSL -DXMLSEC_CRYPTO_DYNAMIC_LOADING=1 -DUNIX_SOCKETS -DXMLSEC_NO_SIZE_T sign.c -o sign1
    CHECK_RESULT $? 0 0 "execution failed"
    ./sign1 sign1-tmpl.xml rsakey.pem > sign1-res.xml
    CHECK_RESULT $? 0 0 "execution failed"
    cat sign1-res.xml
    CHECK_RESULT $? 0 0 "execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd "$pwd" || exit
    rm -rf xmlsec1 /usr/include/libxml /usr/include/xmlsec
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"