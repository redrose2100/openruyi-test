#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-24
#@License   	:   Mulan PSL v2
#@Desc      	:   lvconvert snapshot
#####################################
# shellcheck disable=SC1090,SC2153

source "${OET_PATH}"/testcases/system-test/fs-test/common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL lvm2
    IFS=' ' read -ra fs_args <<<"$FS_TYPE"
    read -ra point_list <<<"$(CREATE_FS "${fs_args[@]}")"
    group_name=$(vgdisplay | grep "test_vggroup" | grep "VG Name" | tail -n 1 | awk '{print $3}')
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        echo "test write file" >"${var}"/test_file
        mkdir "${var}"/test_dir
    done
    mkdir /mnt/test_snap_dir
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        lv_name=$(df -iT | grep "$var" | awk '{print $1}')
        fs_type=$(df -iT | grep "$var" | awk '{print $2}')
        lvcreate -L 1G -n test_snap -s "${lv_name}"
        CHECK_RESULT $? 0 0 "Create snapshot failed."
        if [[ $fs_type == "xfs" ]]; then
            mount -o nouuid /dev/"${group_name}"/test_snap /mnt/test_snap_dir
        else
            mount /dev/"${group_name}"/test_snap /mnt/test_snap_dir
        fi
        CHECK_RESULT $? 0 0 "Mount snapshot failed."
        grep -q "test" /mnt/test_snap_dir/test_file
        CHECK_RESULT $? 0 0 "Check file in snapshot failed."
        test -d /mnt/test_snap_dir/test_dir
        CHECK_RESULT $? 0 0 "Check directory in snapshot failed."
        echo "add file" >/mnt/test_snap_dir/test_touch_ss
        umount /mnt/test_snap_dir
        umount "$var"
        lvconvert --merge /dev/"${group_name}"/test_snap
        CHECK_RESULT $? 0 0 "lvconvert snapshot failed."
        mount "$lv_name" "$var"
        grep -q "add" "${var}"/test_touch_ss
        CHECK_RESULT $? 0 0 "lvconvert snapshot failed."
        umount "$var"
        lvremove "$lv_name" -y
        lvremove /dev/"${group_name}"/test_snap -y
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    REMOVE_FS "${point_list[@]}"
    rm -rf /mnt/test_snap_dir
    REMOVE_VG "$@"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
