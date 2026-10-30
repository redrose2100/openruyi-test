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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Enable periodic block discard
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
export local_disk
export local_disk1
export local_disk2
export local_disk3

# 用例至少需要的空闲测试盘数量。可在 source 本文件之前赋值覆盖；
# 未覆盖时按用例脚本里实际引用到的 local_disk / local_disk1 / local_disk2 /
# local_disk3 自动推断，避免“只分到一块盘却按两块用”导致 ${local_disk1} 为空，
# 把 /dev/ 这个目录当成设备名交给 mkfs / pvcreate / fdisk。
CHECK_FREE_DISK_MIN=${CHECK_FREE_DISK_MIN:-}

# 扫描当前用例脚本，推断它真正需要的测试盘数量（1..4，默认 1）。
# $0 是 mugen 执行的用例脚本本身，本文件只是被 source 进来。
function get_required_disk_num() {
    local _case_src=$0
    local _n=1 _i
    [ -n "${_case_src}" ] && [ -r "${_case_src}" ] || {
        echo 1
        return
    }
    for _i in 1 2 3; do
        if grep -qF "local_disk${_i}" "${_case_src}" 2>/dev/null; then
            _n=$((_i + 1))
        fi
    done
    echo "${_n}"
}

# 取所有真实块设备文件系统所在整盘（裸名，空格分隔），用于拦截“拿系统盘做破坏性测试”。
# 覆盖根、/boot、/boot/efi、/opt 等任意已挂载分区以及 swap 设备，不只看 "/"。
# 用 `lsblk -s` 向上追溯到物理盘，因此 /dev/mapper/xxx 这类 LVM/加密设备也能正确解析。
function get_system_disk() {
    local _protected _dev
    _protected=$(
        {
            lsblk -rno NAME,MOUNTPOINT 2>/dev/null | awk '$2 != "" {print "/dev/" $1}'
            awk 'NR > 1 && $1 ~ /^\/dev\// {print $1}' /proc/swaps 2>/dev/null
            findmnt -no SOURCE / 2>/dev/null
        } | while read -r _dev; do
            [ -n "$_dev" ] || continue
            # dm 设备在 lsblk 里是 openeuler-root 这种名字，真实节点在 /dev/mapper 下
            if [ ! -b "$_dev" ] && [ -b "/dev/mapper/$(basename "$_dev")" ]; then
                _dev="/dev/mapper/$(basename "$_dev")"
            fi
            [ -b "$_dev" ] || continue
            lsblk -sno NAME,TYPE "$_dev" 2>/dev/null | awk '$2 == "disk" {print $1}'
        done | sort -u | tr '\n' ' '
    )
    echo "$_protected"
}

# 取根文件系统所在的物理盘裸名；识别不出来时输出空串，由调用方决定如何处理。
function get_root_disk() {
    local _root_dev
    _root_dev=$(findmnt -no SOURCE / 2>/dev/null)
    if [ -z "${_root_dev}" ]; then
        _root_dev=/dev/$(lsblk -rno NAME,MOUNTPOINT 2>/dev/null | awk '$2 == "/" {print $1}' | head -n 1)
    fi
    if [ ! -b "${_root_dev}" ] && [ -b "/dev/mapper/$(basename "${_root_dev}")" ]; then
        _root_dev="/dev/mapper/$(basename "${_root_dev}")"
    fi
    lsblk -sno NAME,TYPE "${_root_dev}" 2>/dev/null | awk '$2 == "disk" {print $1}' | head -n 1
}

function check_free_disk() {
    local _need
    if [ -z "${CHECK_FREE_DISK_MIN}" ]; then
        _need=$(get_required_disk_num)
    else
        _need=${CHECK_FREE_DISK_MIN}
    fi
    disks=$(TEST_DISK "$@")
    read -r -a disk_list <<< "$(echo "$disks" | tr ' ' '\n' | grep -v '^nbd' | tr '\n' ' ')"

    # 双重防御：即便 TEST_DISK 选盘失效，也绝不把系统盘或非法盘名交给
    # 后续的 fdisk / mkfs / pvcreate / pvremove / wipefs / lvconvert。
    local _system_disks _root_disk _d
    _system_disks=$(get_system_disk)
    _root_disk=$(get_root_disk)
    if [ -n "${_root_disk}" ]; then
        # 根盘必须进保护集，避免“保护集算出来了但恰好漏掉根盘”这种极端情况
        case " ${_system_disks} " in
            *" ${_root_disk} "*) ;;
            *) _system_disks="${_system_disks} ${_root_disk}" ;;
        esac
    elif [ -z "${_system_disks}" ]; then
        # 挂载点、swap、根盘三条途径全部失败，说明完全无法判断哪块盘是系统盘，
        # 此时选盘结果不可信，宁可跳过用例也不能冒险写盘。
        LOG_ERROR "cannot identify the system disk, skip test disk selection to protect the OS."
        exit 255
    else
        LOG_WARN "root disk not identified, fall back to mounted/swap disks [${_system_disks}] for protection."
    fi
    for _d in "${disk_list[@]}"; do
        if [ -z "${_d}" ]; then
            continue
        fi
        if [ ! -b "/dev/${_d}" ]; then
            LOG_ERROR "obtained test disk [${_d}] is not a block device, abort to protect the OS."
            exit 255
        fi
        case " ${_system_disks} " in
            *" ${_d} "*)
                LOG_ERROR "refuse to use system disk [${_d}] as test disk, abort to protect the OS."
                exit 255
                ;;
        esac
    done
    if [ "${#disk_list[@]}" -lt "${_need}" ]; then
        LOG_ERROR "need at least ${_need} free test disk(s) but got ${#disk_list[@]} [${disk_list[*]-}], abort to protect the OS."
        exit 255
    fi

    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]-}
    local_disk2=${disk_list[2]-}
    local_disk3=${disk_list[3]-}
}

check_free_disk "$@"