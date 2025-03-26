#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/10/28
# @License   :   Mulan PSL v2
# @Desc      :   开启samba服务并登录
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

user="test"
pass="Huawei12#$"
smb_conf="/etc/samba/smb.conf"

function pre_test() {
    DNF_INSTALL "samba samba-client firewalld samba-common-tools"
    systemctl stop firewalld
    iptables -F
    ip6tables -F
    setenforce 0
    getenforce
    cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
}

function run_test() {
    userdel -rf "${user}"
    useradd -m "${user}"
    chmod 755 -R "/home/${user}"
    echo -e "${pass}\n${pass}\n" | passwd "${user}"
    echo -e "${pass}\n${pass}\n" | pdbedit -a "${user}"
    echo "
[global]
    security = user
    #map to guest = Bad User
    passdb backend = tdbsam
    load printers = no
    lanman auth = yes
    ntlm auth = yes
    guest ok = yes
    writable = yes
    browseable = yes
    read only = No

[${user}]
    path=/home/${user}
    " > "${smb_conf}"
    systemctl restart smb
    sleep 3
    systemctl status smb
    CHECK_RESULT $? 0 0

    echo ls | smbclient "//${NODE1_IPV4}/${user}" -U "${user}%${pass}" | grep bashrc
    CHECK_RESULT $? 0 0
}

function post_test() {
    systemctl stop smb
    systemctl restart firewalld
    DNF_REMOVE "$@"
    mv /etc/samba/smb.conf.bak /etc/samba/smb.conf
    sleep 3
    setenforce 1
    getenforce
    userdel -rf "${user}"
}

main "$@"
