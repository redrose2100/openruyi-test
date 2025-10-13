#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/08/30
# 解除挂载拥有子资源组的resctrl文件系统

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir
    mkdir $mpam_dir/p0 $mpam_dir/p1 $mpam_dir/p2
    umount $mpam_dir
    if [ $? -eq 0 ]; then
        tst_res TPASS "卸载拥有子资源组的resctrl文件系统成功"
    else
        tst_res TFAIL "卸载拥有子资源组的resctrl文件系统失败"
    fi
}

fn_main

tst_check_dmesg
tst_exit