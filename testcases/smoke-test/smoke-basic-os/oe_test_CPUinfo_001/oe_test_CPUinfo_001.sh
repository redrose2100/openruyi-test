#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Query CPU configure test-lscpu
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL lshw
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    lscpu | grep "^CPU(s)" | grep -E '[0-9]'
    CHECK_RESULT $?

    if [ "$NODE1_FRAME"x != "riscv64"x ]; then
        lscpu | grep "Vendor ID"
        CHECK_RESULT $?
    fi

    if ! lshw -c system | grep product | grep qemu; then
        lshw -c cpu | grep "capacity" | grep "Hz"
        CHECK_RESULT $?
    fi

    if [ "$NODE1_FRAME"x == "aarch64"x ]; then
        grep "0x48" /proc/cpuinfo
        CHECK_RESULT $?
    elif [ "$NODE1_FRAME"x == "riscv64"x ]; then
        grep "hart" /proc/cpuinfo
        CHECK_RESULT $?
    else
        grep "$(lscpu | grep "^Vendor ID" | awk -F " " '{print$3}')" /proc/cpuinfo
        CHECK_RESULT $?
    fi
    if [[ "$(dmidecode -s system-product-name)" =~ "KVM" ]]; then
        cpu_num1=$(lscpu | grep "^CPU(s):" | awk -F ' ' '{print $2}')
        sockets_num=$(lshw -c cpu | grep -c 'physical id')
        enabledcores_num=$(lshw -c cpu | grep -iw "enabledcores" | awk '{print $2}'| awk -F '=' '{print$2}' | head -n 1)
        threads_num=$(lshw -c cpu | grep -iw "threads" | awk '{print $4}'| awk -F '=' '{print$2}' | head -n 1)
        cpu_num2=$((sockets_num * enabledcores_num * threads_num))
        [ "${cpu_num1}" -le "${cpu_num2}" ]
        CHECK_RESULT $?
    fi
    Disk_name=$(lshw -c disk | grep 'logical name' | grep -v 'sr0' | grep -v 'cdrom' | awk -F ': ' 'NR==1{print $2}')
    Disk_size=$(lshw -c disk | grep "$Disk_name$" -A 5 | grep 'size:' | awk -F ': ' '{print $2}' | awk -F 'GiB' '{print $1}')
    if fdisk -l "${Disk_name}" | grep Disk | grep 'TiB'; then
        tmp_disk=$(fdisk -l "${Disk_name}" | grep Disk | grep TiB | awk -F ' ' '{print $3}')
        Disk_size2=$(echo "${tmp_disk}" | awk '{printf("%0.0f\n",$1*1024)}')
        [ "${Disk_size2}" -lt $((Disk_size + 20)) ] && [ "${Disk_size2}" -gt $((Disk_size - 20)) ]
        CHECK_RESULT $?
    else
        tmp_disk=$(fdisk -l "${Disk_name}" | grep Disk | grep GiB | awk -F ' ' '{print $3}')
        if echo "${tmp_disk}" | grep '\.';then
            Disk_size2=$(echo "${tmp_disk}" | awk -F '.' '{print $1}')
        else
            Disk_size2="${tmp_disk}"
        fi
        [ "${Disk_size2}" -lt $((Disk_size + 5)) ] && [ "${Disk_size2}" -gt $((Disk_size - 5)) ]
        CHECK_RESULT $?
    fi
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
