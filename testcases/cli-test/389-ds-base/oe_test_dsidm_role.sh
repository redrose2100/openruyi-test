#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   shang jiwei
#@Contact   :   1065099936@qq.com
#@Date      :   2023/08/07
#@License   :   Mulan PSL v2
#@Desc      :   Test "dsidm" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    cat <<EOF >instance.inf
[general]
config_version = 2

[slapd]
root_password = 12345678

[backend-userroot]
sample_entries = yes
suffix = dc=example,dc=com

EOF
    dscreate from-file instance.inf
    dsctl localhost stop
    dsctl localhost db2ldif userroot /var/lib/dirsrv/slapd-localhost/ldif/dsidm_08_temp.ldif
    echo -e "dn: cn=example_roles,dc=example,dc=com
objectclass: top
objectclass: LdapSubEntry
objectclass: nsRoleDefinition
objectclass: nsSimpleRoleDefinition
objectclass: nsManagedRoleDefinition
cn: example_roles" >>/var/lib/dirsrv/slapd-localhost/ldif/dsidm_08_temp.ldif
    dsctl localhost ldif2db userroot /var/lib/dirsrv/slapd-localhost/ldif/dsidm_08_temp.ldif
    dsctl localhost start
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsidm localhost role -h | grep "usage: dsidm.*instance.*role"
    CHECK_RESULT $? 0 0 "L$LINENO: role -h No Pass"
    dsidm localhost role list -h | grep "usage: dsidm.*instance.*role list"
    CHECK_RESULT $? 0 0 "L$LINENO: role list -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role list | grep "example_roles"
    CHECK_RESULT $? 0 0 "L$LINENO: role list No Pass"
    dsidm localhost role get-by-dn -h | grep "usage: dsidm.*instance.*role get-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: role get-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role get-by-dn "cn=example_roles,dc=example,dc=com" |
        grep "objectClass: nsManagedRoleDefinition"
    CHECK_RESULT $? 0 0 "L$LINENO: role get-by-dn No Pass"
    dsidm localhost role modify-by-dn -h | grep "usage: dsidm.*instance.*role modify-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: role modify-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role modify-by-dn "cn=example_roles,dc=example,dc=com" \
        replace:cn:example_roles | grep "Successfully modified cn=example_roles,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: role modify-by-dn No Pass"
    dsidm localhost role rename-by-dn -h | grep "usage: dsidm.*instance.*role rename-by-dn"
    CHECK_RESULT $? 0 0 "L$LINENO: role rename-by-dn -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role rename-by-dn "cn=example_roles,dc=example,dc=com" \
        "cn=example_roles,dc=example,dc=com" | grep "Successfully renamed to cn=example_roles,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: role rename-by-dn No Pass"
    dsidm localhost role unlock -h | grep "usage: dsidm.*instance.*role unlock"
    CHECK_RESULT $? 0 0 "L$LINENO: role unlock -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role unlock "cn=example_roles,dc=example,dc=com" |
        grep "Entry cn=example_roles,dc=example,dc=com is unlocked"
    CHECK_RESULT $? 0 0 "L$LINENO: role unlock No Pass"
    dsidm localhost role lock -h | grep "usage: dsidm.*instance.*role lock"
    CHECK_RESULT $? 0 0 "L$LINENO: role lock -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role lock "cn=example_roles,dc=example,dc=com" |
        grep "Entry cn=example_roles,dc=example,dc=com is locked"
    CHECK_RESULT $? 0 0 "L$LINENO: role lock No Pass"
    dsidm localhost role entry-status -h | grep "usage: dsidm.*instance.*role entry-status"
    CHECK_RESULT $? 0 0 "L$LINENO: role entry-status -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role entry-status "cn=example_roles,dc=example,dc=com" |
        grep "Entry State: directly locked through nsDisabledRole"
    CHECK_RESULT $? 0 0 "L$LINENO: role entry-status No Pass"
    dsidm localhost role subtree-status -h | grep "usage: dsidm.*instance.*role subtree-status"
    CHECK_RESULT $? 0 0 "L$LINENO: role subtree-status -h No Pass"
    dsidm -b "dc=example,dc=com" localhost role subtree-status "dc=example,dc=com" | grep "Entry State: activated"
    CHECK_RESULT $? 0 0 "L$LINENO: role subtree-status No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
