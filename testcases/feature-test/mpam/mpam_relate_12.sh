#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
# Author: wenrenjie@huawei.com
# Create: 2025/09/03
# vcpu在监控组迁移测试

. mpam_lib.sh
tst_begin_test

fn_main(){
    mount -t resctrl resctrl $mpam_dir

    mkdir $mpam_dir/p1
    mkdir $mpam_dir/p1/mon_groups/m1 $mpam_dir/p1/mon_groups/m2

    cpu="1"
    echo $cpu > $mpam_dir/p1/cpus_list
    echo $cpu > $mpam_dir/p1/mon_groups/m1/cpus_list

    echo $cpu > $mpam_dir/p1/mon_groups/m2/cpus_list
    grep -wq $cpu $mpam_dir/p1/mon_groups/m2/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TPASS "cpu迁移到新的监控组成功"
    else
        tst_res TFAIL "cpu迁移到新的监控组失败"
    fi
    grep -wq $cpu $mpam_dir/p1/mon_groups/m1/cpus_list
    if [ $? -eq 0 ]; then
        tst_res TFAIL "cpu在原资源组移除失败"
    else
        tst_res TPASS "cpu在原资源组移除成功"
    fi

    umount $mpam_dir
}

fn_main

tst_check_dmesg
tst_exit