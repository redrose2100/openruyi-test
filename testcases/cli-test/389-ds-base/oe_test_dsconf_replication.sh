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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost replication -h | grep "usage: dsconf.*instance.*replication"
    CHECK_RESULT $? 0 0 "L$LINENO: replication -h No Pass"
    dsconf localhost replication enable -h | grep "dsconf.*instance.*replication enable"
    CHECK_RESULT $? 0 0 "L$LINENO: replication enable -h No Pass"
    dsconf localhost replication enable --suffix "dc=example,dc=com" --role hub --replica-id 65535 | grep "Replication successfully enabled"
    CHECK_RESULT $? 0 0 "L$LINENO: replication enable No Pass"
    dsconf localhost replication promote --suffix "dc=example,dc=com" --newrole supplier --replica-id 2 | grep "Successfully promoted replica to"
    CHECK_RESULT $? 0 0 "L$LINENO: replication promote No Pass"
    dsconf localhost replication get-ruv -h | grep "usage: dsconf.*instance.*replication get-ruv"
    CHECK_RESULT $? 0 0 "L$LINENO: replication get-ruv -h No Pass"
    dsconf localhost replication get-ruv --suffix "dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: replication get-ruv No Pass"
    dsconf localhost replication list -h | grep "usage: dsconf.*instance.*replication list"
    CHECK_RESULT $? 0 0 "L$LINENO: replication list -h No Pass"
    dsconf localhost replication list | grep "dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: replication list No Pass"
    dsconf localhost replication status -h | grep "usage: dsconf.*instance.*replication status"
    CHECK_RESULT $? 0 0 "L$LINENO: replication status -h No Pass"
    dsconf localhost replication status --suffix "dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: replication status No Pass"
    dsconf localhost replication winsync-status -h | grep "usage: dsconf.*instance.*replication winsync-status"
    CHECK_RESULT $? 0 0 "L$LINENO: replication winsync-status -h No Pass"
    dsconf localhost replication winsync-status --suffix "dc=example,dc=com"
    CHECK_RESULT $? 0 0 "L$LINENO: replication winsync-status No Pass"
    dsconf localhost replication promote -h | grep "usage: dsconf.*instance.*replication promote"
    CHECK_RESULT $? 0 0 "L$LINENO: replication promote -h No Pass"
    dsconf localhost replication create-manager -h | grep "usage: dsconf.*instance.*replication create-manager"
    CHECK_RESULT $? 0 0 "L$LINENO: replication create-manager -h No Pass"
    dsconf localhost replication create-manager --name test_mng --passwd 123456 | grep "Successfully created replication manager"
    CHECK_RESULT $? 0 0 "L$LINENO: replication create-manager No Pass"
    dsconf localhost replication delete-manager -h | grep "usage: dsconf.*instance.*replication delete-manager"
    CHECK_RESULT $? 0 0 "L$LINENO: replication delete-manager -h No Pass"
    dsconf localhost replication delete-manager --name test_mng | grep "Successfully deleted replication manager"
    CHECK_RESULT $? 0 0 "L$LINENO: replication delete-manager No Pass"
    dsconf localhost replication demote -h | grep "usage: dsconf.*instance.*replication demote"
    CHECK_RESULT $? 0 0 "L$LINENO: replication demote -h No Pass"
    dsconf localhost replication demote --suffix "dc=example,dc=com" --newrole hub | grep "Successfully demoted replica to"
    CHECK_RESULT $? 0 0 "L$LINENO: replication demote No Pass"
    dsconf localhost replication get -h | grep "usage: dsconf.*instance.*replication get"
    CHECK_RESULT $? 0 0 "L$LINENO: replication get -h No Pass"
    dsconf localhost replication get --suffix "dc=example,dc=com" | grep "cn: replica"
    CHECK_RESULT $? 0 0 "L$LINENO: replication get No Pass"
    dsconf localhost replication get-changelog -h | grep "usage: dsconf.*instance.*replication get-changelog"
    CHECK_RESULT $? 0 0 "L$LINENO: replication get-changelog -h No Pass"
    if [ "$(rpm -qa 389-ds-base | awk -F- '{print $4}' | awk -F. '{print $1}')" -ge 3 ]; then
        dsconf localhost replication get-changelog --suffix dc=example,dc=com | grep "cn: changelog"
    else
        dsconf localhost replication get-changelog | grep "cn: changelog"
    fi
    CHECK_RESULT $? 0 0 "L$LINENO: replication get-changelog No Pass"
    dsconf localhost replication set-changelog -h | grep "usage: dsconf.*instance.*replication set-changelog"
    CHECK_RESULT $? 0 0 "L$LINENO: replication set-changelog -h No Pass"
    dsconf localhost replication set -h | grep "dsconf.*instance.*replication set"
    CHECK_RESULT $? 0 0 "L$LINENO: replication set -h No Pass"
    dsconf localhost replication set --suffix "dc=example,dc=com" 2>&1 | grep "There are no changes to set in the replica"
    CHECK_RESULT $? 0 0 "L$LINENO: replication set No Pass"
    dsconf localhost replication monitor -h | grep "dsconf.*instance.*replication monitor"
    CHECK_RESULT $? 0 0 "L$LINENO: replication monitor -h No Pass"
    dsconf localhost replication monitor -c
    CHECK_RESULT $? 0 0 "L$LINENO: replication monitor -c No Pass"
    dsconf localhost replication disable -h | grep "dsconf.*instance.*replication disable"
    CHECK_RESULT $? 0 0 "L$LINENO: replication disable -h No Pass"
    dsconf localhost replication disable --suffix "dc=example,dc=com" | grep "Replication disabled for"
    CHECK_RESULT $? 0 0 "L$LINENO: replication disable No Pass"
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
