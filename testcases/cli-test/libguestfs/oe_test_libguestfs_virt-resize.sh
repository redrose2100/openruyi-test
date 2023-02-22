#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libguestfs
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

virt-resize --align-first never 2.img 2_1.img
virt-resize --alignment 128 2.img 2_1.img
virt-resize --color 2.img 2_1.img
virt-resize -d 2.img 2_1.img
virt-resize --delete /dev/sda2 2.img 2_1.img
virt-resize -n 2.img 2_1.img
virt-resize --expand /dev/sda2 2.img 2_1.img
virt-resize --format qcow2 2.img 2_1.img
    virt-resize --help | grep 'virt-resize: resize a virtual'
    CHECK_RESULT $? 0 0 "Check virt-resize --help failed"
virt-resize --ignore /dev/sda2 2.img 2_1.img



virt-resize --machine-readable qcow2 2.img 2_1.img
virt-resize --no-copy-boot-loader 2.img 2_1.img
virt-resize --no-expand-content 2.img 2_1.img
virt-resize --no-extra-partition  2.img 2_1.img
virt-resize --no-sparse  2.img 2_1.img
virt-resize --ntfsresize-force 2.img 2_1.img
virt-resize --output-format raw 2.img 2_1.img
virt-resize -q 2.img 2_1.img
virt-resize -q 2.img 2_1.img


virt-resize --resize-force /dev/sda1=+128K 2.img 2_1.img
virt-resize --unknown-filesystems ignore 2.img 2_1.img

    virt-resize -V | grep $(rpm -q libguestfs --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check virt-resize -V failed"
virt-resize -v 2.img 2_1.img
virt-resize -x 2.img 2_1.img





















    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
