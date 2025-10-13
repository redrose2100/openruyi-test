#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# resctrl及资源组下，schemata配置全部域的L3PRI为最大值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    echo "L3PRI:${ENV_L3_ID[0]}=3;${ENV_L3_ID[1]}=3" > $mpam_dir/schemata
    grep -w L3PRI $mpam_dir/schemata | grep "${ENV_L3_ID[0]}=`printf "%05d" 3`" | grep -q "${ENV_L3_ID[1]}=`printf "%05d" 3`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组配置多个域L3PRI最大值成功"
    else
        tst_res TFAIL "根分组配置多个域L3PRI最大值失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3PRI:${ENV_L3_ID[0]}=3;${ENV_L3_ID[1]}=3" > $mpam_dir/p1/schemata
    grep -w L3PRI $mpam_dir/p1/schemata | grep "${ENV_L3_ID[0]}=`printf "%05d" 3`" | grep -q "${ENV_L3_ID[1]}=`printf "%05d" 3`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组配置多个域L3PRI最大值成功"
    else
        tst_res TFAIL "资源组配置多个域L3PRI最大值失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit