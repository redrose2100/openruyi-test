#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# 配置一个域的L2 cache配置，并关联绑定cpu运行业务的vcpu

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir -o l2

    mkdir $mpam_dir/p1

    echo "L2:${ENV_L2_ID[0]}=1" > $mpam_dir/p1/schemata
    grep -w L2 $mpam_dir/p1/schemata | grep -q "${ENV_L2_ID[0]}=`printf "%05x" 1`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "L2cache配置成功"
    else
        tst_res TFAIL "L2cache配置失败"
    fi

    cpu=1
    echo $cpu > $mpam_dir/p1/cpus_list

    grep -wq $cpu $mpam_dir/p1/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "关联cpu成功"
    else
        tst_res TFAIL "关联cpu失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit