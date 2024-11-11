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
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=net" --be-name="example"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    dsctl ldifgen -h | grep "dsctl.* \[instance\] ldifgen \[-h\]"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen -h No Pass"
    dsctl localhost ldifgen users -h | grep "usage: dsctl.* \[instance\] ldifgen users"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen users -h No Pass"
    dsctl localhost ldifgen users --suffix "dc=example,dc=com" --number 1000 --generic \
    --start-idx 0 --rdn-cn --parent "ou=people,dc=example,dc=com" --localize \
    --ldif-file ./users.ldif | grep "Successfully created LDIF file: ./users.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen users No Pass"
    dsctl localhost ldifgen groups -h | grep  "usage: dsctl.* \[instance\] ldifgen groups"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen groups -h No Pass"
    dsctl localhost ldifgen groups --number 5 --suffix "dc=example,dc=com" \
    --parent "ou=groups,dc=example,dc=com" --num-members 100 --create-members \
    --member-parent "ou=People,dc=example,dc=com" --ldif-file ./groups.ldif \
    example_group | grep "Successfully created LDIF file: ./groups.ldif" 
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen groups No Pass"
    dsctl localhost ldifgen cos-def -h | grep "usage: dsctl.* \[instance\] ldifgen cos-def"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-def -h No Pass"
    dsctl localhost ldifgen cos-def --type classic \
    --parent "ou=cos definitions,dc=example,dc=com" --cos-specifier businessCatagory \
    --cos-template "cn=sales,cn=classicCoS,dc=example,dc=com" \
    --cos-attr postalcode telephonenumber --ldif-file ./cos-definition.ldif cos_def \
    | grep "Successfully created LDIF file: ./cos-definition.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-def No Pass"
    dsctl localhost ldifgen cos-template -h | grep "usage: dsctl.* \[instance\] ldifgen cos-template"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-template -h No Pass"
    dsctl localhost ldifgen cos-template --parent "dc=test,dc=example,dc=com" \
    --cos-priority 0 --cos-attr-val  "ATTRIBUTE:VALUE"\
    --ldif-file ./cos-template.ldif cos_template | grep "Successfully created LDIF file: ./cos-template.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen cos-template No Pass"
    dsctl localhost ldifgen roles -h | grep "usage: dsctl.* \[instance\] ldifgen roles"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen roles -h No Pass"
    dsctl localhost ldifgen roles --type managed --parent "dc=example,dc=com" \
    --ldif-file ./roles.ldif example_roles | grep "Successfully created LDIF file: ./roles.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen roles No Pass"
    dsctl localhost ldifgen mod-load -h | grep "usage: dsctl.* \[instance\] ldifgen mod-load "
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen mod-load -h No Pass"
    dsctl localhost ldifgen mod-load --parent dc=example,dc=com \
     --num-users 1000 --create-users --mod-users 1000 --add-users 10 \
     --del-users 100 --mod-users 1000 --modrdn-users 100 \
     --mod-attrs cn uid sn --delete-users --ldif-file=./mod-load.ldif \
     | grep "Successfully created LDIF file: ./mod-load.ldif"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen mod-load No Pass"
    dsctl localhost ldifgen nested -h | grep "usage: dsctl.* \[instance\] ldifgen nested"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen nested -h No Pass"
    dsctl localhost ldifgen nested --num-users 600 --node-limit 100 --suffix "dc=example,dc=com" \
    --ldif-file ./neste.ldif | grep "Successfully created nested LDIF file"
    CHECK_RESULT $? 0 0 "L$LINENO: ldifgen nested No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf users.ldif groups.ldif cos-definition.ldif cos-template.ldif roles.ldif mod-load.ldif neste.ldif /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"