#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/04
# resctrl分组下，schemata配置L3MIN为20%

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    echo "L3MIN:${ENV_L3_ID[0]}=20" > $mpam_dir/schemata
    if [ $? -eq 0 ]; then
        tst_res TPASS "根分组L3MIN配置成功"
    else
        tst_res TFAIL "根分组L3MIN配置失败"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit
