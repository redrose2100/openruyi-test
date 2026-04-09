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
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/08/25
# @License   :   Mulan PSL v2
# @Desc      :   gazelle 加载 hello world 测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "libconfig dpdk numactl libboundscheck libpcap gazelle pciutils net-tools gcc"

    cp /etc/gazelle/lstack.conf /etc/gazelle/lstack.conf.bak

    if [ "$(systemd-detect-virt)" = "qemu" ]; then
        test_nic="eth1"
    else
        test_nic=$(TEST_NIC 1)
    fi
    test_nic_mac=$(cat /sys/class/net/"$test_nic"/address)
    test_nic_drv=$(dpdk-devbind -s | grep " if=$test_nic " | awk -F 'drv=' '{print $2}' | awk '{print $1}')
    test_nic_bus=$(dpdk-devbind -s | grep " if=$test_nic " | awk '{print $1}')

    ifconfig "$test_nic" down
    modprobe igb_uio
    dpdk-devbind -b igb_uio "$test_nic_bus"

    sed -i "s#devices=\"aa:bb:cc:dd:ee:ff\"#devices=\"$test_nic_mac\"#" /etc/gazelle/lstack.conf
    sed -i 's|"2048,0,0,0"|"2048"|' /etc/gazelle/lstack.conf
    sed -i 's|num_cpus="2"|num_cpus="0"|' /etc/gazelle/lstack.conf

    umount /mnt/hugepages-lstack
    echo 1024 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
    mkdir -p /mnt/hugepages-lstack
    chmod -R 700 /mnt/hugepages-lstack
    mount -t hugetlbfs nodev /mnt/hugepages-lstack -o pagesize=2M

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    cat >./hello.c <<EOF
#include <stdio.h>
int main()
{
    printf("Hello World!\n");
    return 0;
}
EOF
    gcc ./hello.c -o hello
    CHECK_RESULT $? 0 0 "gcc hello.c -o hello failed"

    GAZELLE_BIND_PROCNAME=hello LD_PRELOAD=/usr/lib64/liblstack.so ./hello 2>&1 | grep "gazelle_network_init success"
    CHECK_RESULT $? 0 0 "run hello failed"

    cp /etc/gazelle/lstack.conf ./lstack.conf
    LSTACK_CONF_PATH=./lstack.conf GAZELLE_BIND_PROCNAME=hello LD_PRELOAD=/usr/lib64/liblstack.so ./hello 2>&1 | grep "gazelle_network_init success"
    CHECK_RESULT $? 0 0 "test LSTACK_CONF_PATH failed"

    GAZELLE_BIND_PROCNAME=hello1 LD_PRELOAD=/usr/lib64/liblstack.so ./hello 2>&1 | grep "gazelle_network_init success"
    CHECK_RESULT $? 1 0 "run hello success"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."

    dpdk-devbind -b "$test_nic_drv" "$test_nic_bus"
    SLEEP_WAIT 10
    mv /etc/gazelle/lstack.conf.bak /etc/gazelle/lstack.conf
    umount /mnt/hugepages-lstack
    rm hello hello.c lstack.conf

    DNF_REMOVE "$@"

    LOG_INFO "Finish environment cleanup!"
}

main "$@"
