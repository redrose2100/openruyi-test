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
#@Date          :   2023-08-16
#@License       :   Mulan PSL v2
#@Desc          :   Installing StratoVirt & Ready environment
#####################################
# shellcheck disable=SC1090,SC1091,SC2010,SC2154,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    EXECUTE_T="60m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    source /etc/openEuler-latest
    Mmio_Sign=0
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Installing StratoVirt
    DNF_INSTALL stratovirt
    stratovirt -version | grep "StratoVirt"
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to install StratoVirt"

    # Ready environment
    # Prepare equipment and tools
    if ! ls /dev/vhost-vsock | grep "/dev/vhost-vsock"; then
        Mmio_Sign=1
        modprobe vhost_vsock
	SLEEP_WAIT 20
        CHECK_RESULT $? 0 0 "Failed to import device /dev/vhost-vsock"
    fi
    CHECK_RESULT $? 0 0 "The /dev/vhost-vsock device does not exist"
    DNF_INSTALL "nmap git"
    # Creating a kernel Image
    cd /home || exit
    git clone https://gitee.com/openeuler/kernel.git
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to git clone kernel"
    cd kernel || exit
    git checkout "$openeulerversion" 2>&1 | grep "Switched to a new branch"
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to switch the kernel version to $openeulerversion"
    git clone https://gitee.com/openeuler/stratovirt.git
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to git clone stratovirt"
    mv stratovirt/docs/kernel_config/* .
    kernel_v=$(echo "$kernelversion" | awk -F'-' '{print $1}' | awk -F'.' 'OFS="."{$NF="";print}' | awk '{print substr($0, 1, length($0)-1)}')
    cp standard_vm/kernel_config_"${kernel_v}"_"${NODE1_FRAME}" kernel.config
    DNF_INSTALL "make gcc flex bison"
    make olddefconfig | grep "configuration written to .config"
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to configure and compile the Linux kernel"
    DNF_INSTALL "elfutils-libelf-devel openssl-devel dwarves"
    make -j vmlinux && objcopy -O binary vmlinux vmlinux.bin
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to convert the kernel image to PE format"
    if [ "${NODE1_FRAME}"x == "x86_64"x ]; then
        make -j bzImage
	SLEEP_WAIT 20
        CHECK_RESULT $? 0 0 "Failed to convert the kernel image to bzImzge format"
    fi
    # Create a rootfs image
    cd /home || exit
    dd if=/dev/zero of=./rootfs.ext4 bs=1G count=10
    CHECK_RESULT $? 0 0 "Failed to create a file with 10GiB of space"
    mkfs.ext4 ./rootfs.ext4 | grep "Writing superblocks and filesystem"
    CHECK_RESULT $? 0 0 "Failed to create an empty ext4 file system"
    mkdir /mnt/rootfs
    sudo mount ./rootfs.ext4 /mnt/rootfs && cd /mnt/rootfs || exit
    CHECK_RESULT $? 0 0 "Failed to mount a file image"
    alpine_minirootfs_pkg=$(curl -s http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/"${NODE1_FRAME}"/ |grep -E '^<a' |awk -F'"' '{print $2}' | grep -E "alpine-minirootfs-[0-9].[0-9]+.[0-9]-${NODE1_FRAME}.tar.gz$" | sort | tail -1)
    wget http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/"${NODE1_FRAME}"/"${alpine_minirootfs_pkg}"
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to get alpine-mini rootfs"
    DNF_INSTALL tar
    tar -zxvf alpine-minirootfs*.tar.gz
    rm -f alpine-minirootfs*.tar.gz sbin/init
    touch sbin/init && cat >sbin/init <<EOF
#! /bin/sh
mount -t devtmpfs dev /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys
ip link set up dev lo

exec /sbin/getty -n -l /bin/sh 115200 /dev/ttyS0
poweroff -f
EOF
    sudo chmod +x sbin/init
    CHECK_RESULT $? 0 0 "Failed to make a simple /sbin/init for an ext4 file image"
    cd /home || exit
    umount /mnt/rootfs
    CHECK_RESULT $? 0 0 "Failed to uninstall the rootfs image"
    # Get the firmware required for standard boot
    if [ "${NODE1_FRAME}"x == "x86_64"x ]; then
        sudo yum install -y edk2-ovmf
    else
        sudo yum install -y edk2-aarch64
    fi

    # Run StratoVirt
    rm -f /tmp/stratovirt.socket
    stratovirt \
        -kernel /home/kernel/vmlinux.bin \
        -append console=ttyS0 root=/dev/vda rw reboot=k panic=1 \
        -drive file=/home/rootfs.ext4,id=rootfs,readonly=false \
        -device virtio-blk-device,drive=rootfs,id=blk1 \
        -qmp unix:/tmp/stratovirt.socket,server,nowait \
        -serial stdio
    SLEEP_WAIT 20
    CHECK_RESULT $? 0 0 "Failed to run StratoVirt"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "$Mmio_Sign" == 1 ]; then
        rmmod vhost_vsock
    fi
    rm -rf kernel rootfs.ext4 /mnt/rootfs /tmp/stratovirt.socket
    DNF_REMOVE "$@"
    if [ "${NODE1_FRAME}"x == "x86_64"x ]; then
        yum remove -y edk2-ovmf
    else
        yum remove -y edk2-aarch64
    fi
    export LANG=$Default_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
