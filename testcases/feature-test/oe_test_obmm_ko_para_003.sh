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
# @Desc      :   [pmd_mapping<100%] mempool_allocator模块参数测试
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
    # 检查参数默认值
    cat /sys/module/obmm/parameters/mempool_allocator | grep -E "null|buddy_highmem"
    CHECK_RESULT $? 0
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -E "null|2M"
    CHECK_RESULT $? 0
    # 检查默认行为，mapping < 100%，默认使用buddy，到处粒度是2M
    total_mem=$((2 * MB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)
    rmmod obmm.ko
    dmesg -C
    insmod_obmm_default mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    dmesg | grep 'unsuported mem_alocator_granu: 1M'
    CHECK_RESULT $? 0
    insmod_obmm_default mem_allocator_granu=2M
    dmesg -C
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 2M
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mem_allocator_granu=32M
    CHECK_RESULT $? 0
    dmesg -C
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 32M
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    dmesg | grep 'The size of new OBMM region 0x200000 on node 0 is not aligned to OBMM memseg size 0x2000000'
    CHECK_RESULT $? 0

    total_mem=$((32 * MB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mem_allocator_granu=1G
    CHECK_RESULT $? 0
    dmesg -C
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 1G
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    dmesg | grep 'The size of new OBMM region 0x2000000 on node 0 is not aligned to OBMM memseg size 0x40000000'
    CHECK_RESULT $? 0

    total_mem=$((1 * GB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mempool_allocator=buddy_highmem
    cat /sys/module/obmm/parameters/mempool_allocator | grep buddy_highmem
    CHECK_RESULT $? 0
    total_mem=$((2 * MB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=2M
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    dmesg -C
    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=32M
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 32M
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    dmesg | grep 'The size of new OBMM region 0x200000 on node 0 is not aligned to OBMM memseg size 0x2000000'
    CHECK_RESULT $? 0

    total_mem=$((32 * MB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mempool_allocator=buddy_highmem mem_allocator_granu=1G
    CHECK_RESULT $? 0
    dmesg -C
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 1G
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    dmesg | grep 'The size of new OBMM region 0x2000000 on node 0 is not aligned to OBMM memseg size 0x40000000'
    CHECK_RESULT $? 0

    total_mem=$((2 * GB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    test_unexport $(get_id export.log)

    rmmod obmm.ko
    insmod_obmm_default mempool_allocator=hugetlb_pmd 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pud
    CHECK_RESULT $? 0
    cat /sys/module/obmm/parameters/mempool_allocator | grep hugetlb_pud
    CHECK_RESULT $? 0

    set_hugepages
    total_mem=$((128 * MB2B))
    numa_mem_init $total_mem
    dmesg -C
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID
    dmesg | grep "The size of new OBMM region 0x8000000 on node [0-9] is not aligned to OBMM memseg size 0x40000000"
    CHECK_RESULT $? 0
    total_mem=$((1024 * MB2B))
    numa_mem_init $total_mem
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)

    rmmod obmm
    insmod_obmm_default mempool_allocator=hugetlb_pud mem_allocator_granu=1M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pud mem_allocator_granu=2M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pud mem_allocator_granu=32M 2>&1 | grep "Invalid argument"
    CHECK_RESULT $? 0
    insmod_obmm_default mempool_allocator=hugetlb_pud mem_allocator_granu=1G
    cat /sys/module/obmm/parameters/mem_allocator_granu | grep -w 1G
    CHECK_RESULT $? 0
}

function post_test() {
    rmmod obmm
    insmod_obmm_default
}

main "$@"