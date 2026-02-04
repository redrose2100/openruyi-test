#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/07/05
# @License   :   Mulan PSL v2
# @Desc      :   Test curl upload file
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    conf=/etc/vsftpd/vsftpd.conf
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        DNF_INSTALL "ftp vsftpd curl"
        conf=/etc/vsftpd.conf
        useradd -s /sbin/nologin example
        chmod 755 /home/example
        cp /etc/shells /etc/shells_bak
        echo "/sbin/nologin" >> /etc/shells
        cp "${conf}" "${conf}".bak
        echo "anonymous_enable=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
local_enable=YES
write_enable=YES" >> "${conf}"
    else
        DNF_INSTALL "ftp vsftpd"
        cp "${conf}" "${conf}".bak
        sed -i 's/anonymous_enable=NO/#anonymous_enable=NO/g' "${conf}"
        sed -i 's/#anon_upload_enable=YES/anon_upload_enable=YES/g' "${conf}"
        sed -i 's/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g' "${conf}"
        echo "anon_world_readable_only=YES
    anon_other_write_enable=YES
    anon_root=/var/ftp/pub/
    local_root=/var/ftp/pub/" >>"${conf}"
        getenforce | grep Enforcing && setenforce 0
        systemctl status firewalld | grep running && systemctl stop firewalld
        systemctl status iptables | grep running && systemctl stop iptables
        iptables -F
        iptables -X
        iptables -t nat -F/etc/vsftpd/vsftpd.conf
        iptables -t nat -X
        chmod 777 /var/ftp/ -R
    fi
    systemctl restart vsftpd
    useradd example
    passwd example <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    touch example.txt
    SLEEP_WAIT 5
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        curl -u example:"${NODE1_PASSWORD}" -T example.txt ftp://"${NODE1_IPV4}"
        CHECK_RESULT $? 0 0 "Failed to execute curl"
        test -f /home/example/example.txt
        CHECK_RESULT $? 0 0 "Failed to execute curl"
    else
        curl --upload-file example.txt --user example:"${NODE1_PASSWORD}" ftp://"${NODE1_IPV4}"
        CHECK_RESULT $? 0 0 "Failed to execute curl"
        test -f /var/ftp/pub/example.txt
        CHECK_RESULT $? 0 0 "Failed to execute curl"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f "${conf}".bak "${conf}"
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        mv -f /etc/shells_bak /etc/shells
    else
        getenforce | grep Permissive && setenforce 1
        systemctl status firewalld | grep dead && systemctl start firewalld
        rm -rf /var/ftp/pub/example.txt
    fi
    rm -rf example.txt
    userdel -rf example
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
