#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test samba.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    host_name=$(hostname)
    hostname OE-TESTD
    echo "${NODE1_IPV4} TESTAD.LOCAL" >>/etc/hosts
    DNF_INSTALL "samba-tools samba-dc python3-samba-dc krb5-server"
    mv /etc/samba/smb.conf /etc/samba/smb.conf_bak
    expect <<EOF
        set timeout 600
        spawn samba-tool domain provision --use-rfc2307 --interactive --function-level=2008_R2
        expect {
            "Realm*" { send "TESTAD.LOCAL\\r"; exp_continue }
            "Domain*" { send "\\r"; exp_continue }
            "Server Role*" { send "\\r"; exp_continue }
            "DNS backend*" { send "\\r"; exp_continue }
            "DNS forwarder*" { send "\\r"; exp_continue }
            "Administrator*" { send "openEuler12#$\\r"; exp_continue }
            "Retype*" { send "openEuler12#$\\r" }
        }
        expect eof
EOF
    mv /etc/krb5.conf /etc/krb5.bak
    rm -rf /etc/krb5.conf && cp -raf /var/lib/samba/private/krb5.conf /etc/
    systemctl stop firewalld
    sed -i 's/nameserver/#nameserver/' /etc/resolv.conf 
    echo "nameserver 127.0.0.1" >> /etc/resolv.conf
    flag=false
    if getenforce | grep Enforcing; then
        setenforce 0
        flag=true
    fi
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart samba.service
    CHECK_RESULT $? 0 0 "samba.service restart failed"
    SLEEP_WAIT 5
    systemctl status samba.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "samba.service restart failed"
    systemctl stop samba.service
    CHECK_RESULT $? 0 0 "samba.service stop failed"
    SLEEP_WAIT 5
    systemctl status samba.service | grep "code=exited, status=127"
    CHECK_RESULT $? 0 0 "samba.service stop failed"
    systemctl start samba.service
    CHECK_RESULT $? 0 0 "samba.service start failed"
    SLEEP_WAIT 5
    systemctl status samba.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "samba.service start failed"
    test_enabled samba.service
    journalctl --since "${log_time}" -u samba.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|Failed with result"
    CHECK_RESULT $? 0 1 "There is an error message for the log of samba.service"
    sed -i "s\/usr/sbin/samba --foreground --no-process-group $SAMBAOPTIONS\/usr/sbin/samba --foreground --no-process-group $SAMBAOPTIONS -d 10\g" /usr/lib/systemd/system/samba.service
    systemctl daemon-reload
    systemctl reload samba.service
    CHECK_RESULT $? 0 0 "samba.service reload failed"
    systemctl status samba.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "samba.service reload causes the service status to change"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i "s\/usr/sbin/samba --foreground --no-process-group $SAMBAOPTIONS -d\/usr/sbin/samba --foreground --no-process-group $SAMBAOPTIONS\g" /usr/lib/systemd/system/samba.service
    systemctl daemon-reload
    systemctl reload samba.service
    systemctl stop samba.service
    DNF_REMOVE "$@"
    sed -i '/nameserver 127.0.0.1/d' /etc/resolv.conf
    sed -i 's/#nameserver/nameserver/' /etc/resolv.conf 
    hostname "${host_name}"
    sed -i "/TESTAD/d" /etc/hosts
    systemctl start firewalld
    if [ "${flag}" = "true" ]; then
        setenforce 1
    fi
    rm -rf  /etc/samba/smb.conf /var/lib/samba/private/* /var/lib/samba/sysvol/*  
    mv -f /etc/krb5.bak /etc/krb5.conf
    mv -f /etc/samba/smb.conf_bak /etc/samba/smb.conf
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
