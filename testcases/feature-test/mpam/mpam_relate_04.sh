#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# 进程pid在监控组迁移测试

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1
    mkdir $mpam_dir/p1/mon_groups/m1 $mpam_dir/p1/mon_groups/m2

    sleep 100 &
    pid=$!

    echo $pid > $mpam_dir/p1/tasks

    echo $pid > $mpam_dir/p1/mon_groups/m1/tasks
    grep -wq $pid $mpam_dir/p1/mon_groups/m1/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "监控组关联进程pid成功"
    else
        tst_res TFAIL "监控组关联进程pid失败"
    fi

    echo $pid > $mpam_dir/p1/mon_groups/m2/tasks
    grep -wq $pid $mpam_dir/p1/mon_groups/m1/tasks
    if [ $? -ne 0 ]; then
        tst_res TPASS "进程迁移后pid在原监控组移除"
    else
        tst_res TFAIL "进程迁移后pid未在原监控组移除"
    fi
    grep -wq $pid $mpam_dir/p1/mon_groups/m2/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "进程pid迁移成功"
    else
        tst_res TFAIL "进程pid迁移失败"
    fi

    kill -9 $pid

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit