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
# @Desc      :   gazelle 加速 redis-server 测试
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "libconfig dpdk numactl libboundscheck libpcap gazelle pciutils net-tools redis"

    cp /etc/gazelle/lstack.conf /etc/gazelle/lstack.conf.bak

#    test_nic=$(TEST_NIC 1)
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

    cp /etc/redis.conf ./redis.conf
    echo '#关闭保护模式
protected-mode no
#gazelle暂不支持此参数进行后台运行
daemonize no
#开启AOF持久化，redis单机测试可不配置
appendonly yes' >> ./redis.conf

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LD_PRELOAD=/usr/lib64/liblstack.so  GAZELLE_BIND_PROCNAME=redis-server redis-server redis.conf &

    SLEEP_WAIT 10
    redis-benchmark -h 127.0.0.1 -p 6379 -c 1000 -n 10000 -r 10000 -t set,get --threads 8
    CHECK_RESULT $? 0 0 "run redis-server failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."

    killall redis-server
    dpdk-devbind -b "$test_nic_drv" "$test_nic_bus"
    SLEEP_WAIT 10
    mv /etc/gazelle/lstack.conf.bak /etc/gazelle/lstack.conf
    umount /mnt/hugepages-lstack
    rm redis.conf

    DNF_REMOVE "$@"

    LOG_INFO "Finish environment cleanup!"
}

main "$@"
