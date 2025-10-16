#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-09-11
#@License       :   Mulan PSL v2
#@Desc          :   oeAware embedded test
#####################################
# shellcheck disable=SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="60m"
    DNF_INSTALL "oeAware-manager" 2
    P_SSH_CMD --node 2 --cmd "dnf install -y kernel-rt"
    P_SSH_CMD --node 2 --cmd "systemctl restart oeaware;
systemctl enable oeaware;
echo > /var/log/oeAware/server.log"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "oeawarectl -e realtime_tune" | grep "Instance enabled failed, because Current kernel is not PREEMPT_RT! yum install kernel-rt first"
    CHECK_RESULT $? 0 0 "Check kernel-rt failed."
    P_SSH_CMD --node 2 --cmd "cat /var/log/oeAware/server.log" | grep "realtime_tune instance enabled failed, Current kernel is not PREEMPT_RT! yum install kernel-rt first"
    CHECK_RESULT $? 0 0 "Check kernel-rt failed."
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /etc/default/grub;sed -i '/^GRUB_CMDLINE_LINUX=/s/\"$/ isolcpus=1-10\"/' /etc/default/grub;"
    P_SSH_CMD --node 2 --cmd "
cat /etc/default/grub;
grub2-mkconfig -o /boot/efi/EFI/openEuler/grub.cfg;
cat /boot/efi/EFI/openEuler/grub.cfg"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "isolcpus=1-10"
    CHECK_RESULT $? 0 0 "Check cmdline modify failed."
    P_SSH_CMD --node 2 --cmd "oeawarectl -e realtime_tune"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "isolcpus=3-4"
    CHECK_RESULT $? 0 0 "Check cmdline modify failed."
    SLEEP_WAIT 10
    P_SSH_CMD --node 2 --cmd "oeawarectl -d realtime_tune;
    systemctl disable oeaware;
    sed -i 's/isolcpus=1-10//' /boot/efi/EFI/openEuler/grub.cfg;
    sed -i 's/ isolcpus=1-10//' /etc/default/grub"
    REMOTE_REBOOT 2 300
    P_SSH_CMD --node 2 --cmd "cat /proc/cmdline" | grep -z "isolcpus=3-4"
    CHECK_RESULT $? 1 0 "Check cmdline modify failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "rpm -e kernel-rt"
    DNF_REMOVE 2 "$@"
    REMOTE_REBOOT 2 300
    LOG_INFO "End to restore the test environment."
}

main "$@"
