#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
#	 http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
#See the Mulan PSL v2 for more details.

####################################
# @Author : wuzhihao
# @email : zhihao@isrc.iscas.ac.cn
# @Date : 2022-02-28
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc : The restore command performs the inverse function of dump
#A full backup of a file system may be restored and subsequent incremental backups layered on top of it.
#Single files and directory subtrees may be restored from full or partial backups.
#Restore works across a network; to do this see the -f flag described below.
#Other arguments to the command are file or directory names specifying the files that are to be restored.
#####################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL dump
    dump -0uj -f /tmp/boot.bak.bz2 /boot/
    test -f /boot/abc || touch /boot/abc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    restore -C -f /tmp/boot.bak.bz2 | grep "Some files were modified!"
    CHECK_RESULT $? 1 0 "Error! Added file detected."
    mv /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4668.img /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4669.img
    restore -C -f /tmp/boot.bak.bz2 | grep "Some files were modified!"
    CHECK_RESULT $? 0 0 "Failed to detecte revision files"
    mv /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4669.img /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4668.img
    restore -t -f /tmp/boot.bak.bz2 | grep "Dump   date:"
    CHECK_RESULT $? 0 0 "Failed to print backup profile informaintioin"
    mkdir /root/tmp.test
    cd /root/tmp.test/
    restore -r -f /tmp/boot.bak.bz2
    /n | restore -R -f /tmp/boot.bak.bz2
    count=$(ls /root/tmp.test | wc -w)
    if [ "$count" -eq "0" ]; then
        LOG_ERROR "Failed to restore backup files in this folder"
    fi
    restore -t -f /tmp/boot.bak.bz2 | grep "openEuler"
    CHECK_RESULT $? 0 0 "Failed to list files on the backup"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/abc /root/tmp.test /tmp/boot.bak.bz2
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
