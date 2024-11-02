#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.


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
    dsconf localhost plugin posix-winsync -h | grep "dsconf.* instance plugin posix-winsync"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync -h No Pass"
    dsconf localhost plugin  posix-winsync show -h | grep "usage: dsconf.* instance plugin posix-winsync show"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync show -h No Pass"
    dsconf localhost plugin posix-winsync show | grep "Posix Winsync API"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync show No Pass"
    dsconf localhost plugin posix-winsync enable -h | grep "usage: dsconf.* instance plugin posix-winsync enable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync enable -h No Pass"
    dsconf localhost plugin posix-winsync enable | grep "Enabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync enable No Pass"
    dsconf localhost plugin posix-winsync disable -h | grep "usage: dsconf.* instance plugin posix-winsync disable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync disable -h No Pass"
    dsconf localhost plugin posix-winsync disable | grep "Disabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync disable No Pass"
    dsconf localhost plugin posix-winsync status -h | grep "usage: dsconf.* instance plugin posix-winsync status"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync status -h No Pass"
    dsconf localhost plugin posix-winsync status | grep "is disabled"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync status No Pass"
    dsconf localhost plugin posix-winsync set -h | grep "usage: dsconf.* instance plugin posix-winsync set"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync set -h No Pass"
    dsconf localhost plugin posix-winsync set --create-memberof-task TRUE | grep "Successfully changed"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync set No Pass"
    dsconf localhost plugin posix-winsync fixup -h | grep "usage: dsconf.* instance plugin posix-winsync fixup"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync fixup -h No Pass"
    dsconf localhost plugin posix-winsync fixup "dc=example,dc=com" | grep "Attempting to add task entry"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin posix-winsync fixup No Pass"
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