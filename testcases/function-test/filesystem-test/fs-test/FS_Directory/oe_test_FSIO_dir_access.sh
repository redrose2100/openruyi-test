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
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of directory on rootfs
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    cur_date=$(date +%Y%m%d%H%M%S)
    admin="admin"$cur_date
    normal="normal"$cur_date
    useradd "$admin"
    echo "$admin" | passwd --stdin "$admin"
    cp /etc/sudoers /etc/sudoers.bak
    echo "$admin ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
    useradd "$normal"
    echo "$normal" | passwd --stdin "$normal"
    cd /
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    dir1=('dev' 'etc' 'home' 'media' 'mnt' 'opt' 'run' 'srv' 'usr' 'var')
    for i in $(seq 0 $((${#dir1[@]} - 1))); do
        [[ "$(stat -c "%A" "${dir1[$i]}")" == "drwxr-xr-x" ]]
        CHECK_RESULT $? 0 0 "The access of /${dir1[$i]} is false."
    done
    dir2=('bin' 'lib' 'lib64' 'sbin')
    for i in $(seq 0 $((${#dir2[@]} - 1))); do
        [[ "$(stat -c "%A" "${dir2[$i]}")" == "lrwxrwxrwx" ]]
        CHECK_RESULT $? 0 0 "The access of /${dir2[$i]} is false."
    done

    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        [[ "$(stat -c "%A" boot)" == "drwxr-xr-x" ]]
    else
        [[ "$(stat -c "%A" boot)" == "dr-xr-xr-x" ]]
    fi
    CHECK_RESULT $? 0 0 "The access of /boot is false."
    [[ "$(stat -c "%A" proc)" == "dr-xr-xr-x" ]]
    CHECK_RESULT $? 0 0 "The access of /proc is false."
    [[ "$(stat -c "%A" sys)" == "dr-xr-xr-x" ]]
    CHECK_RESULT $? 0 0 "The access of /sys is false."
    [[ "$(stat -c "%A" root)" == "dr-xr-x---" ]]
    CHECK_RESULT $? 0 0 "The access of /root is false."
    find /boot -maxdepth 1 -name '*init*'
    CHECK_RESULT $? 0 0 "root doesn't have access of /boot directory."
    ls -l /root
    CHECK_RESULT $? 0 0 "root doesn't have access of /root directory."
    su "$admin" -c "sudo ls -l /boot" | grep -q init
    CHECK_RESULT $? 0 0 "admin doesn't have access of /boot directory."
    su "$admin" -c "sudo ls -l /root"
    CHECK_RESULT $? 0 0 "admin doesn't have access of /root directory."
    su "$normal" -c "ls -l /boot" | grep -q init
    CHECK_RESULT $? 0 0 "normal user doesn't have access of /boot directory."
    su "$normal" -c "ls -l /root" | grep -q init
    CHECK_RESULT $? 1 0 "normal user has unexpect access of /root directory."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    userdel -r "$admin"
    userdel -r "$normal"
    rm -rf /etc/sudoers
    mv /etc/sudoers.bak /etc/sudoers
    LOG_INFO "End to restore the test environment."
}

main "$@"

