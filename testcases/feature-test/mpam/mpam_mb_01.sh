#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/08
# 资源组下，schemata配置内存带宽全部域 MBPRI为最小值0

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1

    for ((i=0; i<$ENV_NUMA_NUM; i++)); do
        echo "MBPRI:$i=0" > $mpam_dir/p1/schemata
        grep -w MBPRI $mpam_dir/p1/schemata | grep -q "$i=`printf "%05d" 0`"
        if [ $? -eq 0 ]; then
            tst_res TPASS "资源组 MBPRI numa $i 配置为最小值成功"
        else
            tst_res TFAIL "资源组 MBPRI numa $i 配置为最小值失败"
        fi
    done

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit