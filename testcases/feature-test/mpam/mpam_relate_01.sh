#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# 创建进程，挂载根分组，创建资源组后关联进程pid

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p0
    sleep 100 &
    pid=$!

    grep -wq $pid $mpam_dir/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "进程创建后pid显示在根分组内"
    else
        tst_res TFAIL "进程创建后pid未显示在根分组内"
    fi

    echo $pid > $mpam_dir/p0/tasks
    grep -wq $pid $mpam_dir/p0/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "进程pid关联资源组成功"
    else
        tst_res TFAIL "进程pid关联资源组失败"
    fi

    kill -9 $pid

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit
