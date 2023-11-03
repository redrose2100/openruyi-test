#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test nslcd.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL nss
    mkdir /tmp/test
    Directory=/tmp/test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cd $Directory
    echo 1 > pwdfile.txt
    echo dsadasdasdasdadasdasdasdasdsadfwerwerjfdksdjfksdlfhjsdk > noise.txt
    certutil -N -d . -f pwdfile.txt
    certutil -L -d . | grep "Trust Attributes"
    CHECK_RESULT $? 0 0 "Failed to create the certificate database."
    certutil -S -n 'weidong_test_ca' -s 'cn=CAcert' -x -t 'CT,,' -m 10001 -v 120 -d . -z noise.txt -f pwdfile.txt
    certutil -L -d . | grep "weidong_test_ca"
    CHECK_RESULT $? 0 0 "Failed to create a root certificate"
    certutil -S -n 'weidong_test_server_cert' -s 'cn=uos' -c 'weidong_test_ca' -t 'u,u,u' -m 1002 -v 120 -d . -z noise.txt -f pwdfile.txt
    CHECK_RESULT $? 0 0 "Failed to create an issuing certificate"
    certutil -L -d . -f pwdfile.txt -n "weidong_test_server_cert" | grep "Certificate Trust Flags"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf $Directory
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
