#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.12.11
# @License   :   Mulan PSL v2
# @Desc      :   libusb formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/libusb.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <libusb-1.0/libusb.h>

int main() {
    int ret;
    libusb_context *ctx = NULL;
    libusb_device **devs;
    ssize_t cnt;

    // 初始化libusb
    ret = libusb_init(&ctx);
    if (ret < 0) {
        fprintf(stderr, "无法初始化libusb\n");
        exit(EXIT_FAILURE);
    }

    // 获取已连接的USB设备列表
    cnt = libusb_get_device_list(ctx, &devs);
    if (cnt < 0) {
        fprintf(stderr, "无法获取USB设备列表\n");
        libusb_exit(ctx);
        exit(EXIT_FAILURE);
    }

    // 遍历设备列表
    for (ssize_t i = 0; i < cnt; i++) {
        libusb_device *dev = devs[i];
        struct libusb_device_descriptor desc;

        // 获取设备描述符
        ret = libusb_get_device_descriptor(dev, &desc);
        if (ret < 0) {
            fprintf(stderr, "无法获取设备描述符\n");
            continue;
        }

        // 打印设备信息
        printf("设备 %04x:%04x\n", desc.idVendor, desc.idProduct);
    }

    // 释放资源
    libusb_free_device_list(devs, 1);
    libusb_exit(ctx);

    return 0;
}
EOF

    DNF_INSTALL "libusb libusb-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libusb
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc -o libusb libusb.c -lusb-1.0
    test -f /tmp/libusb
    CHECK_RESULT $? 0 0 "compile libusb.c fail"
    ./libusb > libusb.txt
    grep "1d6b" /tmp/libusb.txt    
    CHECK_RESULT $? 0 0 "execute libusb.txt fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/libusb /tmp/libusb.c /tmp/libusb.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
