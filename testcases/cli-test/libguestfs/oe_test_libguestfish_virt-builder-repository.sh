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







    virt-builder-repository  --color  --machine-readable
    virt-builder-repository --gpg /root/ --machine-readable
    virt-builder-repository --gpg-key  "joe@hacker.org" -i ./
    virt-builder-repository --help 2>&1 | grep 'virt-builder-repository'
    CHECK_RESULT $? 0 0 "Check virt-builder-repository --help failed"
    virt-builder-repository --gpg-key  "joe@hacker.org" -i ./
    virt-builder-repository --machine-readable
    virt-builder-repository  --no-compression  --machine-readable
    virt-builder-repository  -q --machine-readable
    virt-builder-repository -V 2>&1 |  grep $(rpm -q libguestfs --queryformat '%{version}\n')
    virt-builder-repository  -v --machine-readable
    virt-builder-repository  -x --machine-readable





    
    







    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_INSTALL
    LOG_INFO "Finish to restore the test environment."
}

main $@
