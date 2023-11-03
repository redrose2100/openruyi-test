#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/03/09
# @License   :   Mulan PSL v2
# @Desc      :   Test amcheck
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "amanda"
    if [[ ! -d /etc/amanda ]]; then
        mkdir /etc/amanda
    fi
    mkdir -p /amanda /amanda/vtapes/slot{1,2,3,4} /amanda/holding /amanda/state/{curinfo,log,index}  /etc/amanda/MyConfig 
    cp ./common/amanda.conf /etc/amanda/MyConfig
    echo "localhost /etc simple-gnutar-local" > /etc/amanda/MyConfig/disklist
    mkdir /amanda/tmp && cp ./common/archive /amanda/tmp
    touch /amanda/tmp/tmparchive
    chown -R amandabackup.disk /amanda /etc/amanda /amanda/tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - amandabackup -c "amcheck MyConfig" | grep "Amanda Tape Server Host Check"
    CHECK_RESULT $? 0 0 "Check amcheck failed"
    su - amandabackup -c "amlabel MyConfig" | grep "Reading label"
    CHECK_RESULT $? 0 0 "Check amlabel failed"
    su - amandabackup -c "amdump --no-dump MyConfig"
    CHECK_RESULT $? 0 0 "Check amdump failed"
    su - amandabackup -c "amreport MyConfig" | grep "DUMP SUMMARY"
    CHECK_RESULT $? 0 0 "Check amreport failed"
    su - amandabackup -c "amadmin MyConfig find" | grep "No dump to list"
    CHECK_RESULT $? 0 0 "Check amadmin failed"
    su - amandabackup -c "amcheckdump MyConfig" | grep "No matching dumps found"
    CHECK_RESULT $? 0 0 "Check amcheckdump failed"
    su - amandabackup -c "amarchiver --create --file /amanda/tmp/archive /amanda/tmp/tmparchive" && su - amandabackup -c "amarchiver --list --file /amanda/tmp/archive"
    CHECK_RESULT $? 0 0 "Check amarchiver failed" 
    su - amandabackup -c "amcheckdb MyConfig" | grep "Ready."
    CHECK_RESULT $? 0 0 "Check amcheckdb failed"
    su - amandabackup -c "amstatus MyConfig" | grep "network free kps"
    CHECK_RESULT $? 0 0 "Check amstatus failed"
    su - amandabackup -c "amoverview MyConfig 2>&1" | grep "disk"
    CHECK_RESULT $? 0 0 "Check amoverview failed"
    su - amandabackup -c "amdevcheck MyConfig" | grep "SUCCESS"
    CHECK_RESULT $? 0 0 "Check amdevcheck failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /amanda /etc/amanda
    LOG_INFO "End to restore the test environment."
}

main "$@"
