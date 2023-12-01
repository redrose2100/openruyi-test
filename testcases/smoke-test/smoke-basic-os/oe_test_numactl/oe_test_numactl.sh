#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lutianxiong
# @Contact   :   lutianxiong@huawei.com
# @Date      :   2020-11-10
# @License   :   Mulan PSL v2
# @Desc      :   numactl&numad test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "numactl numad"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    numactl -s | grep policy
    CHECK_RESULT $? 0 0 "numactl -s failed"
    numactl -H | grep "available: [0-9] nodes"
    CHECK_RESULT $? 0 0 "numactl -H failed"
    numactl -C 0-1 top -n 1
    CHECK_RESULT $? 0 0 "numactl -C failed"
    numastat | grep -E "numa_hit|numa_miss|numa_foreign|interleave_hit|local_node|local_node"
    CHECK_RESULT $? 0 0 "numastat command failed"
    numactl --physcpubind 0 --membind 0 numactl -H
    CHECK_RESULT $? 0 0 "numactl --physcpubind 0 --membind 0 numactl -H test failed"
    systemctl restart numad
    CHECK_RESULT $? 0 0 "systemctl restart numad failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop numad
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
