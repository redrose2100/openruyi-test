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
    dscreate create-template instance.inf
    dscreate from-file instance.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=com" --be-name="example"
    dsidm -b "dc=example,dc=com" localhost initialise
    dsconf localhost replication enable --suffix "dc=example,dc=com" --role hub --replica-id 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost plugin list -h | grep "dsconf.* instance plugin list"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin list -h No Pass"
    dsconf localhost plugin list | grep "SSHA"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin list No Pass"
    dsconf localhost plugin set -h | grep "dsconf.* instance plugin set"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin set -h No Pass"
    dsconf localhost plugin set --type 2 --enabled on --id 123456 --description 12345 SSHA384 | grep "Successfully changed the"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin set No Pass"
    dsconf localhost plugin show -h | grep "dsconf.* instance plugin show"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin show -h No Pass"
    dsconf localhost plugin show SSHA384 | grep "SSHA"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin show No Pass"
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