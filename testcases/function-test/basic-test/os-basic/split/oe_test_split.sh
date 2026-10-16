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
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2023.03.31
# @License   :   Mulan PSL v2
# @Desc      :   File system common command split
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    cd /tmp
    dd if=/dev/zero bs=100k count=2 of=big.tar.gz
    md5sum big.tar.gz |awk '{print $1}' > 1.txt
    CHECK_RESULT $? 0 0 "create fail"
    split -b 100K big.tar.gz
    CHECK_RESULT $? 0 0 "split fail"
    test -e xaa
    CHECK_RESULT $? 0 0 "Failed to find the file"
    test -e xab
    CHECK_RESULT $? 0 0 "Failed to find the file" 
    cat xaa xab > big2.tar.gz
    CHECK_RESULT $? 0 0 "merge fail"   
    md5sum big2.tar.gz |awk '{print $1}' > 2.txt
    diff 1.txt 2.txt
    CHECK_RESULT $? 0 0 "Command executed successfully"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf big.tar.gz big2.tar.gz xaa xab
    LOG_INFO "End to restore the test environment."
}
main $@

