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
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
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
    dsconf localhost plugin retro-changelog -h | grep "dsconf.* instance plugin retro-changelog"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog -h No Pass"
    dsconf localhost plugin retro-changelog show -h | grep "usage: dsconf.* instance plugin retro-changelog show"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog show -h No Pass"
    dsconf localhost plugin retro-changelog show | grep "Retro Changelog Plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog show No Pass"
    dsconf localhost plugin retro-changelog enable -h | grep "usage: dsconf.* instance plugin retro-changelog enable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog enable -h No Pass"
    dsconf localhost plugin retro-changelog enable | grep "Enabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog enable No Pass"
    dsconf localhost plugin retro-changelog disable -h | grep "usage: dsconf.* instance plugin retro-changelog disable"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog disable -h No Pass"
    dsconf localhost plugin retro-changelog disable | grep "Disabled plugin"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog disable No Pass"
    dsconf localhost plugin retro-changelog status -h | grep "usage: dsconf.* instance plugin retro-changelog status"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog status -h No Pass"
    dsconf localhost plugin retro-changelog status | grep "is disabled"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog status No Pass"
    dsconf localhost plugin retro-changelog set -h | grep "usage: dsconf.* instance plugin retro-changelog set"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog set -h No Pass"
    dsconf localhost plugin retro-changelog set --is-replicated TRUE | grep "Successfully changed"
    CHECK_RESULT $? 0 0 "L$LINENO: plugin retro-changelog set No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf instance.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"