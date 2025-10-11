#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# 将一个域的l3 cache配置为 超过最大值的cache way

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    echo "L3:${ENV_L3_ID[0]}=ffffffff" > $mpam_dir/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "根分组配置超出范围的L3成功"
    else
        tst_res TPASS "根分组配置超出范围的L3失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3:${ENV_L3_ID[0]}=ffffffff" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "资源组配置超出范围的L3成功"
    else
        tst_res TPASS "资源组配置超出范围的L3失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit