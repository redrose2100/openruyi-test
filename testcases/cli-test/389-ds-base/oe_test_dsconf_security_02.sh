#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   hu xintao
# @Contact   :   806908118@qq.com
# @Date      :   2023/09/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf security" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost security get -h | grep "usage: dsconf.*instance.*security get"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security get -h No Pass"
    dsconf localhost security get | grep "nsslapd-security:"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security get No Pass"
    dsconf localhost security disable -h | grep "usage: dsconf.*instance.*security disable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable -h No Pass"
    dsconf localhost security disable 
    dsconf localhost security get | grep "nsslapd-security: off"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable No Pass"
    dsconf localhost security enable -h | grep "usage: dsconf.*instance.*security enable"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable -h No Pass"
    dsconf localhost security enable 
    dsconf localhost security get | grep "nsslapd-security: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable No Pass"
    dsconf localhost sasl security enable --cert-name Server-Cert
    dsconf localhost security get | grep "nsslapd-security: on"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security enable --cert-name No Pass"
    dsconf localhost security disable_plain_port -h | grep "usage: dsconf.*instance.*security disable_plain_port"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable_plain_port -h No Pass"
    echo "^C" | dsconf localhost security disable_plain_port | grep "Disabling plaintext ldap port"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security disable_plain_port No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dsctl localhost remove --do-it
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"