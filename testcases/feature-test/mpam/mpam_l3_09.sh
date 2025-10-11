#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# resctrl及资源组下，schemata配置其中一个域的L3PRI为最大值

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    for i in ${ENV_L3_ID[@]}; do
        echo "L3PRI:$i=3" > $mpam_dir/schemata
        grep -w L3PRI $mpam_dir/schemata | grep -q "$i=`printf "%05d" 3`"
        if [ $? -eq 0 ]; then
            tst_res TPASS "根分组配置 $i L3PRI最大值成功"
        else
            tst_res TFAIL "根分组配置 $i L3PRI最大值失败"
        fi
    done

    mkdir $mpam_dir/p1
    for i in ${ENV_L3_ID[@]}; do
        echo "L3PRI:$i=3" > $mpam_dir/p1/schemata
        grep -w L3PRI $mpam_dir/p1/schemata | grep -q "$i=`printf "%05d" 3`"
        if [ $? -eq 0 ]; then
            tst_res TPASS "资源组配置 $i L3PRI最大值成功"
        else
            tst_res TFAIL "资源组配置 $i L3PRI最大值失败"
        fi
    done

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit
