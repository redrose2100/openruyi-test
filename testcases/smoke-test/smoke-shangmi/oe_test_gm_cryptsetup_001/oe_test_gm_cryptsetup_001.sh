#!/usr/bin/bash

#@ License : Mulan PSL v2
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   cryptsetup sm test
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    dd if=/dev/zero of=img1 bs=10M count=10
    losetup /dev/loop5 img1
    dd if=/dev/zero of=img2 bs=10M count=10
    losetup /dev/loop6 img2
    mkdir /home/{encrypted1,encrypted2}
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "$NODE1_FRAME" == "ppc64le" ];then
        cipher="aes-xts-plain64"
    else
        cipher="sm4-xts-plain64"
    fi

    echo "Huawei12#$
Huawei12#$
" | cryptsetup -c $cipher --key-size=256 --hash sm3 luksFormat /dev/loop5
    CHECK_RESULT $? 0 0 "luks2 model failed"

    echo "Huawei12#$
" | cryptsetup luksOpen /dev/loop5 luksdisk
    CHECK_RESULT $? 0 0 "open dev failed"

    mkfs.ext4 /dev/mapper/luksdisk
    CHECK_RESULT $? 0 0 "format failed"

    mount /dev/mapper/luksdisk /home/encrypted1
    CHECK_RESULT $? 0 0 "mount failed"

    dd if=/dev/urandom of=/home/encrypted1/tmp bs=4k count=4096
    CHECK_RESULT $? 0 0 "io write failed"

    echo "Huawei12#$
Huawei12#$
" | cryptsetup plainOpen -c $cipher --key-size=256 --hash sm3 /dev/loop6 plaindisk
    CHECK_RESULT $? 0 0 "plain model failed"

    mkfs.ext4 /dev/mapper/plaindisk
    CHECK_RESULT $? 0 0 "format failed"

    mount /dev/mapper/plaindisk /home/encrypted2
    CHECK_RESULT $? 0 0 "mount failed"

    dd if=/dev/urandom of=/home/encrypted2/tmp bs=4k count=4096
    CHECK_RESULT $? 0 0 "io write failed"

    LOG_INFO "End of the test."
}

function post_test() {
    umount /dev/mapper/luksdisk
    cryptsetup luksClose luksdisk

    umount /dev/mapper/plaindisk
    cryptsetup plainClose plaindisk
   
    losetup -d /dev/loop5
    losetup -d /dev/loop6
    rm -rf img1 img2 /home/{encrypted1,encrypted2}
}

main "$@"

