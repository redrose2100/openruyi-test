#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-07-21
#@License       :   Mulan PSL v2
#@Desc          :   Information collection
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "net-tools dhcp"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Get OS info
    grep "openeulerversion" /etc/openEuler-latest
    CHECK_RESULT $? 0 0 "Failed to get the OS version info-1"
    grep "PRETTY_NAME" /etc/os-release
    CHECK_RESULT $? 0 0 "Failed to get the OS version info-2"
    grep "openEuler release" /etc/openEuler-release
    CHECK_RESULT $? 0 0 "Failed to get the OS version info-3"
    if [ "$NODE1_FRAME" == "ppc64le" ];then 
        echo "need match by kernel"
    else
        uname -a | grep "Linux openEuler"
    fi
    CHECK_RESULT $? 0 0 "Failed to get the kernel version info"
    # Get hardware info
    lscpu | grep "On-line CPU(s) list"
    CHECK_RESULT $? 0 0 "Failed to execute lscpu"
    grep "processor" /proc/cpuinfo
    CHECK_RESULT $? 0 0 "Failed to get CPU parameters"
    grep "MemTotal:" /proc/meminfo
    CHECK_RESULT $? 0 0 "Failed to get meminfo parameters"
    if [ "$NODE1_FRAME" == "ppc64le" ];then 
        lshw -c memory |grep bank
    else
        dmidecode -t memory | grep "Memory Device"
    fi
    CHECK_RESULT $? 0 0 "Failed to get memory hard disk info"
    lsblk | grep "NAME" | grep "MOUNTPOINTS"
    CHECK_RESULT $? 0 0 "Failed to execute lsblk"
    fdisk -l | grep "Device" | grep "Sectors"
    CHECK_RESULT $? 0 0 "Failed to execute fdisk -l"
    lspci | grep -i 'eth'
    CHECK_RESULT $? 0 0 "Failed to execute lspci"
    ip a | grep "inet"
    CHECK_RESULT $? 0 0 "Failed to execute ip a"
    ifconfig -a | grep "inet"
    CHECK_RESULT $? 0 0 "Failed to execute ifconfig -a"
    network_interface_name=$(ifconfig -a | head -n 1 | awk -F ":" '{print $1}')
    CHECK_RESULT $? 0 0 "Failed to get network interface name"
    ethtool "$network_interface_name" | grep "Settings for $network_interface_name"
    CHECK_RESULT $? 0 0 "Failed to execute ethtool"
    lspci | grep "bridge"
    CHECK_RESULT $? 0 0 "Failed to execute lspci"
    lspci -t
    CHECK_RESULT $? 0 0 "Failed to execute lspci -t"
    if [ "$NODE1_FRAME" == "ppc64le" ];then
        echo "ppc64le not support dmidecode"
    else 
        dmidecode -t bios | grep "BIOS Information"
    fi
    CHECK_RESULT $? 0 0 "Failed to get bios info"
    # Get software info
    rpm -qi systemd | grep "Summary"
    CHECK_RESULT $? 0 0 "Failed to get the pkg info"
    rpm -q --provides systemd | grep "systemctl"
    CHECK_RESULT $? 0 0 "Failed to get the modules provided by systemd package"
    rpm -qa | grep "systemd"
    CHECK_RESULT $? 0 0 "Failed to execute rpm -qa"
    rpm -ql rpm | grep "/usr/bin/rpm"
    CHECK_RESULT $? 0 0 "Failed to execute rpm -ql"
    # Get OS log
    grep "dhclient" /var/log/messages
    CHECK_RESULT $? 0 0 "Failed to get info and error logs after system startup"
    grep "sshd" /var/log/secure
    CHECK_RESULT $? 0 0 "Failed to get security-related logs"
    test -f /var/log/maillog
    CHECK_RESULT $? 0 0 "Failed to get log info about emails"
    grep "(CRON) STARTUP" /var/log/cron
    CHECK_RESULT $? 0 0 "Failed to get log info about scheduled tasks"
    test -f /var/log/spooler
    CHECK_RESULT $? 0 0 "Failed to get UUCP and news log info about the device"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
