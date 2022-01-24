#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-10
# @License   :   Mulan PSL v2
# @Desc      :   Enables users to share directories on Samba servers
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    user_password=${NODE1_PASSWORD}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    # install samba package
    SSH_CMD "yum install -y samba;yum install -y policycoreutils-python-utils" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # add group
    SSH_CMD "grep 'example' /etc/group || groupadd example" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # create user
    SSH_CMD "sed -i '/testsamba/d' /etc/security/opasswd;useradd testsamba;
    (echo ${user_password};echo ${user_password}) | smbpasswd -a testsamba -s" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # create directory
    SSH_CMD "test -d /tmp/testsamba || mkdir -p /tmp/testsamba;
    test -d /var/lib/samba/usershares/ || mkdir -p /var/lib/samba/usershares/;
    chgrp example /var/lib/samba/usershares/;chmod 1770 /var/lib/samba/usershares/" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # modify smb.conf
    SSH_CMD "cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak;echo  \\\" \\\" >> /etc/samba/smb.conf;
    echo  \\\"\\[example\\]\\\" >> /etc/samba/smb.conf;echo  \\\"\\tpath = /tmp/testsamba\\\" >> /etc/samba/smb.conf;
    echo  \\\"\\tread only = no\\\" >> /etc/samba/smb.conf;
    sed -i \\\"/\\[global\\]/a \\tusershare path = /var/lib/samba/usershares/\\\" /etc/samba/smb.conf;
    sed -i \\\"/\\[global\\]/a \\tusershare max shares = 100\\\" /etc/samba/smb.conf;
    sed -i \\\"/\\[global\\]/a \\tusershare prefix allow list = /data /srv\\\" /etc/samba/smb.conf" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # configure firewall
    SSH_CMD "systemctl disable firewalld" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # start samba server
    SSH_CMD "smbcontrol all reload-config;systemctl restart smb || systemctl start smb;systemctl enable smb;
    setsebool samba_export_all_ro on;setsebool samba_export_all_rw on" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}

    # install package in the client
    DNF_INSTALL cifs-utils
    systemctl stop firewalld
    # create mount directory
    mkdir -p /home/client
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # mount test
    mount -t cifs -o username=testsamba,password=${user_password} //${NODE2_IPV4}/testsamba /home/client
    CHECK_RESULT $?
    # check mount
    df -h | grep -i '/home/client' | grep "${NODE2_IPV4}"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # umount directory
    umount /home/client
    rmdir /home/client
    # stop smb progress
    SSH_CMD "systemctl stop smb" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # recover config
    SSH_CMD "rm -f /etc/samba/smb.conf;mv /etc/samba/smb.conf.bak /etc/samba/smb.conf" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # remove package
    SSH_CMD "yum remove samba -y;yum remove -y policycoreutils-python-utils" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE
    # delete user and group
    SSH_CMD "userdel -r testsamba;groupdel example" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # delete directory
    SSH_CMD "rm -rf /tmp/testsamba;rm -rf /var/lib/samba/usershares/" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "Finish environment cleanup."
}

main $@
