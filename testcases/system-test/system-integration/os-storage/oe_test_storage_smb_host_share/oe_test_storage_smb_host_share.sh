#!/usr/bin/bash
#Copyright (c) 2021. Huawei Technologies Co.,Ltd.
##############################################
#@CaseName:   oe_test_storage_smb_host_share
#@Author:     Classicriver_jia
#@Contact:    classicriver_jia@foxmail.com
#@Date:       2020-4-10
#@License:    Mulan PSL v2
#@Desc:       SMB configuration host based shared access
##############################################

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
    # create user
    SSH_CMD "sed -i '/testsamba/d' /etc/security/opasswd;useradd testsamba;
	(echo ${user_password};echo ${user_password}) | smbpasswd -a testsamba -s" \
        ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # configure /etc/hosts
    SSH_CMD "cp -a /etc/hosts /etc/hosts.bak;echo  \\\" \\\" >> /etc/hosts;
	echo \\\"${NODE1_IPV4} client1.example.com\\\" >>/etc/hosts;
	echo \\\"${back_ip} client2.example.com\\\" >>/etc/hosts" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}

    # create share directory
    SSH_CMD "test -d /tmp/testsamba || mkdir -p /tmp/testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # modify smb.conf
    SSH_CMD "cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak;echo  \\\" \\\" >> /etc/samba/smb.conf;
	echo  \\\"\\[testsamba\\]\\\" >> /etc/samba/smb.conf;echo  \\\"\\tcomment = public stuff\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\tpath = /home/testsamba\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\thosts allow = 127.0.0.1 client1.example.com\\\" >> /etc/samba/smb.conf;
	echo  \\\"\\thosts deny = client2.example.com\\\" >> /etc/samba/smb.conf" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # configure firewall
    SSH_CMD "systemctl disable firewalld" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    # start samba server
    SSH_CMD "systemctl restart smb || systemctl start smb;systemctl enable smb;
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
    # delete user
    SSH_CMD "userdel -r testsamba" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    LOG_INFO "Finish environment cleanup."
}

main $@
