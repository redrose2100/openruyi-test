#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/01
# 创建多个监控组并删除

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/mon_groups/m1 $mpam_dir/mon_groups/m2 $mpam_dir/mon_groups/m3
    if [ $? -eq 0 ]; then
        tst_res TPASS "创建多个监控组成功"
    else
        tst_res TFAIL "创建多个监控组失败"
    fi

    rmdir $mpam_dir/mon_groups/m1 $mpam_dir/mon_groups/m2 $mpam_dir/mon_groups/m3
    if [ $? -eq 0 ]; then
        tst_res TPASS "删除多个监控组成功"
    else
        tst_res TFAIL "删除多个监控组失败"
    fi
    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit