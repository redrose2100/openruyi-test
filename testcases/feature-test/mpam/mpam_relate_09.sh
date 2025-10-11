#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# 资源组关联cpu后，cpu下线再上线测试

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1

    cpu="1"
    cpu_last=$(($ENV_CPU_NUM-1))
    cpu_rest="0,2-$cpu_last"
    cpu_full="0-$cpu_last"

    echo $cpu > $mpam_dir/p1/cpus_list
    grep -wq $cpu $mpam_dir/p1/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组关联cpu成功"
    else
        tst_res TFAIL "资源组关联cpu失败"
    fi
    grep -wq $cpu_rest $mpam_dir/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "cpu从根分组移除成功"
    else
        tst_res TFAIL "cpu从根分组移除失败"
    fi

    echo 0 > /sys/devices/system/cpu/cpu$cpu/online
    tst_res TINFO "cpu$cpu 下线"
    grep -wq $cpu $mpam_dir/p1/cpus_list
    if [ $? -ne 0 ]; then
        tst_res TPASS "cpu从资源组移除成功"
    else
        tst_res TFAIL "cpu从资源组移除失败"
    fi

    echo 1 > /sys/devices/system/cpu/cpu$cpu/online
    tst_res TINFO "cpu$cpu 上线"
    grep -wq $cpu_full $mpam_dir/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "cpu上线后使能到根分组"
    else
        tst_res TFAIL "cpu上线后未使能到根分组"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit