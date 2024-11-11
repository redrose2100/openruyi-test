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
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsctl" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=net" --be-name="example"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsctl healthcheck -h | grep "usage: dsctl.* \[instance\] healthcheck"
    CHECK_RESULT $? 0 0 "L$LINENO: healthcheck -h No Pass"
    dsctl localhost healthcheck --list-checks | grep "backends:example:search"
    CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --list-checks No Pass"
    dsctl localhost healthcheck --list-errors | grep "Possibly incorrect mapping tree."
    CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --list-errors No Pass"
    dsctl localhost healthcheck --dry-run | grep "backends:example:search"
    CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --dry-run No Pass"
    dsctl localhost healthcheck --check backends:example:search | grep "Healthcheck complete."
    CHECK_RESULT $? 0 0 "L$LINENO: healthcheck --check No Pass"
    dsctl get-nsstate -h | grep "usage: dsctl.* \[instance\] get-nsstate \[-h\]"
    CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate -h No Pass"
    dsctl localhost get-nsstate --suffix "dc=example,dc=net"
    CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate --suffix No Pass"
    dsctl localhost get-nsstate --flip big
    CHECK_RESULT $? 0 0 "L$LINENO: get-nsstate --flip Np Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"