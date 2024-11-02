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
    dsconf localhost security certificate -h | grep "usage: dsconf.*instance.*security certificate"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate -h No Pass"
    dsconf localhost security certificate add -h | grep "usage: dsconf.*instance.*security certificate add"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate add -h No Pass"
    dsconf localhost security certificate set-trust-flags -h | grep "usage: dsconf.*instance.*security certificate set-trust-flags"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate set-trust-flags -h No Pass"
    dsconf localhost security certificate set-trust-flags --flags u,u,u Server-Cert
    dsconf localhost security certificate get Server-Cert | grep "Trust Flags: u,u,u"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate set-trust-flags --flags No Pass"
    dsconf localhost security certificate del -h | grep "usage: dsconf.*instance.*security certificate del"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate del -h No Pass"
    dsconf localhost security certificate get -h | grep "usage: dsconf.*instance.*security certificate get"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate get -h No Pass"
    dsconf localhost security certificate get Server-Cert | grep "Certificate Name: Server-Cert"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate get No Pass"
    dsconf localhost security certificate list -h | grep "usage: dsconf.*instance.*security certificate list"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate list -h No Pass"
    dsconf localhost security certificate list | grep "Certificate Name: Server-Cert"
    CHECK_RESULT $? 0 0 "L$LINENO: dsconf security certificate list No Pass"
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