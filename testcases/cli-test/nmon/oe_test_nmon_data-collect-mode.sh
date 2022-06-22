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
    DNF_INSTALL "nmon ncurses-devel"
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
    # option -f
    nmon -f
    CHECK_RESULT $? 0 0 "Failed option: -f"
    rm *.nmon
    # option -F
    nmon -F example.nmon
    test -f example.nmon
    CHECK_RESULT $? 0 0 "Failed option: -F"
    rm example.nmon
    # option -a
    ./nmon_openEuler -fa
    SLEEP_WAIT 2
    grep 'GPU' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -a"
    rm *.nmon
    # option -c
    nmon -f -c 1
    grep 'snapshots,1' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -c"
    rm *.nmon
    # option -d
    nmon -f -d 512
    grep 'max_disks,512' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -d"
    rm *.nmon
    # option -D
    nmon -f -g auto -D
    SLEEP_WAIT 1
    grep -E 'SERV|WAIT' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -D"
    grep 'DGINFLIGHT' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -D"
    rm *.nmon
    # option -g auto
    nmon -f -g auto
    SLEEP_WAIT 2
    grep 'DG' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -g auto"
    grep 'BBBG' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -g auto"
    rm *.nmon auto
    # option -g
    echo "userDefineDisk $(lsblk -l | grep disk | awk '{print $1}')" >/tmp/uddg
    nmon -f -g /tmp/uddg
    SLEEP_WAIT 2
    grep 'DG' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -g"
    grep 'BBBG' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -g"
    grep 'userDefineDisk' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -g"
    rm *.nmon
    # option -h
    nmon -h 2>&1 | grep "Options"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    # option -J
    nmon -fJ
    grep 'JFS' *.nmon
    CHECK_RESULT $? 0 1 "Failed option: -J"
    rm *.nmon
    # option -l
    nmon -f -l 200
    grep 'disks_per_line,200' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -l"
    rm *.nmon
    # option -m
    nmon -f -m /tmp/
    test -f /tmp/*.nmon
    CHECK_RESULT $? 0 0 "Failed option: -m"
    rm /tmp/*.nmon
    # option -M
    nmon -fM
    grep 'MHZ' *.nmon
    SLEEP_WAIT 2
    CHECK_RESULT $? 0 0 "Failed option: -M"
    rm *.nmon
    # option -N
    nmon -fN
    SLEEP_WAIT 2
    grep 'NFSSVRV2' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -N"
    grep 'NFSSVRV3' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -N"
    grep 'NFSSVRV4' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -N"
    rm *.nmon
    # option -p
    nmon -fp >/tmp/nmonPID
    nmon_pid=$(cat /tmp/nmonPID)
    CHECK_RESULT $nmon_pid $(pgrep -f "nmon -fp") 0 "Failed option: -p"
    rm /tmp/nmonPID *.nmon
    # option -r
    nmon -f -r exampleRunname
    grep 'runname,exampleRunname' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -r"
    rm *.nmon
    # option -R
    nmon -fR
    SLEEP_WAIT 3
    grep 'rrdtool' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -R"
    rm *.nmon
    # option -s
    nmon -f -s 5
    grep 'interval,5' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -s"
    rm *.nmon
    # option -t
    nmon -ft
    SLEEP_WAIT 2
    grep 'TOP' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -t"
    rm *.nmon
    # option -T
    nmon -fT -c 5 -s 1
    SLEEP_WAIT 5
    grep 'UARG' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -T"
    rm *.nmon
    # option -U
    nmon -fU
    SLEEP_WAIT 2
    grep 'CPUUTIL' *.nmon
    CHECK_RESULT $? 0 0 "Failed option: -U"
    rm *.nmon
    # option -V
    nmon -V 2>&1 | grep 'version'
    CHECK_RESULT $? 0 0 "Failed option: -V"
    # option -?
    nmon -? 2>&1 | grep "Options"
    CHECK_RESULT $? 0 0 "Failed option: -?"
    SLEEP_WAIT 2
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start restore the test environment."
    rm -rf nmon_openEuler nmon*.src.rpm *.nmon /tmp/uddg auto ~/rpmbuild/ /tmp/libnvidia-ml /lib64/libnvidia-ml*
    systemctl stop nfs-server
    kill -USR2 $(pgrep -w nmon) $(pgrep nmon_openEuler)
    DNF_REMOVE "nmon ncurses-devel"
    rpm -e --nodeps libnvidia-ml
    LOG_INFO "End to restore the test environment."
}

main "$@"


