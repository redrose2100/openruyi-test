#!/bin/bash
# shellcheck disable=SC2034,SC2129
source "$OET_PATH/libs/locallibs/common_lib.sh"

ssh_server_conf="/etc/ssh/sshd_config"
ssh_client_conf="/etc/ssh/ssh_config"
ssh_host_key="/etc/ssh/ssh_host_sm2_key"
ssh_known_hosts="/root/.ssh/known_hosts"
ssh_authorized_keys="/root/.ssh/authorized_keys"
sm2_private_key="/root/.ssh/id_sm2"
sm2_pub_key="/root/.ssh/id_sm2.pub"

function modify_ssh_server_conf() {
    P_SSH_CMD --cmd "cp -ar ${ssh_server_conf} ${ssh_server_conf}_bak"
    P_SSH_CMD --cmd "test -f ${ssh_host_key} || ssh-keygen -t sm2 -m PEM -f ${ssh_host_key} -P ''"
    P_SSH_CMD --cmd "echo \"HostKey ${ssh_host_key}\" >> ${ssh_server_conf}"
    P_SSH_CMD --cmd "sed -i '/^KexAlgorithms/s/$/,sm2-sm3/' ${ssh_server_conf}"
    P_SSH_CMD --cmd "sed -i '/^Ciphers/s/$/,sm4-ctr/' ${ssh_server_conf}"
    P_SSH_CMD --cmd "sed -i '/^MACs/s/$/,hmac-sm3/' ${ssh_server_conf}"
    P_SSH_CMD --cmd "sed -i '/^PubkeyAcceptedKeyTypes/s/$/,sm2/' ${ssh_server_conf}"
    P_SSH_CMD --cmd "sed -i '/^HostKeyAlgorithms/s/$/,sm2/' ${ssh_server_conf}"
}

function send_pub() {
    ssh-keygen -t sm2 -m PEM -P '' -f "${sm2_private_key}"
    SFTP put --localdir /root/.ssh/ --localfile id_sm2.pub --remotedir /root --node 2
    P_SSH_CMD --cmd "cat /root/id_sm2.pub >> ${ssh_authorized_keys}"
}

function modify_ssh_client_conf() {
    cp -ar "${ssh_client_conf}" "${ssh_client_conf}"_bak
    echo "PreferredAuthentications publickey" >> "${ssh_client_conf}"
    echo "HostKeyAlgorithms sm2" >> "${ssh_client_conf}"
    echo "PubkeyAcceptedKeyTypes sm2" >> "${ssh_client_conf}"
    echo "Ciphers sm4-ctr" >> "${ssh_client_conf}"
    echo "MACs hmac-sm3" >> "${ssh_client_conf}"
    echo "KexAlgorithms sm2-sm3" >> "${ssh_client_conf}"
    echo "FingerprintHash sm3" >> "${ssh_client_conf}"
    echo "IdentityFile ${sm2_private_key}" >> "${ssh_client_conf}"
}

function cleanup() {
    P_SSH_CMD --cmd "mv /etc/ssh/sshd_config_bak /etc/ssh/sshd_config"
    P_SSH_CMD --cmd "systemctl restart sshd"
    P_SSH_CMD --cmd "rm -rf ~/.ssh/authorized_keys /etc/ssh/ssh_host_sm2_key*"
    mv /etc/ssh/ssh_config_bak /etc/ssh/ssh_config
    systemctl restart sshd
    rm -rf /root/.ssh/id_sm2* /root/.ssh/known_hosts
}

