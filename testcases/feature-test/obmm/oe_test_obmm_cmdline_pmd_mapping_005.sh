#!/usr/bin/bash
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   centianni
# @Contact   :   centianni@h-partners.com
# @Date      :   2026/04/16
# @License   :   Mulan PSL v2
# @Desc      :   cmdline配置：pmd_mapping配置参数测试--不配置pmd_mapping
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source ./common.sh
set +e

function pre_test() {
    deploy_exec
}

function run_test() {
    # numa节点没有预留连续物理内存
    dmesg | grep -E "contig_memory|pfn_range_alloc"
    CHECK_RESULT $? 0 1
    cat $RSV_MEM_RANGE
    CHECK_RESULT $? 0 1
    # 无法export
    for ((i = 0; i < 2; i++)); do
        numa0_mem=0
        numa1_mem=0
        eval numa${i}_mem=$GRANU
        DEID="$(get_eid_by_ip $i)"

        test_export $numa0_mem,$numa1_mem $EXP_COMMON_FLAG $DEID &> export.log
        CHECK_RESULT $? 0 1
        cat export.log
    done
}

function post_test() {
    return
}

main "$@"