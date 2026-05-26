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
#@Author    	:   fanlirong
#@Contact   	:   fanlirong1@h-partners.com
#@Date      	:   2025-12-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Prepare packages
#####################################

yum install -y qemu edk2-aarch64 libvirt net-tools bridge-utils

sed -i "s/--timeout 120/--listen/g" /usr/lib/systemd/system/libvirtd.service
grep -q "libvirtd.log" /etc/libvirt/libvirtd.conf || cat >> /etc/libvirt/libvirtd.conf << 'EOF'
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
listen_addr = "0.0.0.0"
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0770"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"
auth_tls = "none"
log_level = 2
log_outputs = "2:file:/var/log/libvirt/libvirtd.log"
EOF
grep -q "bonding_dev_0" /etc/libvirt/qemu.conf || cat >> /etc/libvirt/qemu.conf << EOF
user = "root"
group = "root"
namespaces = []
cgroup_controllers = [ "cpu", "devices", "memory", "blkio", "cpuset", "cpuacct" ]
cgroup_device_acl = [
"/dev/null", "/dev/full", "/dev/zero",
"/dev/random", "/dev/urandom",
"/dev/ptmx", "/dev/kvm",
"/dev/rtc", "/dev/hpet", "/dev/mem",
"/dev/ham_migrate",
"/dev/infiniband/rdma_cm",
"/dev/obmm",
$(find /dev/uburma -maxdepth 1 -type c 2>/dev/null | grep -v bonding_dev_0 | sort | sed 's/.*/"&",/')
"/dev/uburma/bonding_dev_0",
"/dev/ubcore/ubcore"
"/dev/ummu/tid",
]
max_files = 4096
max_core = "unlimited"
seccomp_sandbox = 0
migration_address = "0.0.0.0"
EOF

systemctl mask libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket libvirtd-tcp.socket libvirtd-tls.socket
systemctl restart libvirtd
