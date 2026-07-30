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
# @Desc      :   导出粒度测试
# ############################################
# shellcheck disable=SC1009,SC1020,SC1035,SC1072,SC1073,SC1091,SC2002,SC2004,SC2015,SC2034,SC2046,SC2048,SC2068,SC2086,SC2153,SC2154

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source common.sh

function pre_test() {
    deploy_exec
    ECNA="$(get_cna_by_ip)"
    DEID="$(get_eid_by_ip)"
    dmesg -C
}

function run_test() {
    # 导出0M
    test_export 0 $EXP_MMAP_FLAG $DEID
    CHECK_RESULT $? 0 1
    dmesg | grep 'The size of new OBMM region is 0. Non-zero value expected'
    CHECK_RESULT $? 0
    # 导出4K
    test_export $((4 * KB2B)) $EXP_MMAP_FLAG $DEID
    CHECK_RESULT $? 0 1
    dmesg | grep 'The size of new OBMM region 0x1000 on node 0 is not aligned to OBMM memseg size 0x200000'
    CHECK_RESULT $? 0
    # 导出2M ，导出成功
    test_export $((2 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0
    # 导出4M ,导出成功
    test_export $((4 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0
    # 导出128M ，导出成功
    test_export $((128 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0

    # 导出130M(2M 对齐，非4M对齐，非128M对齐)，导出成功
    test_export $((130 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)
    CHECK_RESULT $? 0
    
    # mem_allocator_granu=32M，导出2M，导出失败
    rmmod obmm
    insmod_obmm mem_allocator_granu=32M
    test_export $((2 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0 1
    cat export.log
    dmesg -T | grep "The size of new OBMM region 0x200000 on node 0 is not aligned to OBMM memseg size 0x2000000"
    CHECK_RESULT $? 0
	
    # 导出40M，(32M 对齐)，导出失败
    test_export $((40 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0 1
    cat export.log
    dmesg -T | grep "The size of new OBMM region 0x2800000 on node 0 is not aligned to OBMM memseg size 0x2000000"
    CHECK_RESULT $? 0
	
    # 导出128M，(32M 对齐)，导出成功
    test_export $((128 * MB2B)) $EXP_MMAP_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    test_unexport $(get_id export.log)
    CHECK_RESULT $? 0
}

function post_test() {
    rmmod obmm
    insmod_obmm_default
}

main "$@"
