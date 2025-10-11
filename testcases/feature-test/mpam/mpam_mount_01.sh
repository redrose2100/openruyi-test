#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/08/30
# 挂载resctrl文件系统

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir
    if [ $? -eq 0 ]; then
        tst_res TPASS "挂载resctrl文件系统成功"
    else
        tst_res TFAIL "挂载resctrl文件系统失败"
    fi
    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit