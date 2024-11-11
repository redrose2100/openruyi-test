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
    dsctl db2index -h | grep "usage: dsctl.* \[instance\] db2index \[-h\].* \[backend\]"
    CHECK_RESULT $? 0 0 "L$LINENO: db2index -h No Pass"
    dsctl localhost db2index example | grep "db2index successful"
    CHECK_RESULT $? 0 0 "L$LINENO: db2index No Pass"
    dsctl db2ldif -h | grep "usage: dsctl.* \[instance\] db2ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: db2ldif -h No Pass"
    dsctl localhost db2ldif example /var/lib/dirsrv/slapd-localhost/ldif/example.ldif | grep -E "db2ldif successful"
    CHECK_RESULT $? 0 0 "L$LINENO: db2ldif No Pass"
    dsctl localhost db2ldif --replication --encrypted example /var/lib/dirsrv/slapd-localhost/ldif/example_replication_encrypted.ldif | grep -E "db2ldif successful"
    CHECK_RESULT $? 0 0 "L$LINENO: db2ldif --replication --encrypted No Pass"
    dsctl ldif2db -h | grep "usage: dsctl.* \[instance\] ldif2db"
    CHECK_RESULT $? 0 0 "L$LINENO: ldif2db -h No Pass"
    dsctl localhost ldif2db example /var/lib/dirsrv/slapd-localhost/ldif/example.ldif | grep -E "ldif2db successful"
    CHECK_RESULT $? 0 0 "L$LINENO: ldif2db No Pass"
    dsctl localhost ldif2db --encrypted example /var/lib/dirsrv/slapd-localhost/ldif/example.ldif | grep -E "ldif2db successful"
    CHECK_RESULT $? 0 0 "L$LINENO: ldif2db --encrypted No Pass"
    dsctl ldifs -h | grep "usage: dsctl.* \[instance\] ldifs \[-h\] \[--delete DELETE\]"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifs -h No Pass"
    dsctl localhost ldifs | grep "example.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifs No Pass"
    dsctl localhost ldifs --delete example.ldif
    CHECK_RESULT $? 0 0 "L$LINENO: ldifs --delete No Pass"
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