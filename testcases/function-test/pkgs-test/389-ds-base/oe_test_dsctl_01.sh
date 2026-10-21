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
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf -D "cn=Directory Manager" localhost backend create --suffix="dc=example,dc=net" --be-name="example"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsctl -h | grep "usage: dsctl"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    dsctl -v localhost restart | grep "DEBUG: Instance allocated"
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    dsctl -l | grep "localhost"
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    dsctl -j localhost ldifs | grep "\"type\": \"list\""
    CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
    dsctl localhost stop | grep "Instance \"localhost\" has been stopped"
    CHECK_RESULT $? 0 0 "L$LINENO: stop No Pass"
    dsctl localhost start | grep "Instance \"localhost\" has been started"
    CHECK_RESULT $? 0 0 "L$LINENO: start No Pass"
    dsctl localhost restart | grep "Instance \"localhost\" has been restarted"
    CHECK_RESULT $? 0 0 "L$LINENO: restart No Pass"
    dsctl localhost status | grep "Instance \"localhost\" is running"
    CHECK_RESULT $? 0 0 "L$LINENO: status No Pass"
    dsctl localhost remove -h | grep "usage: dsctl.* \[instance\] remove \[-h\] \[--do-it\]"
    CHECK_RESULT $? 0 0 "L$LINENO: remove -h No Pass"
    dsctl localhost remove --do-it | grep "Completed instance removal"
    CHECK_RESULT $? 0 0 "L$LINENO: remove No Pass"
    LOG_INFO "End to run test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"