#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/08/14
# @License   :   Mulan PSL v2
# @Desc      :   devmaster devctl trigger 测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sysmaster devmaster" 2

    SSH_CMD "dracut --omit 'systemd systemd-initrd systemd-networkd dracut-systemd' /boot/initrd_withoutsd.img" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "grubby --make-default --config-file=/boot/grub2/grub.cfg --add-kernel=/boot/vmlinuz-$(uname -r) --copy-default --title='openEuler sysmaster' --args='init=/usr/lib/sysmaster/init' --initrd='/boot/initrd_withoutsd.img'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl reboot -f" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SLEEP_WAIT 120

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "sctl stop udevd.service udevd-control.socket udevd-kernel.socket" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "udevd stop failed"

    SSH_SCP 00-persist-storage.rules "${NODE2_USER}"@"${NODE2_IPV4}":/etc/devmaster/rules.d/00-persist-storage.rules "${NODE2_PASSWORD}"
    CHECK_RESULT $? 0 0 "SSH_SCP 00-persist-storage.rules failed"

    SSH_CMD "sctl restart devmaster" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "/lib/devmaster/devmaster failed"

    SLEEP_WAIT 5
    SSH_CMD "test -d /dev/test" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "test -d /dev/test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    SSH_CMD "sudo rm /etc/devmaster/rules.d/00-persist-storage.rules" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    SSH_CMD "sudo grub2-mkconfig -o \$(find /boot/ -name grub.cfg)" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "sudo rm /boot/initrd_withoutsd.img" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    REMOTE_REBOOT 2 60

    DNF_REMOVE 2 "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
