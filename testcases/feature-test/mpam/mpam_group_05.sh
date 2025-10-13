#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/02
# 可创建最大资源组个数测试

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    res_group_num=`cat $mpam_dir/info/L3/num_closids`

    create_group_num=$(($res_group_num-1)) # 根分组占据一个closeid

    for i in $(seq 1 $create_group_num); do
        mkdir $mpam_dir/p$i
        if [ $? -ne 0 ]; then
            tst_res TFAIL "创建资源组到最大数量失败"
            tst_check_dmesg
            tst_exit
        fi
    done

    tst_res TPASS "创建资源组到最大数量成功"

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit