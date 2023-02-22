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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    
    DNF_INSTALL libguestfs
    touch file.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."




    guestfish -h ｜ grep '命令'
    guestfish -h cat ｜ grep 'cat'
    guestfish --csh -a 4.img -i cat /etc/group
    guestfish -c test:///default -a 4.img -i cat /etc/group
    guestfish  -d vm4 -i cat /etc/group
    guestfish --echo-keys -a 4.img -i cat /etc/group
    echo "--help" > file.txt
    guestfish -f file.txt -a 4.img -i cat /etc/group
    guestfish --format=qcow2 -a 4.img -i cat /etc/group
    guestfish --help
    guestfish --key ID:key:KEY_STRING -a 4.img -i cat /etc/group
    guestfish --keys-from-stdin -a 4.img -i cat /etc/group
    guestfish --listen
    guestfish -N fs:ext4
    guestfish -n -a 4.img -i cat /etc/group

    guestfish --no-dest-paths -a 4.img -i cat /etc/group
    guestfish --pipe-error -a 4.img -i cat /etc/group
    guestfish --progress-bars -a 4.img -i cat /etc/group
    guestfish --no-progress-bars -a 4.img -i cat /etc/group
    guestfish --selinux -a 4.img -i cat /etc/group


    guestfish --ro -a 4.img -i cat /etc/group

    guestfish -v -a 4.img -i cat /etc/group


    guestfish -V 2>&1 | grep $(rpm  -q libguestfs --queryformat '%{version}\n')
    guestfish --rw -a 4.img -i cat /etc/group
    guestfish -x -a 4.img -i cat /etc/group




    guestfish -h 2>&1 | grep 'help'
    CHECK_RESULT $? 0 0 "Check guestfish -h failed"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf file*
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
