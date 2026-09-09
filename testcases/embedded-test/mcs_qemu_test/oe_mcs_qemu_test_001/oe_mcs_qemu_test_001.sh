#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   sevenjj
#@Contact   	:   2461603862@qq.com
#@Date      	:   2023-11-22
#@License   	:   Mulan PSL v2
#@Desc      	:   check qemu mcs  
#####################################
source "${OET_PATH}/testcases/embedded-test/mcs_qemu_test/common.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    
    # 检测 mcs_km.ko 网卡管理驱动是否存在，不存在则跳过测试
    check_env

    echo "1 4 1 7" > /proc/sys/kernel/printk
    find / -name "mcs_km.ko" | awk 'NR==1{print}' | xargs insmod
    bin_path="$(find / -name "zephyr-image.bin" | awk 'NR==1{print}')"

    i=0
    while true; do
      if ! [ -c "/dev/pts/$i" ]; then
        scr_path="/dev/pts/$i"	   
        break
      fi
      i=$((i+1))
    done

    rpmsg_main -c 3 -t "${bin_path}" -a 0x7a000000  &
    screen -L -dmS test "${scr_path}"
    screen -r test -dm -X stuff "kernel version^M"
    sleep 30

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
   
    grep -q "Zephyr version 3.2.0" screenlog.0
    CHECK_RESULT "$?" 0 0 "mcs test failed"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    pgrep rpmsg_main |grep -v grep | awk '{print $1}' | xargs kill -2
    rmmod mcs_km.ko
    rm -rf screenlog.0

    LOG_INFO "End to restore the test environment."
}

main "$@"

