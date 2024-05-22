#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-05-21
# @License   :   Mulan PSL v2
# @Desc      :   test link
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo 111 > /tmp/test_source
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    link --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "link --help execute fail"
    link --version | grep -i link
    CHECK_RESULT $? 0 0 "link --version execute fail"
    link /tmp/test_source /tmp/test_source_link
    CHECK_RESULT $? 0 0 "link execute fail"
    test_source_link_stat_device_inode_links_info=$(stat /tmp/test_source_link | grep -E "设备|Device")
    stat /tmp/test_source | grep "${test_source_link_stat_device_inode_links_info}"
    CHECK_RESULT $? 0 0 "link execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/test_source /tmp/test_source_link
    LOG_INFO "End to restore the test environment."
}

main "$@"
