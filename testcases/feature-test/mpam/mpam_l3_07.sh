#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/05
# 配置多个域的l3 cache配置，并关联绑定cpu运行业务的vcpu

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    echo "L3:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=ff" > $mpam_dir/schemata
    grep -w L3 $mpam_dir/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0xff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组L3配置成功"
    else
        tst_res TFAIL "根分组L3配置失败"
    fi
    echo "L3:${ENV_L3_ID[0]}=1f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/schemata
    grep -w L3 $mpam_dir/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0x1f`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组L3修改配置成功"
    else
        tst_res TFAIL "根分组L3修改配置失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3:${ENV_L3_ID[0]}=f;${ENV_L3_ID[1]}=ff" > $mpam_dir/p1/schemata
    grep -w L3 $mpam_dir/p1/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0xf`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0xff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组L3配置成功"
    else
        tst_res TFAIL "资源组L3配置失败"
    fi
    echo "L3:${ENV_L3_ID[0]}=1f;${ENV_L3_ID[1]}=1ff" > $mpam_dir/p1/schemata
    grep -w L3 $mpam_dir/p1/schemata | grep "${ENV_L3_ID[0]}=`printf "%05x" 0x1f`" | grep -q "${ENV_L3_ID[1]}=`printf "%05x" 0x1ff`"
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组L3修改配置成功"
    else
        tst_res TFAIL "资源组L3修改配置失败"
    fi

    cpu="1"
    echo $cpu > $mpam_dir/p1/cpus_list
    grep -wq $cpu $mpam_dir/p1/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "配置L3后关联cpu成功"
    else
        tst_res TFAIL "配置L3后关联cpu失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit