#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# 创建单个资源组关联pid后，删除资源组

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p0
    sleep 100 &
    pid=$!

    echo $pid > $mpam_dir/p0/tasks

    rmdir $mpam_dir/p0
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组删除成功"
    else
        tst_res TFAIL "资源组删除删除"
    fi

    grep -wq $pid $mpam_dir/tasks
    if [ $? -eq 0 ]; then
        tst_res TPASS "进程创建后pid显示在根分组内"
    else
        tst_res TFAIL "进程创建后pid未显示在根分组内"
    fi

    kill -9 $pid

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit