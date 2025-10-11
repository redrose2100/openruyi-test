#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# resctrl及资源组下，schemata配置多个域的L3cpd为不同值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o cdp

    echo "L3CODE:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/schemata
    grep -w L3CODE $mpam_dir/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组配置多个域L3CODE成功"
    else
        tst_res TFAIL "根分组配置多个域L3CODE失败"
    fi
    echo "L3DATA:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/schemata
    grep -w L3DATA $mpam_dir/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "组配置多个域L3DATA成功"
    else
        tst_res TFAIL "根分组配置多个域L3DATA失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3CODE:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/p1/schemata
    grep -w L3CODE $mpam_dir/p1/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组配置多个域L3CODE成功"
    else
        tst_res TFAIL "资源组配置多个域L3CODE失败"
    fi
    echo "L3DATA:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/p1/schemata
    grep -w L3DATA $mpam_dir/p1/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组配置多个域L3DATA成功"
    else
        tst_res TFAIL "资源组配置多个域L3DATA失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit