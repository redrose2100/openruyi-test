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


virt-filesystems -a 1.img
virt-filesystems --all -a 1.img
virt-filesystems --blkdevs -a 1.img
virt-filesystems -c test:///default -a 1.img
virt-filesystems --csv -a 1.img
virt-filesystems -d vm1
virt-filesystems --echo-keys -a 1.img
virt-filesystems --extra -a 1.img
virt-filesystems --filesystems -a 1.img
virt-filesystems --format=qcow2 -a 1.img




virt-filesystems --long -h --all -a 1.img
virt-filesystems --help 2>&1 | grep 'virt-filesystems'
CHECK_RESULT $? 0 0 "Check virt-filesystems --help failed"
virt-filesystems --keys-from-stdin -a 1.img
virt-filesystems --long -h --all -a 1.img
virt-filesystems --lvs -a 1.img
virt-filesystems --no-title -a 1.img
virt-filesystems --parts -a 1.img
virt-filesystems --pvs -a 1.img
virt-filesystems --uuid -a 1.img
virt-filesystems -v -a 1.img



virt-filesystems -V 2>&1 ｜ grep $(rpm -q libguestfs --queryformat '%{version}\n')    
CHECK_RESULT $? 0 0 "Check virt-filesystems -V failed"
virt-filesystems --vgs -a 1.img
virt-filesystems -x -a 1.img





    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
