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
        mkdir -p /etc/amanda
    fi
    mkdir -p /amanda /amanda/vtapes/slot{1,2,3,4} /amanda/holding /amanda/state/{curinfo,log,index} /etc/amanda/MyConfig
    cp ./common/amanda.conf /etc/amanda/MyConfig
    echo "localhost /etc simple-gnutar-local" > /etc/amanda/MyConfig/disklist
    echo "windowsdesktop.company.com  ${NODE2_IPV4}" > /var/lib/amanda/.amandahosts
    chown -R amandabackup.disk /amanda /etc/amanda /amanda/tmp /var/lib/amanda/.amandahosts
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    su - amandabackup -c "amssl --init"
    CHECK_RESULT $? 0 0 "Check amssl failed"
    su - amandabackup -c "amaddclient --config MyConfig --client windowsdesktop.company.com  --diskdev /amanda/" | grep "Creating amanda-client.conf"
    CHECK_RESULT $? 0 0 "Check amaddclient failed"
    rm -f /etc/amanda/MyConfig/disklist && echo "localhost /etc simple-gnutar-local" > /etc/amanda/MyConfig/disklist
    chown -R amandabackup.disk /etc/amanda/MyConfig/disklist
    su - amandabackup -c "echo 'MyConfig' > /var/lib/amanda/.am_passphrase"
    su - amandabackup -c "amcryptsimple &"
    ps -ef | grep -v grep | grep "amcryptsimple"
    CHECK_RESULT $? 0 0 "Check amcryptsimple failed"
    su - amandabackup -c "amreindex MyConfig" | grep "All images successfully"
    CHECK_RESULT $? 0 0 "Check amreindex failed"
    su - amandabackup -c "amserverconfig tmpConfig" && test -d /etc/amanda/tmpConfig/
    CHECK_RESULT $? 0 0 "Check amserverconfig failed" 
    su - amandabackup -c "amcheck MyConfig"
    su - amandabackup -c "amlabel MyConfig"
    SLEEP_WAIT 3
    su - amandabackup -c "amrmtape MyConfig MyData01" | grep "Removed label"
    CHECK_RESULT $? 0 0 "Check amrmtape failed"
    rm -f /etc/amanda/DailySet1/tapelist && cp /etc/amanda/DailySet1/tapelistbak /etc/amanda/DailySet1/tapelist
    sed '12arest-api-port 2254' /etc/amanda/amanda.conf
    su - amandabackup -c "amanda-rest-server --development stop"
    CHECK_RESULT $? 0 0 "Check amanda-rest-server failed"
    rm -f /etc/amanda/amanda.conf
    amandad --version | grep "amandad-"
    CHECK_RESULT $? 0 0 "Check amandad failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /amanda /etc/amanda
    LOG_INFO "End to restore the test environment."
}

main "$@"
