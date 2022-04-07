#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#	 http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

####################################
# @Author : wuzhihao
# @email : zhihao@isrc.iscas.ac.cn
# @Date : 2022-02-28
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc : Dump examines files on an ext2/3 filesystem and determines which files need to be backed up.
#These files are copied to the given disk, tape or other storage medium for safe keeping (see the -f option below for doing remote backups).
# A dump that is larger than the output medium is broken into multiple volumes.
#On most media the size is determined by writing until an end-of-media indication is returned.
#####################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL dump
    test -d /tmp/dtest || mkdir -p /tmp/dtest/
    test -f /root/testDump || touch /root/testDump
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    dump -0uj -f /tmp/dtest/boot.bak.bz2 /boot/
    test -f /tmp/dtest/boot.bak.bz2
    CHECK_RESULT $? 0 0 "Failed to dump file."
    dump -0uj -f /tmp/dtest/testAfile /boot
    test -f /tmp/dtest/testAfile
    CHECK_RESULT $? 0 0 "Failed to specified archive_file to be used."
    dump -W 2>&1 | grep "Last dump"
    CHECK_RESULT $? 0 0 "Failed to print out, for all file systems in /etc/dumpdate."
    dump -0uj -B126880 -b20 -f /tmp/dtest/boot.bak.bz3 /boot/
    test -f /tmp/dtest/boot.bak.bz3
    CHECK_RESULT $? 0 0 "Failed to allocate disks."
    dump -0uj -a -f /tmp/dtest/boot.bak.bz4 /boot/ -u
    test -f /tmp/dtest/boot.bak.bz4
    CHECK_RESULT $? 0 0 "Failed to  stands for ‘auto-size’."
    dump -0uj -f -z /boot
    CHECK_RESULT $? 0 0 "Failed to compresses every block to be written on to the tape using the zlib library."
    if [[ !"$(dump -S /dev/)" =~ ^|0-9|+$ ]]; then
        LOG_ERROR "Failed to estimated number of bytes the dump will take."
    fi
    expect <<EOF
        spawn dump -0uj -d 1200 -D /tmp/testDumpdates -f /tmp/dtest/boot.bak.bz8 /boot/
        expect {
        "("yes" or "no")"
}
        send "yes\r"
        expect eof
EOF
    test -f /tmp/dtest/boot.bak.bz8
    CHECK_RESULT $? 0 0 "Failed to dump files in turn."
    dump -0y -f /tmp/dtest/boot.bak.bz5 /root/testDump
    test -f /tmp/dtest/boot.bak.bz5
    CHECK_RESULT $? 0 0 "Failed to dump files using the lzo library."
    dump -0y -0800 -f /tmp/dtest/boot.bak.bz6 /boot/
    test -f /tmp/dtest/boot.bak.bz6
    CHECK_RESULT $? 0 0 "Failed to use the specified date as the starting time for the dump."
    dump -0uj -e 1703936 -f /tmp/dtest/boot.bak.bz7 /boot/
    test -f /tmp/dtest/boot.bak.bz7
    CHECK_RESULT $? 0 0 "Failed to exclude inodes from the dump."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/dtest /root/testDump /tmp/testDumpdates
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
