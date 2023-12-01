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
    DNF_INSTALL "amanda openssl"
    if [[ ! -d /etc/amanda ]]; then
        mkdir /etc/amanda
    fi
    mkdir -p /amanda /amanda/vtapes/slot{1,2,3,4} /amanda/holding /amanda/state/{curinfo,log,index} /etc/amanda/MyConfig
    cp ./common/amanda.conf /etc/amanda/MyConfig
    echo "localhost /etc simple-gnutar-local" > /etc/amanda/MyConfig/disklist
    cp ./common/backup-pubkey.pem /var/lib/amanda/backup-pubkey.pem
    su - amandabackup -c "echo "MyConfig" > /var/lib/amanda/.am_passphrase"
    chown -R amandabackup.disk /amanda /etc/amanda
    su - amandabackup -c "amdump MyConfig"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - amandabackup -c "ambackup --config MyConfig check" | grep "check succeeded"
    CHECK_RESULT $? 0 0 "Check ambackup failed"
    su - amandabackup -c "amcleanup MyConfig" | grep "clean up"
    CHECK_RESULT $? 0 0 "Check amcleanup failed"
    su - amandabackup -c "amcleanupdisk MyConfig"
    CHECK_RESULT $? 0 0 "Check amcleanupdisk failed"
    su - amandabackup -c "amgetconf MyConfig logdir" | grep "/amanda/state/log"
    CHECK_RESULT $? 0 0 "Check amgetconf failed"
    su - amandabackup -c "amgpgcrypt" 2>&1 | grep "gpg-agent"
    CHECK_RESULT $? 0 0 "Check amgpgcrypt failed"
    su - amandabackup -c "amtape MyConfig show"
    export logdir=$(amgetconf MyConfig logdir) && export log=$(ls -1t $logdir/log.*.[0-9] | head -1)
    su - amandabackup -c "amtoc -a $log"
    CHECK_RESULT $? 0 0 "Check amtoc failed"
    su - amandabackup -c "amtape MyConfig show" 2>&1 | grep "scanning all 4 slots" 
    CHECK_RESULT $? 0 0 "Check amtape failed"
    nohup amcrypt-ossl > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep "would be better" tmp.txt
    CHECK_RESULT $? 0 0 "Check amcrypt-ossl failed"
    nohup amcrypt-ossl-asym > tmp.txt 2>&1 &
    SLEEP_WAIT 2
    grep "would be better" tmp.txt
    CHECK_RESULT $? 0 0 "Check amcrypt-ossl-asym failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /amanda /etc/amanda tmp.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
