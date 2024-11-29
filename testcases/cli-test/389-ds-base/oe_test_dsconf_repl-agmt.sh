#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/07
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export NSSLAPD_DB_LIB=bdb
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
    dsconf localhost replication enable --suffix "dc=example,dc=com" --role hub --replica-id 65535
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost repl-agmt -h | grep "usage: dsconf.*instance.*repl-agmt"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt -h No Pass"
    dsconf localhost repl-agmt create -h | grep "usage: dsconf.*instance.*repl-agmt create"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt create -h No Pass"
    dsconf localhost repl-agmt create test_name --suffix "dc=example,dc=com" --host localhost --port 636 \
        --conn-protocol LDAP --bind-dn="cn=Replication Manager,cn=config" --bind-passwd="password" --bind-method=SIMPLE |
        grep "Successfully created replication agreement"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt create No Pass"
    dsconf localhost repl-agmt init -h | grep "usage: dsconf.*instance.*repl-agmt init"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init -h No Pass"
    dsconf -v localhost repl-agmt init --suffix="dc=example,dc=com" test_name | grep "Agreement initialization started"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init No Pass"
    dsconf localhost repl-agmt init-status -h | grep "usage: dsconf.*instance.*repl-agmt init-status"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init-status -h No Pass"
    dsconf localhost repl-agmt init-status --suffix="dc=example,dc=com" test_name | grep "Unknown"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt init-status No Pass"
    dsconf localhost repl-agmt list -h | grep "usage: dsconf.*instance.*repl-agmt list"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt list -h No Pass"
    dsconf localhost repl-agmt list --suffix "dc=example,dc=com" | grep "cn: test_name"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt list No Pass"
    dsconf -v localhost repl-agmt enable -h | grep "usage: dsconf.*instance.*repl-agmt enable"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt enable -h No Pass"
    dsconf localhost repl-agmt enable --suffix="dc=example,dc=com" test_name | grep "Agreement has been enabled"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt enable No Pass"
    dsconf localhost repl-agmt poke -h | grep "usage: dsconf.*instance.*repl-agmt poke"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt poke -h No Pass"
    dsconf localhost repl-agmt status -h | grep "usage: dsconf.*instance.*repl-agmt status"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt status -h No Pass"
    dsconf localhost repl-agmt set -h | grep "usage: dsconf.*instance.*repl-agmt set"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt set -h No Pass"
    dsconf localhost repl-agmt set --suffix="dc=example,dc=com" test_name 2>&1 | grep "There are no changes to set in the agreement"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt set No Pass"
    dsconf localhost repl-agmt get -h | grep "usage: dsconf.*instance.*repl-agmt get"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt get -h No Pass"
    dsconf localhost repl-agmt get --suffix="dc=example,dc=com" test_name | grep "cn: test_name"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt get No Pass"
    dsconf localhost repl-agmt disable -h | grep "usage: dsconf.*instance.*repl-agmt disable"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt enable -h No Pass"
    dsconf -v localhost repl-agmt disable --suffix="dc=example,dc=com" test_name | grep "Agreement has been disabled"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt disable No Pass"
    dsconf localhost repl-agmt delete -h | grep "usage: dsconf.*instance.*repl-agmt delete"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt delete -h No Pass"
    dsconf -v localhost repl-agmt delete --suffix="dc=example,dc=com" test_name | grep "Agreement has been successfully deleted"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-agmt delete No Pass"
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
