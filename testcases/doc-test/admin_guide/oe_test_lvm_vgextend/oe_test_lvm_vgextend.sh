#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duanxuemin
# @Contact   :   52515856@qq.com
# @Date      :   2020-04-27
# @License   :   Mulan PSL v2
# @Desc      :   Add disks to VG
# ############################################
source "${OET_PATH}/testcases/doc-test/admin_guide/common/disk_lib.sh"
function pre_test() {
    LOG_INFO "Start environment preparation."
    check_free_disk
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        local_disk=$(lsblk -dn -o NAME | grep -vE '^(loop|nbd|ram)' | sed -n '2p')
        local_disk1=$(lsblk -dn -o NAME | grep -vE '^(loop|nbd|ram)' | sed -n '3p')
    fi
    DNF_INSTALL lvm2
    pvcreate -y "/dev/${local_disk}" "/dev/${local_disk1}"
    vgcreate -y openeulertest "/dev/${local_disk}"
    lvcreate -y -L 50MB -n test openeulertest
    number=$(pvs -o+pv_used 2>&1 | wc -l)
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    pvdisplay | grep "PV Name" | grep "/dev/${local_disk}"
    CHECK_RESULT $?
    pvdisplay | grep "PV Name" | grep "/dev/${local_disk1}"
    CHECK_RESULT $?
    vgdisplay | grep "VG Name" | grep openeulertest
    CHECK_RESULT $?
    lvdisplay | grep "LV Name" | grep test
    CHECK_RESULT $?
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        test "${number}" -gt 2
    else
        test "${number}" -gt 3
    fi
    CHECK_RESULT $?
    vgextend openeulertest "/dev/${local_disk1}" -y
    pvmove "/dev/${local_disk}" "/dev/${local_disk1}"
    CHECK_RESULT $?
    pvs -o+pv_used | grep "${local_disk}" | grep 0
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test
    vgremove -y openeulertest
    pvremove -y "/dev/${local_disk}" "/dev/${local_disk1}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
