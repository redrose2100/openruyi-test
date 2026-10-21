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
# @Desc      :   cmdline配置：pmd_mapping配置参数测试--pmd_mapping=100%
# ############################################
# shellcheck disable=SC1009,SC1020,SC1035,SC1072,SC1073,SC1091,SC2002,SC2004,SC2015,SC2034,SC2046,SC2048,SC2068,SC2086,SC2153,SC2154

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source ./common.sh
set +e

function pre_test() {
    deploy_exec
}

function run_test() {
    rmmod obmm
    insmod_obmm_default mempool_allocator=hugetlb_pmd
    # pmd_mapping=100%时不走高位地址预留流程，只修改内核线性映射
    dmesg | grep -E "contig_memory|pfn_range_alloc"
    CHECK_RESULT $? 0 1
    cat $RSV_MEM_RANGE
    CHECK_RESULT $? 0 1
    # 未配置大页，直接export会失败
    for ((i = 0; i < 2; i++)); do
        numa0_mem=0
        numa1_mem=0
        eval numa${i}_mem=$GRANU
        DEID="$(get_eid_by_ip $i)"

        test_export $numa0_mem,$numa1_mem $EXP_COMMON_FLAG $DEID &> export.log
        CHECK_RESULT $? 0 1
        cat export.log
    done
    # 配置2M大页后，export成功
    for ((i = 0; i < $NODE_NUM; i++)); do
        echo 2048 > ${NODEINFO}$i/hugepages/hugepages-2048kB/nr_hugepages
    done
    cat /proc/meminfo
    numa_mem_list=$((1 * GB2B))
    DEID="$(get_eid_by_ip)"
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0
}

function post_test() {
    rmmod obmm
    insmod_obmm_default
}

main "$@"
