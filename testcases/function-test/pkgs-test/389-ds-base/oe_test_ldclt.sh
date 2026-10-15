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
# @Desc      :   Test "ldclt" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template instance.inf
    dscreate from-file instance.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=com" --be-name="example"
    dsidm -b "dc=example,dc=com" localhost initialise
    cat <<EOF > inet.txt
objectclass: inetOrgPerson
sn: [B=RNDFROMFILE(/usr/share/dirsrv/data/dbgen-FamilyNames)]
cn: [C=RNDFROMFILE(/usr/share/dirsrv/data/dbgen-GivenNames)] [B]
password: test[A]
description: user id [A]
mail: [C].[B]@example.com
telephonenumber: (555) [RNDN(0;999;3)]-[RNDN(0;9999;4)]
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ldclt -b "ou=people,dc=csb" -e object=inet.txt,rdn='uid:[A=INCRNNOLOOP(0;100;5)]' \
    -e genldif=100Kinet.ldif,commoncounter | grep "No problem during execution"
    CHECK_RESULT $? 0 0 "L$LINENO: Generating LDIFs No Pass"
    ldclt -b "ou=people,dc=example,dc=com" -D "cn=Directory Manager" -w Directory_Manager_Password \
    -e add,person,incr,noloop,commoncounter -r0 -R999 -f "cn=MrXXXXX" -v -q | grep "No problem during execution."
    CHECK_RESULT $? 0 0 "L$LINENO: Adding Entries No Pass"
    ldclt -h localhost -p 389 -D "cn=Directory Manager" -w Directory_Manager_Password -b "ou=people,dc=example,dc=com" \
    -e rename,rdn='cn:Mr[RNDN(0;2000;5)]',object="inet.txt" | grep "Max errors reached."
    CHECK_RESULT $? 0 0 "L$LINENO: Modrdn Operations No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf inet.txt 100Kinet.ldif /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"