#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# resctrl及资源组下，schemata配置L3MAX为60%

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    echo "L3MAX:${ENV_L3_ID[0]}=60" > $mpam_dir/schemata
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组L3MAX配置成功"
    else
        tst_res TFAIL "根分组L3MAX配置失败"
    fi

    mkdir $mpam_dir/p1
    echo "L3MAX:${ENV_L3_ID[0]}=60" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组L3MAX配置成功"
    else
        tst_res TFAIL "资源组L3MAX配置失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit