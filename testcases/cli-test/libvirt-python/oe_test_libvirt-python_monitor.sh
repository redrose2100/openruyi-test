#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-libvirt VM status monitoring
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    VM_NAME="monitor_vm_$(date +%s)"
    VM_XML="/tmp/monitor_vm_$(date +%s).xml"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" == "x86_64" ];then
        DNF_INSTALL "python3-libvirt libvirt qemu-kvm edk2-ovmf"
        cat > "${VM_XML}" << EOF
<domain type='kvm'>
  <name>${VM_NAME}</name>
  <memory unit='MiB'>128</memory>
  <vcpu>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc'>hvm</type>
  </os>
  <devices>
    <disk type='file' device='cdrom'>
      <source file='/usr/share/edk2/ovmf/OVMF_CODE.fd'/>
      <target dev='hda' bus='ide'/>
      <readonly/>
    </disk>
    <interface type='network'>
      <source network='default'/>
    </interface>
  </devices>
</domain>
EOF
    else
        DNF_INSTALL "python3-libvirt libvirt qemu-kvm edk2-aarch64"
        chmod 600 /dev/kvm
        qemu-img create -f qcow2 /tmp/"${VM_NAME}".qcow2 10G
        cat > "${VM_XML}" << EOF
<domain type='kvm'>
  <name>${VM_NAME}</name>
  <memory unit='MiB'>512</memory>
  <vcpu>1</vcpu>
  <os>
    <type arch='aarch64' machine='virt'>hvm</type>
    <loader readonly='yes' type='pflash'>/usr/share/edk2/aarch64/QEMU_EFI-pflash.raw</loader>
    <nvram template='/usr/share/edk2/aarch64/vars-template-pflash.raw'/>
  </os>
  <features>
    <acpi/>
    <gic version='3'/>
  </features>
  <cpu mode='host-passthrough'/>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/tmp/${VM_NAME}.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <serial type='pty'>
      <target type='system-serial' port='0'>
        <model name='pl011'/>
      </target>
    </serial>
	</devices>
</domain>
EOF
    fi
    systemctl start libvirtd
    SLEEP_WAIT 3
    # Create VM
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
with open('${VM_XML}', 'r') as f:
    xml = f.read()
conn.defineXML(xml)
conn.close()
    "
    CHECK_RESULT $? 0 0 "VM define failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test VM state retrieval
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
print(domain.state()[0])
conn.close()
    " | grep -q "^5$"
    CHECK_RESULT $? 0 0 "VM state get failed"
    # Test VM UUID retrieval
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
print(domain.UUIDString())
conn.close()
    " | grep -q "^[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}$"
    CHECK_RESULT $? 0 0 "VM UUID get failed"
    # Test VM ID retrieval
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
print(domain.ID())
conn.close()
    " | grep -q "^-1$"
    CHECK_RESULT $? 0 0 "VM ID get failed"
    # Test VM memory information
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
print(domain.maxMemory())
conn.close()
    " | grep "$(virsh dumpxml "${VM_NAME}" | xmllint --xpath 'string(//memory[@unit="KiB"])' -)"
    CHECK_RESULT $? 0 0 "VM maxMemory get failed"
    # Test VM vCPU count
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.create()
print(domain.state()[0])
conn.close()
    "
    SLEEP_WAIT 3
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
print(domain.maxVcpus())
conn.close()
    " | grep -q "^1$"
    CHECK_RESULT $? 0 0 "VM maxVcpus get failed"
    # Test VM XML description
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
xml = domain.XMLDesc()
print(1 if '<name>${VM_NAME}</name>' in xml else 0)
conn.close()
    " | grep -q "^1$"
    CHECK_RESULT $? 0 0 "VM XMLDesc get failed"
    # Test all domains listing
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
doms = conn.listAllDomains()
print(len(doms))
conn.close()
    " | grep -q "^[1-9][0-9]*$"
    CHECK_RESULT $? 0 0 "listAllDomains failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "${NODE1_FRAME}" == "x86_64" ];then
        python3 -c "
import libvirt
try:
    conn = libvirt.open('qemu:///session')
    domain = conn.lookupByName('${VM_NAME}')
    try:
        domain.destroy()
    except:
        pass
    domain.undefine()
    conn.close()
except:
    pass
        "
        CHECK_RESULT $? 0 0 "VM undefine failed"
    else
        python3 -c "
import libvirt
try:
    conn = libvirt.open('qemu:///session')
    domain = conn.lookupByName('${VM_NAME}')
    try:
        domain.destroy()
    except:
        pass
    domain.undefineFlags(libvirt.VIR_DOMAIN_UNDEFINE_NVRAM)
    conn.close()
except:
    pass
        "
        CHECK_RESULT $? 0 0 "VM undefine failed"
    fi
    rm -rf "${VM_XML}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"