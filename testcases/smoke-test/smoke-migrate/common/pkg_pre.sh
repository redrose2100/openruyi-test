#!/bin/bash

yum install -y qemu
yum install -y edk2
yum install -y libvirt
yum install -y bridge-utils

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
grep -q "udma" /etc/libvirt/qemu.conf || cat >> /etc/libvirt/qemu.conf << 'EOF'
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
"/dev/uburma/udma2",
"/dev/uburma/udma3",
"/dev/uburma/udma4",
"/dev/uburma/udma5",
"/dev/uburma/udma6",
"/dev/uburma/udma7",
"/dev/uburma/bonding_dev_0",
"/dev/ummu/tid",
]
max_files = 4096
max_core = "unlimited"
seccomp_sandbox = 0
migration_address = "0.0.0.0"
EOF

systemctl mask libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket libvirtd-tcp.socket libvirtd-tls.socket
systemctl restart libvirtd
