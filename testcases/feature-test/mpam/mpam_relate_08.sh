#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# 挂载根分组，创建资源组后关联多个不连续的vcpu

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1

    cpu="1-3,5,10-15"
    cpu_last=$(($ENV_CPU_NUM-1))
    cpu_rest="0,4,6-9,16-$cpu_last"

    echo $cpu > $mpam_dir/p1/cpus_list
    grep -wq $cpu $mpam_dir/p1/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组关联多个不连续cpu成功"
    else
        tst_res TFAIL "资源组关联多个不连续cpu失败"
    fi
    grep -wq $cpu_rest $mpam_dir/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "多个不连续cpu从根分组移除成功"
    else
        tst_res TFAIL "多个不连续cpu从根分组移除失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit