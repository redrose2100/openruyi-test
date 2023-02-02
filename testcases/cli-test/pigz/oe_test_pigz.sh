#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023.1.31
# @License   :   Mulan PSL v2
# @Desc      :   pigz 包功能验证
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    dd if=/dev/zero of=test.tar bs=4M count=10
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    pigz test.tar
    ls test.tar.gz
    CHECK_RESULT $? 0 0  "pgiz compression failure"
    pigz -d -p 8 test.tar.gz &
    pid=$!
    number=$(cat /proc/$pid/status | grep Threads | awk {'print $NF'})
    [ $number -le 8 ] 
    CHECK_RESULT $? 0 0  "The number of threads displayed is greater than the set number of threads 8"
    tar -cvf - /var/log | pigz -k > logs.tar.gz
    CHECK_RESULT $? 0 0  "pgiz cannot be used with tar"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.tar* logs.tar.gz
    LOG_INFO "Finish environment cleanup!"
}

main $@
