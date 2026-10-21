#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-08-25
# @License   :   Mulan PSL v2
# @Desc      :   test sysstat package
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "sysstat"
    device_name=$(lsblk -dn -o NAME,SIZE | awk '$2 != "0B" {print $1}')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    iostat 1 10 | grep Device
    CHECK_RESULT $? 0 0 "iostat 1 10 failed"
    dd if=/dev/zero of=/tmp/test.img bs=1M count=1000 &
    CHECK_RESULT $? 0 0 "dd command failed"
    iostat 1 2 >> testfile.txt
    cat < testfile.txt | grep "${device_name}"
    CHECK_RESULT $? 0 0 "iostat 1 2 failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test.img && rm -rf testfile.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
