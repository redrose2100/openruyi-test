#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# 资源组下，schemata配置L3MIN为50%

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1

    echo "L3MIN:${ENV_L3_ID[0]}=50" > $mpam_dir/p1/schemata
    if [ $? -eq 0 ]; then
        tst_res TPASS "资源组L3MIN配置成功"
    else
        tst_res TFAIL "资源组L3MIN配置失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit