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
# @Desc      :   Common Samba command line utilities-smbclient
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
    SSH_CMD "yum install -y samba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # create user
    SSH_CMD "sed -i '/testsamba/d' /etc/security/opasswd;useradd testsamba;
    (echo ${user_password};echo ${user_password}) | smbpasswd -a testsamba -s" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # modify smb.conf
    SSH_CMD "cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak;echo  \\\" \\\" >> /etc/samba/smb.conf;
    echo  \\\"\\[testsamba\\]\\\" >> /etc/samba/smb.conf;echo  \\\"\\tcomment = public stuff\\\" >> /etc/samba/smb.conf;
    echo  \\\"\\tpath = /home/testsamba\\\" >> /etc/samba/smb.conf" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # start samba server
    SSH_CMD "systemctl start smb;systemctl enable smb;systemctl disable firewalld;
	setsebool samba_export_all_ro on;setsebool samba_export_all_rw on;chmod 755 /home/testsamba" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # install package in the client
    DNF_INSTALL cifs-utils
    systemctl stop firewalld
    # create mount directory
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # test interaction
    expect -c "
        set timeout 30
        spawn smbclient -U testsamba //${NODE2_IPV4}/testsamba
		expect \"*assword*\" {send \"${NODE2_PASSWORD}\\r\";
		expect \"smb*>\" {send \"ls\\r\";
		expect \"smb*>\" {send \"exit\\r\"}}}
        expect eof
	"
    CHECK_RESULT $?
    # list all share directories in ip
    smbclient -L ${NODE2_IPV4} -U testsamba%${NODE2_PASSWORD}
    CHECK_RESULT $?
    # check mount directory
    smbclient -c "ls" //${NODE2_IPV4}/testsamba -U testsamba%${NODE2_PASSWORD}
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
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
