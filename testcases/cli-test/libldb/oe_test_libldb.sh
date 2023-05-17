#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wulei
#@Contact   	:   wulei@uniontech.com
#@Date      	:   2023-04-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Basic functional check of libldb package
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'openldap-servers openldap-clients'
    systemctl start slapd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > chrootpw.ldif << EOF
# specify the password generated above for "olcRootPW" section
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}E2L9nvHzas+TYf3PW4KQmn7VyveLehqP
EOF
    CHECK_RESULT $? 0 0 'File creation failed'
    ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif >log 2>&1
    grep 'authentication started' log
    CHECK_RESULT $? 0 0 'The file content does not exist'
    ldapsearch -x -b "dc=zhizhangyi,dc=com" -H ldap://127.0.0.1 | grep '<dc=zhizhangyi,dc=com>'
    CHECK_RESULT $? 0 0 'Inconsistent return information'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf chrootpw.ldif log
    systemctl stop slapd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
