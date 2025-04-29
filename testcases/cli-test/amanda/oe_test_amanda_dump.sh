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
    if [ ! -e /dev/nst0 ]; then
        LOG_WARN "System has no /dev/nst0 device. The environment does not support testing."
        exit 255
    fi
    DNF_INSTALL "amanda openssl"
    mkdir /etc/amanda
    mkdir -p /amanda /amanda/vtapes/slot{1,2,3,4} /amanda/holding /amanda/state/{curinfo,log,index} /etc/amanda/MyConfig
    cp ./common/amanda.conf /etc/amanda/MyConfig
    echo "localhost /etc simple-gnutar-local" > /etc/amanda/MyConfig/disklist
    cp ./common/backup-pubkey.pem /var/lib/amanda/backup-pubkey.pem
    su - amandabackup -c "echo 'MyConfig' > /var/lib/amanda/.am_passphrase"
    chown -R amandabackup.disk /amanda /etc/amanda
    su - amandabackup -c "amdump MyConfig"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - amandabackup -c "amdump_client --config DailySet1 list"
    CHECK_RESULT $? 0 0 "Check amdump_client failed"
    amrecover MyConfig
    CHECK_RESULT $? 0 0 "Check amrecover failed"
    amservice localhost bsdtcp noop < /dev/null
    CHECK_RESULT $? 0 0 "Check amservice failed"
    su - amandabackup -c "amrestore /dev/nst0 hostname.zmanda.com /var"
    CHECK_RESULT $? 0 0 "Check amrestore failed"
    su - amandabackup -c "amfetchdump MyConfig simple-gnutar-local"
    CHECK_RESULT $? 0 0 "Check amfetchdump failed"
    su - amandabackup -c "amflush MyConfig"
    CHECK_RESULT $? 0 0 "Check amflush failed"
    amoldrecover MyConfig
    CHECK_RESULT $? 0 0 "Check amoldrecover failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /amanda /etc/amanda tmp.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
