#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2. 
# You can use it according to the terms and conditions of the Mulan PSL v2. 
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fanghongsong
# @Contact   :   fanghongsong4@h-partners.com
# @Date      :   2023.06.30
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="360m"
    DNF_INSTALL "zlib gcc-c++ m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel hwloc-devel kernel-headers glibc-headers elfutils-libelf-devel patch numactl tar automake cmake time psmisc vim git make"
    echo set number >> /root/.vimrc
    echo 'export LANG=en_US.UTF-8' >> /root/.bashrc
    source /root/.bashrc
    hostnamectl set-hostname localhost
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /opt
    until [ -e "ltp" ]
    do
        git clone -b 20220121 https://github.com/linux-test-project/ltp.git
    done
    cd ltp 
    make autotools
    ./configure
    make -j16
    make install
    
    cat /etc/openEuler-latest |grep openeulerversion|grep "22.03"   
    if [ $? == 0 ];then
        # kernel 5.10 resolve proc01 testcase fail    
        echo 1024 > /proc/dirty/buffer_size
    fi
    # load etmem_swap.ko(swap_pages) and etmem_scan.ko(idle_pages)
    insmod /usr/lib/modules/`uname -r`/kernel/fs/proc/etmem_swap.ko*
    insmod /usr/lib/modules/`uname -r`/kernel/fs/proc/etmem_scan.ko*

    cd /opt/ltp
    ./runltp |tee ltp.log
    grep -nr "FAIL" /opt/ltp/results/|egrep -v "af_alg07|cpufreq_boost|proc01|ioctl_sg01|madvise06|cpuset_memory_spread|cve-2018-1000204"
    if [ $? == 0 ];then
        echo "any testcases fail"
        exit 1
    else
        echo "ltp testcases pass"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE $@
    LOG_INFO "End to restore the test environment."
}
main $@
