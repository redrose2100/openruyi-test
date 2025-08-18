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
# @Desc      :   sysmaster sctl 命令测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sysmaster" 2

    SSH_CMD "dracut --omit 'systemd systemd-initrd systemd-networkd dracut-systemd' /boot/initrd_withoutsd.img" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "grubby --make-default --add-kernel=/boot/vmlinuz-$(uname -r) --copy-default --title='openEuler sysmaster' --args='init=/usr/lib/sysmaster/init' --initrd='/boot/initrd_withoutsd.img'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "systemctl reboot -f" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SLEEP_WAIT 120

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    SSH_CMD "grep init /proc/1/comm" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "sysmaster init boot failed"

    SSH_CMD "sctl start sshd.service" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "sctl start sshd.service failed"

    # SSH_CMD "sctl stop sshd.service" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    # CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"

    SSH_CMD "sctl restart sshd.service" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"

    SLEEP_WAIT 5
    SSH_CMD "sctl status sshd.service" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "sctl status sshd.service failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."

    if [ "$NODE1_FRAME" == "x86_64" ];then
      grub_cfg="/boot/grub2/grub.cfg"
    else
      grub_cfg="/boot/efi/EFI/openEuler/grub.cfg"
    fi
    # 删除 grub.cfg 中第一个 menuentry
    SSH_CMD "awk '
  /^menuentry / && !done {del=1; next}
  del && /}/ {del=0; done=1; next}
  !del {print}
' ${grub_cfg} > grub.new && sudo mv grub.new ${grub_cfg}" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    SSH_CMD "sudo rm /boot/initrd_withoutsd.img" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    REMOTE_REBOOT 2 60

    DNF_REMOVE 2 "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
