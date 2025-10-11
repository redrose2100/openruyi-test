#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/08
# resctrl及资源组下，schemata配置MBMIN

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    for ((i=0; i<$ENV_NUMA_NUM; i++)); do
        for j in $(seq 0 100); do
            echo "MBMIN:$i=$j" > $mpam_dir/schemata
            grep -w MBMIN $mpam_dir/schemata | grep -q "$i=`printf "%05d" $j`"
            if [ $? -eq 0 ]; then
                tst_res TPASS "根分组 MBMIN numa $i 配置为$j 成功"
            else
                tst_res TFAIL "根分组 MBMIN numa $i 配置为$j 失败"
            fi
        done
    done

    mkdir $mpam_dir/p1

    for ((i=0; i<$ENV_NUMA_NUM; i++)); do
        for j in $(seq 0 100); do
            echo "MBMIN:$i=$j" > $mpam_dir/p1/schemata
            grep -w MBMIN $mpam_dir/p1/schemata | grep -q "$i=`printf "%05d" $j`"
            if [ $? -eq 0 ]; then
                tst_res TPASS "资源组 MBMIN numa $i 配置为$j 成功"
            else
                tst_res TFAIL "资源组 MBMIN numa $i 配置为$j 失败"
            fi
        done
    done

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit