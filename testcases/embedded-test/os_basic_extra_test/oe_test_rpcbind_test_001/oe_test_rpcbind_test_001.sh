#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   hukun
#@Contact   	:   hu_kun@hoperun.com
#@Date      	:   2024-01-17
#@License   	:   Mulan PSL v2
#@Desc      	:   Test rpcbind
#####################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    pgrep rpcbind
    CHECK_RESULT $? 0 0 "Failed to check rpcbind"
    netstat -tulnp | grep rpcbind | grep tcp | grep 111
    CHECK_RESULT $? 0 0 "Failed to execute netstat"
    rpcinfo -b 100004 2
    CHECK_RESULT $? 0 0 "Failed to execute rpcbind"
    pgrep rpcbind
    CHECK_RESULT $? 0 0 "Failed to display rpcbind"
    LOG_INFO "End to run test."
}

main "$@"
