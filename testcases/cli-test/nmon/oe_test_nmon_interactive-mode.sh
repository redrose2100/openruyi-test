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
#@Author    	:   zhangjujie2
#@Contact   	:
#@Date      	:
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test for nmon
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "nmon ncurses-devel sysstat openeuler-lsb"
    systemctl start nfs-server
    git clone https://gitee.com/zhangjujie2/openeuler_libnvidia-ml.so.git "/tmp/libnvidia-ml"
    rpm -i /tmp/libnvidia-ml/RPMS/x86_64/libnvidia-ml-470.74-openEuler.x86_64.rpm
    mv /lib64/libnvidia-ml.so.470.74 /lib64/libnvidia-ml.so
    ldconfig
    yumdownloader --source nmon
    rpm -ivh ./nmon*.src.rpm
    gcc -o nmon_openEuler ~/rpmbuild/SOURCES/lmon*.c -g -Wall -D JFS -D GETUSER -D LARGEMEM -lncurses -lm -g -D X86 -lnvidia-ml -D NVIDIA_GPU
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    # option -b
    expect <<EOF
    spawn nmon -b
    send "q"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed option: -b"
    # option -c
    expect <<EOF
    spawn nmon -c5
    send "q"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed option: -c"
    # option -s
    expect <<EOF
    spawn nmon -s3
    expect "3secs" {
        exec touch ./interactive_-s
}
    send "q"
    expect eof
