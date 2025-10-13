#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# resctrl及资源组下，schemata配置一个域的L3cpd值超过最大值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o cdp

    echo "L3CODE:${ENV_L3_ID[0]}=fffff" > $mpam_dir/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "根分组配置超出范围的L3CODE成功"
    else
        tst_res TPASS "根分组配置超出范围的L3CODE失败"
    fi
    echo "L3DATA:${ENV_L3_ID[0]}=fffff" > $mpam_dir/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "根分组配置超出范围的L3DATA成功"
    else
        tst_res TPASS "根分组配置超出范围的L3DATA失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3CODE:${ENV_L3_ID[0]}=fffff" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "资源组配置超出范围的L3CODE成功"
    else
        tst_res TPASS "资源组配置超出范围的L3CODE失败"
    fi
    echo "L3DATA:${ENV_L3_ID[0]}=fffff" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "资源组配置超出范围的L3DATA成功"
    else
        tst_res TPASS "资源组配置超出范围的L3DATA失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit