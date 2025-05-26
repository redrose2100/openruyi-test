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
#@Date          :   2023-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Common function: Prepare environment, Create and start a stratovirt VM
#####################################
# shellcheck disable=SC1090,SC1091,SC2154

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_env(){
    DNF_INSTALL "stratovirt nmap"
    openeulerversion=$(grep "^PRETTY_NAME=" /etc/os-release | cut -d= -f2- | tr -d '"' | sed -E 's/ ([0-9]+\.[0-9]+) \(([^)]+)\)/-\1-\2/' | tr ' ' '-')
    wget https://repo.openeuler.org/"$openeulerversion"/stratovirt_img/"${NODE1_FRAME}"/vmlinux.bin
    wget https://repo.openeuler.org/"$openeulerversion"/stratovirt_img/"${NODE1_FRAME}"/"$openeulerversion"-stratovirt-"${NODE1_FRAME}".img.xz
    if [[ ! -f vmlinux.bin || ! -f "$openeulerversion"-stratovirt-"${NODE1_FRAME}".img.xz ]]; then
        LOG_WARN "Required image files (vmlinux.bin or stratovirt .img.xz) are missing. Cannot proceed with the test."
        exit 255
    fi
    xz -d "$openeulerversion"-stratovirt-"${NODE1_FRAME}".img.xz
}

function create_stratovirt_vm() {
    rm -f /tmp/stratovirt.socket
    expect <<-EOF
        log_file testlog
        spawn stratovirt \
    -kernel vmlinux.bin \
    -append console=ttyS0 root=/dev/vda rw reboot=k panic=1 \
    -drive file="$openeulerversion"-stratovirt-"${NODE1_FRAME}".img,id=rootfs,readonly=false \
    -device virtio-blk-device,drive=rootfs,id=blk1 \
    -qmp unix:/tmp/stratovirt.socket,server,nowait \
    -serial stdio
        sleep 5
        expect "StratoVirt login:"
        send "root\\n"
        sleep 5
        expect "Password:"
        send "openEuler12#$\\n"
        expect "root@StratoVirt"
        send "sleep 120\\n"
        expect eof
EOF
}