EOF
    test -f ./interactive_-s
    CHECK_RESULT $? 0 0 "Failed option: -s"
    # option a
    expect <<EOF
    spawn ./nmon_openEuler
    send "a\r"
    expect "NVIDIA GPU Accelerator" {
        exec touch ./interactive_a
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_a
    CHECK_RESULT $? 0 0 "Failed option: a"
    # option b
    expect <<EOF
    spawn nmon
    send "b\r"
    send "q"
    expect eof
EOF
    CHECK_RESULT $? 0 0 "Failed option: -b"
    # option c
    expect <<EOF
    spawn nmon
    send "c\r"
    expect "CPU Utilisation" {
        exec touch ./interactive_c
}
    send "q"
    expect eof
EOF
    test -f ./interactive_c
    CHECK_RESULT $? 0 0 "Failed option: c"
    # option C
    expect <<EOF
    spawn nmon
    send "C\r"
    expect "CPU Utilisation Wide View" {
        exec touch ./interactive_C
}
    send "q"
    expect eof
EOF
    test -f ./interactive_C
    CHECK_RESULT $? 0 0 "Failed option: C"
    # option d
    expect <<EOF
    spawn nmon
    send "d\r"
    expect "Disk I/O" {
        exec touch ./interactive_d
}
    send "q"
    expect eof
EOF
    test -f ./interactive_d
    CHECK_RESULT $? 0 0 "Failed option: d"
    # option D
    expect <<EOF
    spawn nmon
    send "D\r"
    expect "Disk I/O" {
        exec touch ./interactive_D_1
    }
    expect "Xfers" {
        exec touch ./interactive_D_2
    }
    expect "Size" {
        exec touch ./interactive_D_3
    }
    expect "Peak%" {
        exec touch ./interactive_D_4
    }
    expect "Peak=R+W" {
        exec touch ./interactive_D_5
    }
    expect "InFlight" {
        exec touch ./interactive_D_6
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_D_1
    CHECK_RESULT $? 0 0 "Failed option: D"
    test -f ./interactive_D_2
    CHECK_RESULT $? 0 0 "Failed option: D"
    test -f ./interactive_D_3
    CHECK_RESULT $? 0 0 "Failed option: D"
    test -f ./interactive_D_4
    CHECK_RESULT $? 0 0 "Failed option: D"
    test -f ./interactive_D_5
    CHECK_RESULT $? 0 0 "Failed option: D"
    test -f ./interactive_D_6
    CHECK_RESULT $? 0 0 "Failed option: D"
    # option g
    echo "userDefinedDiskGroups $(lsblk -l | grep disk | awk '{print $1}')" >/tmp/uddg
    expect <<EOF
    spawn nmon -g /tmp/uddg
    send "g\r"
    expect -re "Disk Group I/O.*userDefinedDiskGroups" {
        exec touch ./interactive_g
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_g
    CHECK_RESULT $? 0 0 "Failed option: g"
    # option G
    disk=$(lsblk -l | grep 'disk' | awk '{print $1}')
    notdisk=$(iostat -d | grep -v "$disk" | grep -vE 'Linux|Device|^$' | awk '{print $1}' | sed ':t;N;s/\n/\|/;b t')
    expect <<EOF
    spawn nmon -g auto
    send "dG\r"
    expect "$disk" {
        exec touch ./interactive_G_1
    }
    expect -re "$notdisk" {
        exec touch ./interactive_G_2
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_G_1
    CHECK_RESULT $? 0 0 "Failed option: G"
    test -f ./interactive_G_2
    CHECK_RESULT $? 0 1 "Failed option: G"
    # option h
    expect <<EOF
    spawn nmon
    send "h\r"
    expect "HELP" {
        exec touch ./interactive_h
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_h
    CHECK_RESULT $? 0 0 "Failed option: h"
    # option j
    expect <<EOF
    spawn nmon
    send "j\r"
    expect -re "File Systems.*not a real filesystem" {
        exec touch ./interactive_j
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_j
    CHECK_RESULT $? 0 0 "Failed option: j"
    # option J
    expect <<EOF
    spawn nmon
    send "jJ\r"
    expect "File Systems" {
        exec touch ./interactive_J_1
    }
    expect "not a real filesystem" {
        exec touch ./interactive_J_2
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_J_1
    CHECK_RESULT $? 0 0 "Failed option: J"
    test -f ./interactive_J_2
    CHECK_RESULT $? 0 1 "Failed option: J"
    # option k
    expect <<EOF
    spawn nmon
    send "k\r"
    expect -re "Kernel and Load Average.*RunQueue.*Context.*Switch.*Forks" {
        exec touch ./interactive_k
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_k
    CHECK_RESULT $? 0 0 "Failed option: k"
    # option l
    expect <<EOF
    spawn nmon
    send "l\r"
    expect -re "CPU.*Long-Term" {
        exec touch ./interactive_l
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_l
    CHECK_RESULT $? 0 0 "Failed option: l"
    # option L
    expect <<EOF
    spawn nmon
    send "L\r"
    expect "Large (Huge) Page" {
        exec touch ./interactive_L
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_L
    CHECK_RESULT $? 0 0 "Failed option: L"
    # option m
    expect <<EOF
    spawn nmon
    send "m\r"
    expect "Memory and Swap" {
        exec touch ./interactive_m
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_m
    CHECK_RESULT $? 0 0 "Failed option: m"
    # option M
    expect <<EOF
    spawn nmon
    send "M\r"
    expect "CPU MHz per Core and Thread" {
        exec touch ./interactive_M
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_M
    CHECK_RESULT $? 0 0 "Failed option: M"
    # option n
    expect <<EOF
    spawn nmon
    send "n\r"
    expect -re "Network I/O.*Network Error Counters" {
        exec touch ./interactive_n
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_n
    CHECK_RESULT $? 0 0 "Failed option: n"
    # option N
    expect <<EOF
    spawn nmon
    send "N\r"
    expect "Network Filesystem (NFS) I/O Operations per second" {
        exec touch ./interactive_N
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_N
    CHECK_RESULT $? 0 0 "Failed option: N"
    # option o
    expect <<EOF
    spawn nmon
    send "o\r"
    expect "Disk %Busy Map" {
        exec touch ./interactive_o
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_o
    CHECK_RESULT $? 0 0 "Failed option: o"
    # option q
    expect <<EOF
    spawn nmon
    send "q\r"
    [exec sh -c {if ["$(ps -e | grep nmon)" = ""]; then
    touch ./interactive_q
    fi}]
    expect eof
EOF
    test -f ./interactive_q
    CHECK_RESULT $? 0 0 "Failed option: q"
    # option r
    expect <<EOF
    spawn nmon
    send "r\r"
    expect "Release  : $(uname -r)" {
        exec touch ./interactive_r_1
    }
    expect "Version  : $(uname -v)" {
        exec touch ./interactive_r_2
    }
    expect "Machine  : $(uname -m)" {
        exec touch ./interactive_r_3
    }
    expect "Nodename : $(uname -n)" {
        exec touch ./interactive_r_4
    }
    set ease1 [exec sh -c {cat /etc/*ease | awk 'NR==1'}]
    expect "$ease1" {
        exec touch ./interactive_r_5
    }
    set ease2 [exec sh -c {cat /etc/*ease | awk 'NR==2'}]
    expect "$ease2" {
        exec touch ./interactive_r_6
    }
    set ease3 [exec sh -c {cat /etc/*ease | awk 'NR==3'}]
    expect "$ease3" {
        exec touch ./interactive_r_7
    }
    set ease4 [exec sh -c {cat /etc/*ease | awk 'NR==4'}]
    expect "$ease4" {
        exec touch ./interactive_r_8
    }
    set lsb_1 [exec sh -c {lsb_release -i}]
    expect "$lsb_1" {
        exec touch ./interactive_r_9
    }
    set lsb_2 [exec sh -c {lsb_release -d}]
    expect "$lsb_2" {
        exec touch ./interactive_r_10
    }
    set lsb_3 [exec sh -c {lsb_release -r}]
    expect "$lsb_3" {
        exec touch ./interactive_r_11
    }
    set lsb_4 [exec sh -c {lsb_release -c}]
    expect "$lsb_4" {
        exec touch ./interactive_r_12
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_r_1
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_2
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_3
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_4
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_5
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_6
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_7
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_8
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_9
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_10
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_11
    CHECK_RESULT $? 0 0 "Failed option: r"
    test -f ./interactive_r_12
    CHECK_RESULT $? 0 0 "Failed option: r"
    # option t
    expect <<EOF
    spawn nmon
    send "t\r"
    expect "Top Processes" {
        exec touch ./interactive_t
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_t
    CHECK_RESULT $? 0 0 "Failed option: t"
    # option T
    expect <<EOF
    spawn nmon
    send "T\r"
    expect -re "Top Processes.*Pgrp.*Nice.*Prior.*Status.*Proc-Flag" {
        exec touch ./interactive_T
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_T
    CHECK_RESULT $? 0 0 "Failed option: T"
    # option u
    expect <<EOF
    spawn nmon
    send "u\r"
    expect -re "Top Processes.*ResSize" {
        exec touch ./interactive_u
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_u
    CHECK_RESULT $? 0 0 "Failed option: u"
    # option U
    expect <<EOF
    spawn nmon
    send "U\r"
    expect "CPU Utilisation Stats" {
        exec touch ./interactive_U
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_U
    CHECK_RESULT $? 0 0 "Failed option: U"
    # option v
    expect <<EOF
    spawn nmon
    send "v\r"
    expect "Verbose Mode" {
        exec touch ./interactive_v
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_v
    CHECK_RESULT $? 0 0 "Failed option: v"
    # option V
    expect <<EOF
    spawn nmon
    send "V\r"
    expect "Virtual Memory" {
        exec touch ./interactive_V
    }
    send "q"
    expect eof
EOF
    test -f ./interactive_V
    CHECK_RESULT $? 0 0 "Failed option: V"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start restore the test environment."
    rm -rf ./interactive_* /tmp/uddg auto /lib64/libnvidia-ml* /tmp/libnvidia-ml nmon_openEuler nmon*.src.rpm
    systemctl stop nfs-server
    DNF_REMOVE "nmon ncurses-devel sysstat openeuler-lsb"
    rpm -e --nodeps libnvidia-ml
    LOG_INFO "End to restore the test environment."
}

main "$@"


