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
    dsconf localhost replication enable --suffix "dc=example,dc=com" --role supplier --replica-id 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost repl-winsync-agmt -h | grep "usage: dsconf.*instance.*repl-winsync-agmt"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt -h No Pass"
    dsconf localhost repl-winsync-agmt create -h | grep "usage: dsconf.*instance.*repl-winsync-agmt create"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt create -h No Pass"
    dsconf -D "cn=Directory Manager" localhost repl-winsync-agmt \
        create --suffix="dc=example,dc=com" --host="win-server.ad.example.com" --port=636 \
        --conn-protocol="LDAPS" --bind-dn="cn=user_name,cn=Users,dc=ad,dc=example,dc=com" \
        --bind-passwd="password" --win-subtree="cn=Users,dc=example,dc=com" \
        --ds-subtree="ou=People,dc=example,dc=com" --win-domain="AD" \
        --init example-agreement | grep "Successfully created"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt create No Pass"
    dsconf localhost repl-winsync-agmt enable -h | grep "usage: dsconf.*instance.*repl-winsync-agmt enable"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt enable -h No Pass"
    dsconf localhost repl-winsync-agmt enable --suffix "dc=example,dc=com" example-agreement | grep "Agreement has been enabled"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt enable No Pass"
    dsconf localhost repl-winsync-agmt init -h | grep "usage: dsconf.*instance.*repl-winsync-agmt init"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init -h No Pass"
    dsconf localhost repl-winsync-agmt init --suffix "dc=example,dc=com" example-agreement | grep "Agreement initialization started"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init No Pass"
    dsconf localhost repl-winsync-agmt init-status -h | grep "usage: dsconf.*instance.*repl-winsync-agmt init-status"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init-status -h No Pass"
    SLEEP_WAIT 20
    dsconf localhost repl-winsync-agmt init-status --suffix "dc=example,dc=com" example-agreement | grep "Agreement initialization failed"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt init-status No Pass"
    dsconf localhost repl-winsync-agmt list -h | grep "usage: dsconf.*instance.*repl-winsync-agmt list"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt list -h No Pass"
    dsconf localhost repl-winsync-agmt list --suffix "dc=example,dc=com" | grep "top"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt list No Pass"
    dsconf localhost repl-winsync-agmt poke -h | grep "usage: dsconf.*instance.*repl-winsync-agmt poke"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt poke -h No Pass"
    dsconf localhost repl-winsync-agmt poke --suffix "dc=example,dc=com" example-agreement | grep "Agreement has been poked"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt poke No Pass"
    dsconf localhost repl-winsync-agmt status -h | grep "usage: dsconf.*instance.*repl-winsync-agmt status"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt status -h No Pass"
    dsconf localhost repl-winsync-agmt status --suffix="dc=example,dc=com" example-agreement | grep "Status For Agreement"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt status No Pass"
    dsconf localhost repl-winsync-agmt set -h | grep "usage: dsconf.*instance.*repl-winsync-agmt set"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt set -h No Pass"
    dsconf localhost repl-winsync-agmt set --suffix="dc=example,dc=com" example-agreement 2>&1 | grep "There are no changes"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt set No Pass"
    dsconf localhost repl-winsync-agmt get -h | grep "usage: dsconf.*instance.*repl-winsync-agmt get"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt get -h No Pass"
    dsconf localhost repl-winsync-agmt get --suffix="dc=example,dc=com" example-agreement | grep "objectClass"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt get No Pass"
    dsconf localhost repl-winsync-agmt disable -h | grep "usage: dsconf.*instance.*repl-winsync-agmt disable"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt disable -h No Pass"
    dsconf localhost repl-winsync-agmt disable --suffix="dc=example,dc=com" example-agreement | grep "Agreement has been disabled"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt disable No Pass"
    dsconf localhost repl-winsync-agmt delete -h | grep "usage: dsconf.*instance.*repl-winsync-agmt delete"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt delete -h No Pass"
    dsconf localhost repl-winsync-agmt delete --suffix="dc=example,dc=com" example-agreement | grep "Agreement has been successfully deleted"
    CHECK_RESULT $? 0 0 "L$LINENO: repl-winsync-agmt delete No Pass"
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
