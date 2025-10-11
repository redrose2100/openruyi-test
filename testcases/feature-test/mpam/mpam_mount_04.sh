#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/08/30
# 解除挂载自定义分组文件系统

. mpam_lib.sh
tst_begin_test

self_dir="/home/mpam_test_dir"

fn_main(){
    mkdir -p $self_dir
    mount -t resctrl resctrl $self_dir
    if [ $? -eq 0 ]; then
        tst_res TPASS "自定义目录挂载resctrl文件系统成功"
    else
        tst_res TFAIL "自定义目录挂载resctrl文件系统失败"
    fi
    umount $self_dir
    if [ $? -eq 0 ]; then
        tst_res TPASS "自定义目录卸载resctrl文件系统成功"
    else
        tst_res TFAIL "自定义目录卸载resctrl文件系统失败"
    fi
}

fn_main

tst_check_dmesg
tst_exit