#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# resctrl及资源组下，schemata配置一个域的L2cpd值超过最大值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o l2,cdp

    mkdir $mpam_dir/p1

    echo "L2CODE:${ENV_L2_ID[0]}=ffff" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "L2CODE非法值配置成功"
    else
        tst_res TPASS "L2CODE非法值配置失败"
    fi

    echo "L2DATA:${ENV_L2_ID[0]}=fffff" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TFAIL "L2DATA非法值配置成功"
    else
        tst_res TPASS "L2DATA非法值配置失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit