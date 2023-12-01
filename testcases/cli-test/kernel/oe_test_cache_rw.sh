#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   Test 缓存读写
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    free -h |grep -i mem |awk '{print $6}' |awk -F "M" '{print $1}'
    CHECK_RESULT $? 0 0 "Failed to view cache information"
    echo 3 > /proc/sys/vm/drop_caches
    CHECK_RESULT $? 0 0 "Failed to clear cache"
    cache_size=`free -h |grep -i mem |awk '{print $6}' |awk -F "M" '{print $1}'`
    dd if=/dev/zero of=/home/testfile count=100 bs=1M
    CHECK_RESULT $? 0 0 "fail to write to file"
    cache_size1=`free -h |grep -i mem |awk '{print $6}' |awk -F "M" '{print $1}'`
    [ ${cache_size1} -gt ${cache_size} ]
    CHECK_RESULT $? 0 0 "Cache utilization not increasing"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    echo 3 > /proc/sys/vm/drop_caches
    rm -rf /home/testfile
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"