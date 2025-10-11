#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# 配置一个域的L2 cache配置，并关联pid

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o l2

    mkdir $mpam_dir/p1

    echo "L2:${ENV_L2_ID[0]}=1" > $mpam_dir/p1/schemata
    grep -w L2 $mpam_dir/p1/schemata | grep -q "${ENV_L2_ID[0]}=`printf "%05x" 1`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "L2cache配置成功"
    else
        tst_res TFAIL "L2cache配置失败"
    fi

    sleep 100 &
    pid=$!

    echo $pid > $mpam_dir/p1/tasks
    grep -wq $pid $mpam_dir/p1/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "关联pid成功"
    else
        tst_res TFAIL "关联pid失败"
    fi

    kill -9 $pid

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit