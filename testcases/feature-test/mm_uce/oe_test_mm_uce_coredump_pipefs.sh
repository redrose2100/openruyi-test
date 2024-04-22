#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   cheliequan
# @Contact   :   cheliequan@inspur.com
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   内存UCE错误
# ############################################

source "${OET_PATH}/testcases/feature-test/mm_uce/common.sh"

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start environment preparation."
    if [ "${NODE1_MACHINE}" != "physical" ]; then
        LOG_INFO "The environment does not support testing"
        exit 1
    fi
    make -C ./common 
    make -C ./common install
    dmesg -c > /dev/null
    load_mm_uce_module
    load_einj_module
    if do_mm_uce_check;then
        LOG_INFO "The environment does not support testing"
	exit 1
    fi
    enable_tracepoint
    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    date > "${LOG}"
    do_mm_uce_test coredump -f pipefs  >> "${LOG}"  2>&1
    check_ghes_rec_result && check_memory_failure_recover_result
    CHECK_RESULT $? 0 0 "mm_uce coredump pipefs failed" 1
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to clean the test environment."
    unload_mm_uce_module
    unload_einj_module
    make -C common uninstall
    LOG_INFO "End to clean the test environment."
}

main "$@"

