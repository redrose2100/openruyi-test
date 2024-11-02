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
    dsctl localhost stop
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsctl dbverify -h | grep "usage: dsctl.* \[instance\] dbverify \[-h\] backend"
    CHECK_RESULT $? 0 0 "L$LINENO: dbverify -h No Pass"
    dsctl localhost dbverify example | grep "dbverify successful"
    CHECK_RESULT $? 0 0 "L$LINENO: dbverify No Pass"
    dsctl db2bak -h | grep "usage: dsctl.* \[instance\] db2bak \[-h\] \[archive\]"
    CHECK_RESULT $? 0 0 "L$LINENO: db2bak -h No Pass"
    dsctl localhost db2bak /var/lib/dirsrv/slapd-localhost/bak/localhost-test | grep "db2bak successful"
    CHECK_RESULT $? 0 0 "L$LINENO: db2bak No Pass"
    dsctl bak2db -h | grep "usage: dsctl.* \[instance\] bak2db \[-h\] archive"
    CHECK_RESULT $? 0 0 "L$LINENO: bak2db -h No Pass"
    dsctl localhost bak2db /var/lib/dirsrv/slapd-localhost/bak/localhost-test | grep "bak2db successful"
    CHECK_RESULT $? 0 0 "L$LINENO: bak2db No Pass"
    dsctl backups -h | grep "usage: dsctl.* \[instance\] backups \[-h\] \[--delete DELETE\]"
    CHECK_RESULT $? 0 0 "L$LINENO: backups -h No Pass"
    dsctl localhost backups | grep "Backup: /var/lib/dirsrv/slapd-localhost/bak/localhost-test"
    CHECK_RESULT $? 0 0 "L$LINENO: backups No Pass"
    dsctl localhost backups --delete localhost-test
    CHECK_RESULT $? 0 0 "L$LINENO: backups --delete No Pass"
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