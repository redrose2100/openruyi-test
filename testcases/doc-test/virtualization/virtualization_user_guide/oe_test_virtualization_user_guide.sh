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
#@Date          :   2023-07-28
#@License       :   Mulan PSL v2
#@Desc          :   Installing virtualization, Ready environment, Manage virtual machines, Manage system resources, Management equipment
#####################################
# shellcheck disable=SC1090,SC1091,SC2154,SC2009,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    EXECUTE_T="60m"
    source /etc/openEuler-latest
    Network_card_num=$(ip a | grep -c "state UP")
    if [ "$Network_card_num" -ge 2 ]; then
        Network_card_name=$(ip a | grep "state UP" | awk -F":" '{print $2}' | tail -n 1 | tr -d ' ')
    else
        exit
    fi
    Online_CPU_list=$(lscpu | grep "On-line CPU(s) list" | awk -F":" '{print $2}' | tr -d ' ')
    cp openEulerVM-"${NODE1_FRAME}".xml openEulerVM-"${NODE1_FRAME}".xml.bak
    mv openEulerVM-"${NODE1_FRAME}".xml openEulerVM.xml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Installing virtualization
    DNF_INSTALL "qemu libvirt wget"
    systemctl start libvirtd
    CHECK_RESULT $? 0 0 "Failed to start libvirtd.socket"
    file /dev/kvm
    CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
    test -d /sys/module/kvm/parameters
    CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
    test -f /sys/module/kvm/uevent
    CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
    rpm -qi qemu | grep "Summary"
    CHECK_RESULT $? 0 0 "Failed to install qemu"
    rpm -qi libvirt | grep "Summary"
    CHECK_RESULT $? 0 0 "Failed to install libvirt"
    SLEEP_WAIT 3
    systemctl status libvirtd | grep "active (running)"
    CHECK_RESULT $? 0 0 "libvirtd.socket is not running"

    # Ready environment
    # Prepare the VM image
    DNF_INSTALL qemu-img
    qemu-img create -f qcow2 openEuler-image.qcow2 4G | grep "openEuler-image.qcow2"
    CHECK_RESULT $? 0 0 "Failed to create image file"
    qemu-img info openEuler-image.qcow2 | grep "virtual size: 4 GiB"
    CHECK_RESULT $? 0 0 "Failed to query the current VM image"
    qemu-img resize openEuler-image.qcow2 +20G | grep "Image resized"
    CHECK_RESULT $? 0 0 "Failed to expand the VM image disk space"
    qemu-img info openEuler-image.qcow2 | grep "virtual size: 24 GiB"
    CHECK_RESULT $? 0 0 "Failed to query the adjusted VM image"
    # Prepare the VM network
    DNF_INSTALL "bridge-utils net-tools"
    brctl addbr br0
    CHECK_RESULT $? 0 0 "Failed to create bridge br0"
    brctl addif br0 "${Network_card_name}"
    CHECK_RESULT $? 0 0 "Failed to bind physical NIC to the Linux bridge"
    ifconfig "${Network_card_name}" 0.0.0.0
    CHECK_RESULT $? 0 0 "Failed to set the IP address of physical NIC"
    ifconfig br0 192.168.1.2 netmask 255.255.255.0
    CHECK_RESULT $? 0 0 "Failed to config a static IP address for br0"
    # Prepare the boot firmware
    if [ "${NODE1_FRAME}"x == "aarch64"x ]; then
        DNF_INSTALL edk2-aarch64
        rpm -qi edk2-aarch64 | grep "edk2-aarch64"
        CHECK_RESULT $? 0 0 "Failed to install edk2-aarch64"
    else
        DNF_INSTALL edk2-ovmf
        rpm -qi edk2-ovmf | grep "edk2-ovmf"
        CHECK_RESULT $? 0 0 "Failed to install edk2-ovmf"
    fi
    # Configure non-root users
    useradd testuser
    CHECK_RESULT $? 0 0 "Failed to add testuser"
    usermod -a -G libvirt testuser
    CHECK_RESULT $? 0 0 "Failed to add testuser to the libvirt user group"
    su - testuser -c "echo 'export LIBVIRT_DEFAULT_URI=\"qemu:///system\"' >> ~/.bashrc"
    CHECK_RESULT $? 0 0 "Failed to config env variables for testuser"
    su - testuser -c "source ~/.bashrc"
    CHECK_RESULT $? 0 0 "Failed to take effect the configuration"
    if [ "${NODE1_FRAME}"x == "aarch64"x ]; then
        sed -i "/<\/domain>/i\<seclabel type='dynamic' model='dac' relabel='yes'/>" openEulerVM.xml
        CHECK_RESULT $? 0 0 "Failed to edit openEulerVM.xml cfg file"
    fi

    # Manage virtual machines
    if [ "${NODE1_FRAME}"x == "riscv64"x ]; then
        # 在 riscv64 可以正确获取 /etc/openEuler-latest 前固定版本为 openEuler-24.03-LTS-SP1
        # https://gitee.com/src-openeuler/openEuler-latest-release/issues/IC5KC3
        openeulerversion="openEuler-24.03-LTS-SP1"
        wget -c -O /mnt/openEuler-RISCV_VIRT_CODE.fd https://repo.openeuler.org/"${openeulerversion}"/virtual_machine_img/riscv64/RISCV_VIRT_CODE.fd
        wget -c -O /mnt/openEuler-RISCV_VIRT_VARS.fd https://repo.openeuler.org/"${openeulerversion}"/virtual_machine_img/riscv64/RISCV_VIRT_VARS.fd
    fi
    wget -c -P /mnt https://repo.openeuler.org/"${openeulerversion}"/ISO/"${NODE1_FRAME}"/"${openeulerversion}"-"${NODE1_FRAME}"-dvd.iso
    mv openEuler-image.qcow2 /mnt
    if [ "${NODE1_FRAME}"x == "aarch64"x ]; then
        sed -i "s/openEuler-22.03-LTS-aarch64-dvd.iso/${openeulerversion}-${NODE1_FRAME}-dvd.iso/" openEulerVM.xml
    elif [ "${NODE1_FRAME}"x == "riscv64"x ]; then
        sed -i "s/openEuler-24.03-LTS-SP1-riscv64-dvd.iso/${openeulerversion}-${NODE1_FRAME}-dvd.iso/" openEulerVM.xml
    else
        sed -i "28a<disk type='file' device='cdrom'> \
      <driver name='qemu' type='raw'/> \
      <source file='/mnt/${openeulerversion}-${NODE1_FRAME}-dvd.iso'/> \
      <target dev='sdb' bus='scsi'/> \
      <readonly/> \
      <boot order='2'/> \
    </disk>" openEulerVM.xml
    fi
    virsh create openEulerVM.xml | grep "Domain .*openEulerVM.* created from openEulerVM.xml"
    CHECK_RESULT $? 0 0 "Failed to create a openEulerVM"
    virsh save openEulerVM openEulerVM.bak | grep "Domain .*openEulerVM.* saved to openEulerVM.bak"
    CHECK_RESULT $? 0 0 "Failed to save the openEulerVM"
    virsh restore openEulerVM.bak | grep "Domain restored from openEulerVM.bak"
    CHECK_RESULT $? 0 0 "Failed to restore the openEulerVM"
    virsh suspend openEulerVM | grep "Domain .*openEulerVM.* suspended"
    CHECK_RESULT $? 0 0 "Failed to suspend the openEulerVM"
    virsh resume openEulerVM | grep "Domain .*openEulerVM.* resumed"
    CHECK_RESULT $? 0 0 "Failed to resume the openEulerVM"
    virsh list --all | grep "running"
    CHECK_RESULT $? 0 0 "The state of the openEulerVM is not running"
    virsh destroy openEulerVM | grep "Domain .*openEulerVM.* destroyed"
    CHECK_RESULT $? 0 0 "Failed to destroy the openEulerVM"
    virsh define openEulerVM.xml | grep "Domain .*openEulerVM.* defined from openEulerVM.xml"
    CHECK_RESULT $? 0 0 "Failed to define a openEulerVM"
    virsh start openEulerVM | grep "Domain .*openEulerVM.* started"
    CHECK_RESULT $? 0 0 "Failed to start the openEulerVM"
    virsh reboot openEulerVM | grep "Domain .*openEulerVM.* is being rebooted"
    CHECK_RESULT $? 0 0 "Failed to reboot the openEulerVM"
    SLEEP_WAIT 30
    virsh destroy openEulerVM | grep "Domain .*openEulerVM.* destroyed"
    CHECK_RESULT $? 0 0 "Failed to destroy the openEulerVM"
    # Query VM information
    virsh list | grep -v "openEulerVM"
    CHECK_RESULT $? 0 0 "Failed to list of running and paused VMS"
    virsh list --all | grep "openEulerVM"
    CHECK_RESULT $? 0 0 "Failed to list of shut off VMS"
    virsh start openEulerVM | grep "Domain .*openEulerVM.* started"
    CHECK_RESULT $? 0 0 "Failed to start the openEulerVM"
    virsh dominfo openEulerVM | grep "UUID"
    CHECK_RESULT $? 0 0 "Failed to query basic VM information"
    virsh domstate openEulerVM | grep "running"
    CHECK_RESULT $? 0 0 "The state of the openEulerVM is not running"
    virsh schedinfo openEulerVM | grep "cpu_shares"
    CHECK_RESULT $? 0 0 "Failed to query the openEulerVM scheduling information"
    virsh vcpucount openEulerVM | grep "maximum"
    CHECK_RESULT $? 0 0 "Failed to query the number of vcpus of the openEulerVM"
    virsh domblklist openEulerVM | grep "/mnt/openEuler-image.qcow2"
    CHECK_RESULT $? 0 0 "Failed to query the disk information of the openEulerVM"
    virsh domiflist openEulerVM | grep "br0"
    CHECK_RESULT $? 0 0 "Failed to query the NIC information of the openEulerVM"
    virsh iothreadinfo openEulerVM | grep "IOThread"
    CHECK_RESULT $? 0 0 "Failed to query I/O threads of the openEulerVM"
    # Log in to the VM
    virsh vncdisplay openEulerVM | grep ":0"
    CHECK_RESULT $? 0 0 "Failed to query the VNC port number used by the openEulerVM"

    # Manage system resources
    # Managing virtual CPUs
    # On-line modification-CPU share
    virsh schedinfo openEulerVM | grep "cpu_shares     : 1024"
    CHECK_RESULT $? 0 0 "Failed to query the CPU quota of the openEulerVM"
    virsh schedinfo openEulerVM --live cpu_shares=2048 | grep "cpu_shares     : 2048"
    CHECK_RESULT $? 0 0 "Failed to change the CPU quota of the openEulerVM online"
    virsh schedinfo openEulerVM | grep "cpu_shares     : 2048"
    CHECK_RESULT $? 0 0 "The online modify has not taken effect"
    # On-line modification-Bind the QEMU process to the physical CPU
    virsh emulatorpin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "Failed to query the physical CPU range bound to the QEMU process"
    virsh emulatorpin openEulerVM --live 2-3
    CHECK_RESULT $? 0 0 "Failed to bind the physical CPU range of the QEMU process online"
    virsh emulatorpin openEulerVM | grep "2-3"
    CHECK_RESULT $? 0 0 "The online binding has not taken effect"
    # On-line modification-Adjust the virtual CPU binding relationship
    virsh vcpupin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "Failed to query the current vCPU binding info of the openEulerVM"
    virsh vcpupin openEulerVM --live 0 2-3
    CHECK_RESULT $? 0 0 "Failed to adjust vCPU binding info of the openEulerVM online"
    virsh vcpupin openEulerVM | grep "2-3"
    CHECK_RESULT $? 0 0 "The online adjust has not taken effect"
    virsh destroy openEulerVM
    SLEEP_WAIT 20 "virsh start openEulerVM"
    virsh schedinfo openEulerVM | grep "cpu_shares     : 1024"
    CHECK_RESULT $? 0 0 "The current online changed the CPU quota of the openEulerVM is not invalid"
    virsh emulatorpin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "The current online changed the physical CPU range bound to the QEMU process is not invalid"
    virsh vcpupin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "The current online changed the current vCPU binding info of the openEulerVM is not invalid"
    # Persistent modification-CPU share
    virsh schedinfo openEulerVM --config cpu_shares=2048 | grep "cpu_shares     : 2048"
    CHECK_RESULT $? 0 0 "Failed to persistent modificate the CPU quota of the openEulerVM"
    virsh schedinfo openEulerVM | grep "cpu_shares     : 1024"
    CHECK_RESULT $? 0 0 "Changes to the cpu_shares value should not take effect immediately, but they have taken effect"
    # Persistent binding-Bind the QEMU process to the physical CPU
    virsh emulatorpin openEulerVM --config 0-3,^1
    CHECK_RESULT $? 0 0 "Failed to persist bind the physical CPU range of the QEMU process"
    virsh emulatorpin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "Changes to the physical CPU range of the QEMU process should not take effect immediately, but they have taken effect"
    # Persistence adjustment--Bind the QEMU process to the physical CPU
    virsh vcpupin openEulerVM --config 0 0-3,^1
    CHECK_RESULT $? 0 0 "Failed to persist adjust the current vCPU binding info of the openEulerVM"
    virsh vcpupin openEulerVM | grep "$Online_CPU_list"
    CHECK_RESULT $? 0 0 "Changes to the current vCPU binding info of the openEulerVM should not take effect immediately, but they have taken effect"
    virsh destroy openEulerVM
    SLEEP_WAIT 20 "virsh start openEulerVM"
    virsh schedinfo openEulerVM | grep "cpu_shares     : 2048"
    CHECK_RESULT $? 0 0 "Changes to the cpu_shares value should have taken effect, but it did not"
    virsh emulatorpin openEulerVM | grep "0,2-3"
    CHECK_RESULT $? 0 0 "Changes to the physical CPU range of the QEMU process should have taken effect, but it did not"
    virsh vcpupin openEulerVM | grep "0,2-3"
    CHECK_RESULT $? 0 0 "Changes to the current vCPU binding info of the openEulerVM should have taken effect, but it did not"

    # Management equipment
    virsh domblklist openEulerVM | grep "/mnt/openEuler-image.qcow2"
    CHECK_RESULT $? 0 0 "Failed to query the disk information of the openEulerVM"
    virsh snapshot-create-as --domain openEulerVM --disk-only --diskspec vda,snapshot=external,file=/mnt/openEuler-snapshot1.qcow2 --atomic | grep "created"
    CHECK_RESULT $? 0 0 "Failed to create a disk snapshot for the openEulerVM"
    virsh snapshot-list openEulerVM | grep "disk-snapshot"
    CHECK_RESULT $? 0 0 "Failed to query a disk snapshot for the openEulerVM"
    Snapshot_name=$(virsh snapshot-list openEulerVM | grep 'disk-snapshot' | awk '{print $1}')
    virsh snapshot-delete --domain openEulerVM "$Snapshot_name" --metadata | grep "deleted"
    CHECK_RESULT $? 0 0 "Failed to delete a disk snapshot for the openEulerVM"

    # Best practice
    if [ "$(getenforce)" != "Disabled" ]; then
        ps -eZ | grep qemu | grep "svirt_t:s0:c"
        CHECK_RESULT $? 0 0 "sVirt defense is not enabled for the QEMU process on the openEulerVM"
    fi

    virsh destroy openEulerVM
    if [[ "${NODE1_FRAME}"x == "aarch64"x || "${NODE1_FRAME}"x == "riscv64"x ]]; then
        virsh undefine openEulerVM --nvram | grep "Domain .*openEulerVM.* has been undefined"
        CHECK_RESULT $? 0 0 "Failed to undefine the openEulerVM"
    else
        virsh undefine openEulerVM | grep "Domain .*openEulerVM.* has been undefined"
        CHECK_RESULT $? 0 0 "Failed to undefine the openEulerVM"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ifconfig br0 down
    brctl delbr br0
    su - testuser -c "sed -i '$d' ~/.bashrc"
    su - testuser -c "source ~/.bashrc"
    userdel -r testuser
    DNF_REMOVE "$@"
    rm -rf /mnt/openEuler* openEulerVM.bak openEulerVM.xml
    export LANG=$Default_LANG
    mv openEulerVM-"${NODE1_FRAME}".xml.bak openEulerVM-"${NODE1_FRAME}".xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
