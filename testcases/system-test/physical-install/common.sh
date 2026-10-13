#! /usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/07/06
# @License   :   Mulan PSL v2
# @Desc      :   common_functions
# ############################################
# shellcheck disable=SC1090,SC1091,SC2154,SC2034
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ./install_env.conf
function build_env() {
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    TIMEOUT="90m"
    if [ -z "$NODE3_BMC_IP" ]; then
        LOG_WARN "Please configure according to the physical使用说明.txt file in the directory first."
        exit 1
    fi
    if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "("; then
        os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | tr '()' '- ' | sed s/[[:space:]]//g)
    else
        if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "LTS"; then
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | awk -F ' ' '{print$1"-"$2}')
        else
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}')
        fi
    fi
    if [ "${NODE3_MACHINE}" == "kvm" ]; then
        LOG_WARN "This machine is not a physical machine."
    else
        DNF_INSTALL "httpd ipmitool OpenIPMI net-tools"
        systemctl start httpd
        systemctl stop firewalld
        iptables -F
        cp anaconda-ks-base.cfg /var/www/html
        cp grub-bak.cfg grub.cfg
        NODE3_Passphrase="$(openssl passwd -6 -salt JUMfeVCzqomzX8CD ${NODE3_PASSWORD})"
        sed -i "s|NODE3_Passphrase|$NODE3_Passphrase|g" /var/www/html/anaconda-ks-base.cfg
        sed -i "s/NODE3_NIC/$NODE3_NIC/g" /var/www/html/anaconda-ks-base.cfg
        sed -i "s/NODE1_IPV4/$NODE1_IPV4/g" grub.cfg
        sed -i "s/os_version/$os_version/g" grub.cfg
        P_SSH_CMD --cmd "mkdir -p /var/lib/tftpboot/openEuler_${os_version}_phy/latest;
        mkdir -p /var/lib/tftpboot/openEuler/GUI_${os_version}_phy;
        rm -rf /var/lib/tftpboot/openEuler_${os_version}_phy/latest/images;
        rm -rf /var/lib/tftpboot/openEuler/GUI_${os_version}_phy/grub*;
        " --node 2
        if [ "${test_mode}" == "round" ]; then
            P_SSH_CMD --cmd "cp -r /var/www/html/$test_install_path/openEuler-${os_version}/$test_time/OS/${NODE3_FRAME}/images /var/lib/tftpboot/openEuler_${os_version}_phy/latest;
            cp /var/www/html/$test_install_path/openEuler-${os_version}/$test_time/OS/${NODE3_FRAME}/EFI/BOOT/*efi /var/lib/tftpboot/openEuler/GUI_${os_version}_phy;
            chmod 777 -R /var/lib/tftpboot/openEuler/GUI_${os_version}_phy;
            chmod 777 -R /var/lib/tftpboot/openEuler_${os_version}_phy/latest;
            " --node 2
            http_url="http://${server_ip}${http_server_port}/${test_install_path}/openEuler-${os_version}/$test_time/OS/${NODE3_FRAME}"
            ftp_url="ftp://${server_ip}/${test_install_path}/openEuler-${os_version}/$test_time/OS/${NODE3_FRAME}"
            nfs_url="nfs://${server_ip}:/var/www/html/${test_install_path}/openEuler-${os_version}/$test_time/OS/${NODE3_FRAME}"
        else
            P_SSH_CMD --cmd "cp -r /var/www/html/${test_install_path}/openEuler-${os_version}/OS/${NODE3_FRAME}/images /var/lib/tftpboot/openEuler_${os_version}_phy/latest;
            cp /var/www/html/${test_install_path}/openEuler-${os_version}/OS/${NODE3_FRAME}/EFI/BOOT/*efi /var/lib/tftpboot/openEuler/GUI_${os_version}_phy;
            chmod 777 -R /var/lib/tftpboot/openEuler/GUI_${os_version}_phy;
            chmod 777 -R /var/lib/tftpboot/openEuler_${os_version}_phy/latest;
            " --node 2
            http_url="http://${server_ip}${http_server_port}/${test_install_path}/openEuler-${os_version}/OS/${NODE3_FRAME}"
            ftp_url="ftp://${server_ip}/${test_install_path}/openEuler-${os_version}/OS/${NODE3_FRAME}"
            nfs_url="nfs://${server_ip}:/var/www/html/${test_install_path}/openEuler-${os_version}/OS/${NODE3_FRAME}"
        fi
        SFTP put --localdir ./ --localfile grub.cfg --remotedir /var/lib/tftpboot/openEuler/GUI_${os_version}_phy --node 2
        ip route add 9.3.0.0/16 via 172.168.0.254 dev ${NODE1_NIC}
        modprobe ipmi_watchdog
        modprobe ipmi_poweroff
        modprobe ipmi_devintf
        modprobe ipmi_msghandler
        modprobe ipmi_si
        systemctl restart ipmievd.service
    fi
}

function clean_env() {
    if [ "${hold_syslog}" == "YES" ]; then
        rm -rf /var/www/html/* grub.cfg
    else
        rm -rf /var/www/html/* grub.cfg ./*_${NODE3_FRAME}
    fi
    export LANG=${OLD_LANG}
    ip route add 9.3.0.0/16 via 172.168.0.254 dev ${NODE1_NIC}
    modprobe -r ipmi_watchdog
    modprobe -r ipmi_poweroff
    modprobe -r ipmi_devintf
    modprobe -r ipmi_ssif
    modprobe -r ipmi_si
    modprobe -r ipmi_msghandler
    DNF_REMOVE "$@"
}
