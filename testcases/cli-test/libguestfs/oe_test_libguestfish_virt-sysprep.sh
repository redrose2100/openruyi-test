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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."


virt-sysprep -a 22.img
virt-sysprep --append-line '/etc/hosts:10.0.0.1 foo' -d vm4
virt-sysprep -c test:///default -a 22.img
virt-sysprep --chmod 777:/etc/a.txt -d vm4
virt-sysprep --color -d vm4
virt-sysprep --commands-from-file a.txt -d vm4
virt-sysprep -a 22.img --copy /etc/a.txt:/opt
virt-sysprep -a 22.img --copy-in /opt/software/a.txt:/etc
virt-sysprep -d vm4
virt-sysprep -a 22.img --delete /etc/b.txt




virt-sysprep -n -d vm4
virt-sysprep --echo-keys -d vm4
virt-sysprep -a 22.img --edit /etc/a.txt:Str
virt-sysprep --enable ssh-hostkeys,udev-persistent-net -d vm4
virt-sysprep --firstboot-command cat -d vm4
virt-sysprep --firstboot-install PKG -d vm4
virt-sysprep --format qcow2 -a 22.img
virt-sysprep --help 2>&1 | grep 'virt-sysprep'
CHECK_RESULT $? 0 0 "Check virt-sysprep -help failed"
virt-sysprep --hostname 8899 -a 22.img



virt-sysprep --key ID:key:KEY_STRING -d vm4
virt-sysprep --keys-from-stdin -d vm4

virt-sysprep --list-operations -d vm4
virt-sysprep --mkdir /etc/dir -d vm4

virt-sysprep --mount-options /mnt -d vm4
virt-sysprep -a 22.img --move /etc/c.txt:/opt


virt-sysprep --no-logfile -d vm4
virt-sysprep --no-network -a 22.img
virt-sysprep --no-selinux-relabel -d vm4
virt-sysprep --operation ssh-hostkeys -d vm4
virt-sysprep --password root:password -d vm22
virt-sysprep --password-crypto md5 -d vm4
virt-sysprep -q -d vm4
virt-sysprep --root-password password -d vm22



virt-sysprep --run-command cat -d vm4
virt-sysprep --scriptdir /etc/tmp -d vm4
virt-sysprep --scrub /etc/a.txt -d vm4
virt-sysprep --selinux-relabel -d vm4



virt-sysprep --timezone Europe/London -d vm4
virt-sysprep --touch /etc/a.txt -d vm4
virt-sysprep --truncate /etc/a.txt -d vm4
virt-sysprep --truncate-recursive /etc/ -d vm4
    virt-sysprep -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-sysprep -V failed"
virt-sysprep -v -d vm4
virt-sysprep --write /etc/a.txt:"hello" -d vm4
virt-sysprep -x -d vm4










    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
