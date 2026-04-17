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
# @Author    :   yanglijin
# @Contact   :   yanglijin@huawei.com
# @Date      :   2026/04/15
# @License   :   Mulan PSL v2
# @Desc      :   [pmd_mapping=100%] mempool_allocator模块参数测试
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source common.sh

function pre_test() {
    deploy_exec
    ECNA="$(get_cna_by_ip)"
    DEID="$(get_eid_by_ip)"
}

function run_test() {
    rmmod obmm
    insmod_obmm_default
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -E "null|2M"
    CHECK_RESULT $? 0
    cat /sys/module/obmm/parameters/mempool_allocator | grep -E "null|buddy_highmem"
    CHECK_RESULT $? 0
    total_mem=$((2 * MB2B))
    numa_mem_list=$total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mem_allocator_granu=2M
    CHECK_RESULT $? 0
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mem_allocator_granu=32M
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    CHECK_RESULT $? 0 1
    dmesg | grep 'The size of new OBMM region 0x200000 on node 0 is not aligned t OBMM memseg size 0x2000000'
    CHECK_RESULT $? 0
    total_mem=$((32 * MB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mem_allocator_granu=1G
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    CHECK_RESULT $? 0
    dmesg | grep 'The size of new OBMM region 0x2000000 on node 0 is not aligned to OBMM memseg size 0x40000000'
    CHECK_RESULT $? 0
    total_mem=$((1 * GB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)

    rmmod obmm
    insmod_obmm_default mempool_allocator=buddy_highmem
    CHECK_RESULT $? 0

    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $deid &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=2M
    CHECK_RESULT $? 0
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=32M
    CHECK_RESULT $? 0
    total_mem=$((2 * MB2B))
    numa_mem_list=$total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    CHECK_RESULT $? 0 1
    dmesg | grep 'The size of new OBMM region 0x200000 on node 0 is not aligned to OBMM memseg size 0x2000000'
    CHECK_RESULT $? 0
    total_mem=$((32 * MB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=1G
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    CHECK_RESULT $? 0 1
    dmesg | grep 'The size of new OBMM region 0x2000000 on NODE 0 is not aligned to OBMM memseg size 0X40000000'
    CHECK_RESULT $? 0
    total_mem=$((1 * GB2B))
    numa_mem_init $total_mem
    dmesg -C
    echo 3 > /proc/sys/vm/drop_caches
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)

    rmmod obmm

    # 使用2M大页，环境无2M页，导出失败
    insmod_obmm_default mempool_allocator=hugetlb_pmd
    CHECK_RESULT $? 0
    total_mem=$((2 * MB2B))

    # 配置2M大页，导出成功
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=2M
    total_mem=$((2 * MB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=32M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=1G 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0

    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=2M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pmd mem_allocator_granu=32M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0

    # 使用1G大页
    insmod_obmm_default mempool_allocator=hugetlb_pud
    CHECK_RESULT $? 0
    total_mem=$((1 * GB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    # 说明申请的大页来自系统内存，非内存池
    dmesg | grep "slow allocated"
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm

    dmesg -C
    insmod_obmm_default mempool_allocator=hugetlb_pud mempool_size=4G
    CHECK_RESULT $? 0
    total_mem=$((1 * GB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    # 匹配不到slow allocated ，说明申请的大页来自内存池，非系统内存
    dmesg | grep "slow allocated"
    CHECK_RESULT $? 0 1
    test_unexport $(get_id export.log)

    rmmod obmm
    insmod_obmm_default mempool_allocator=buddy_highmem
    CHECK_RESULT $? 0
}

function post_test() {
    rmmod obmm
    insmod_obmm_default
}

main "$@"