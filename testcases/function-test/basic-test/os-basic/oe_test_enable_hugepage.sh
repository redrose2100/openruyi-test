#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2022/06/13
# @License   :   Mulan PSL v2
# @Desc      :   Test if hugepage enabled
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    LOG_INFO "Nothing to do."
    origin=$(cat /proc/sys/vm/nr_hugepages)
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    local exp_pages real_pages
    exp_pages=128
    echo $exp_pages > /proc/sys/vm/nr_hugepages
    real_pages=$(grep HugePages_Total /proc/meminfo|awk '{print $NF}')
    CHECK_RESULT "$real_pages" "$exp_pages"  0 "real pages is $real_pages, should be $exp_pages."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    LOG_INFO "Reset hugepages to 0."
    echo "$origin" > /proc/sys/vm/nr_hugepages
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
