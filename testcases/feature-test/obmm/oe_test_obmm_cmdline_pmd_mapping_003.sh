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
# @Desc      :   cmdline配置：pmd_mapping配置参数测试--pmd_mapping=13%（16G 2numa环境）
# ############################################
# shellcheck disable=SC1009,SC1020,SC1035,SC1072,SC1073,SC1091,SC2002,SC2004,SC2015,SC2034,SC2046,SC2048,SC2068,SC2086,SC2153,SC2154

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source ./common.sh
set +e

function pre_test() {
    deploy_exec
}

function run_test() {
    # 每个numa节点预留连续物理内存大小刚好达到1G
    dmesg | grep -E "contig_memory|pfn_range_alloc"
    CHECK_RESULT $? 0
    for ((i = 0; i < $NODE_NUM; ++i)); do
        dmesg | grep -E "contig_memory|pfn_range_alloc"
        CHECK_RESULT $? 0
    done
    for ((i = 0; i < $NODE_NUM; ++i)); do
        start_addr=0x$(cat $RSV_MEM_RANGE | grep "^$i," | tail -n1 | awk '{print $2}' | awk -F'-' '{print $1}')
        end_addr=0x$(cat $RSV_MEM_RANGE | grep "^$i," | tail -n1 | sed 's/\r//' | awk -F'-' '{print $2}')
        CHECK_RESULT $((end_addr - start_addr)) $GB2B
    done
    # export成功
    numa_mem_list=$((64 * MB2B))
    CHECK_RESULT $? 0
    DEID="$(get_eid_by_ip)"
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0
}

function post_test() {
    return
}

main "$@"
