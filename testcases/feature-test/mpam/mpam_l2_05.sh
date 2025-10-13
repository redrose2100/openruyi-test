#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# resctrl及资源组下，schemata配置多个域的L2cpd为不同值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o l2,cdp

    mkdir $mpam_dir/p1

    echo "L2CODE:${ENV_L2_ID[0]}=f;${ENV_L2_ID[1]}=1f" > $mpam_dir/p1/schemata
    echo "L2DATA:${ENV_L2_ID[0]}=1f;${ENV_L2_ID[1]}=ff" > $mpam_dir/p1/schemata

    grep -w L2CODE $mpam_dir/p1/schemata | grep "${ENV_L2_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L2_ID[1]}=`printf "%05x" 0x1f`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "L2CODE配置成功"
    else
        tst_res TFAIL "L2CODE配置失败"
    fi
    grep -w L2DATA $mpam_dir/p1/schemata | grep "${ENV_L2_ID[0]}=`printf "%05x" 0x1f`" | grep -q "${ENV_L2_ID[1]}=`printf "%05x" 0xff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "L2DATA配置成功"
    else
        tst_res TFAIL "L2DATA配置失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit