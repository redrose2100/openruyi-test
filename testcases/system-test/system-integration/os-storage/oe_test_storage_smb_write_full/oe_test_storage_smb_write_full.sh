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
# @Desc      :   SMB mount
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    user_password=${NODE1_PASSWORD}
    remote_disk=$(lsblk | grep disk | sed -n 2p | awk '{print$1}')
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    # install samba package
    SSH_CMD "yum install -y samba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # create user
    SSH_CMD "sed -i '/testsamba/d' /etc/security/opasswd;useradd testsamba;
    (echo ${user_password};echo ${user_password}) | smbpasswd -a testsamba -s" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # modify smb.conf
    SSH_CMD "cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak;echo  \\\" \\\" >> /etc/samba/smb.conf;
	echo  \\\"\\[testsamba\\]\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\tcomment = public stuff\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\tpath = /home/testsamba\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\tpath = /home/testsamba\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\twriteable = yes\\\" >> /etc/samba/smb.conf" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # start samba server
    SSH_CMD "systemctl start smb;systemctl enable smb;systemctl disable firewalld;systemctl stop firewalld
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
    # check user
    SSH_CMD "grep 'testsamba' /etc/passwd" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $?
    # check samba server
    SSH_CMD "ps -ef | grep -v 'grep' | grep -i 'smb'" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $?
    # check mount directory
    test -d /home/client
    CHECK_RESULT $?
    SSH_CMD "mkfs.ext4 /dev/${remote_disk}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "mount /dev/${remote_disk} /home/testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "chmod 777 /home/testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # mount test
    mount -t cifs -o username=testsamba,password=${user_password} //${NODE2_IPV4}/testsamba /home/client
    CHECK_RESULT $?
    # check mount
    df -h | grep -i '/home/client' | grep "${NODE2_IPV4}"
    CHECK_RESULT $?

    SSH_CMD "dd if=/dev/zero of=/home/testsamba/test bs=1k" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    dd if=/dev/zero of=/home/client/test1 bs=1M count=2
    CHECK_RESULT $? 1

    SSH_CMD "rm -rf /home/testsamba/test" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    dd if=/dev/zero of=/home/client/test1 bs=1M count=2
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # umount directory
    rm -rf /home/client/test1
    umount /home/client
    rmdir /home/client
    SSH_CMD "umount /home/testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # stop smb progress
    SSH_CMD "systemctl stop smb" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # recover config
    SSH_CMD "rm -f /etc/samba/smb.conf;mv /etc/samba/smb.conf.bak /etc/samba/smb.conf" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # remove package
    SSH_CMD "yum remove samba -y" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE
    # delete user
    SSH_CMD "userdel -r testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "Finish environment cleanup."
}

main $@
