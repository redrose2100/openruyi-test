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
# @Desc      :   Test python3-libvirt VM lifecycle management
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    VM_NAME="test_vm_$(date +%s)"
    VM_XML="/tmp/test_vm_$(date +%s).xml"
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
    elif [ "${NODE1_FRAME}" == "aarch64" ];then
        DNF_INSTALL "python3-libvirt libvirt qemu-kvm edk2-aarch64"
        chmod 600 /dev/kvm
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
    <serial type='pty'>
      <target type='system-serial' port='0'>
        <model name='pl011'/>
      </target>
    </serial>
	</devices>
</domain>
EOF
    else
        LOG_ERROR "Unsupported architecture: ${NODE1_FRAME}. If needed, adapt the test cases to the target architecture."
        exit 255
    fi
    systemctl start libvirtd
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test VM creation
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
with open('${VM_XML}', 'r') as f:
    xml = f.read()
domain = conn.defineXML(xml)
print(domain.name())
conn.close()
    " | grep -q "${VM_NAME}"
    CHECK_RESULT $? 0 0 "VM define failed"
    # Test VM start
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.create()
print(domain.state()[0])
conn.close()
    " | grep -q "^1$"
    CHECK_RESULT $? 0 0 "VM start failed"
    # Test VM suspend
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.suspend()
print(domain.state()[0])
conn.close()
    " | grep -q "^3$"
    CHECK_RESULT $? 0 0 "VM suspend failed"
    # Test VM resume
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.resume()
print(domain.state()[0])
conn.close()
    " | grep -q "^1$"
    CHECK_RESULT $? 0 0 "VM resume failed"
    # Test VM shutdown
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.shutdown()
conn.close()
    "
    CHECK_RESULT $? 0 0 "VM shutdown failed"
    SLEEP_WAIT 2
    # Test VM force destroy
    python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.destroy()
print(domain.state()[0])
conn.close()
    " | grep -q "^5$"
    CHECK_RESULT $? 0 0 "VM destroy failed"
    # Test VM undefine
    if [ "${NODE1_FRAME}" == "x86_64" ];then
        python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.undefine()
conn.close()
        "
        CHECK_RESULT $? 0 0 "VM undefine failed"
    elif [ "${NODE1_FRAME}" == "aarch64" ];then
        python3 -c "
import libvirt
conn = libvirt.open('qemu:///session')
domain = conn.lookupByName('${VM_NAME}')
domain.undefineFlags(libvirt.VIR_DOMAIN_UNDEFINE_NVRAM)
conn.close()
        "
        CHECK_RESULT $? 0 0 "VM undefine failed"
    else
        LOG_ERROR "Unsupported architecture: ${NODE1_FRAME}. If needed, adapt the test cases to the target architecture."
        exit 255
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${VM_XML}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"