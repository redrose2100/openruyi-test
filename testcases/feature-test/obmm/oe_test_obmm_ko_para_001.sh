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
# @Desc      :   ko内核模块参数测试: mempool_size
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source ./common.sh
set +e

key_log_1="test_export: allocated"
key_log_2="slow allocated|pa_start-pa_end is invalid"
key_log_5="OBMM:.*conti_pool_norm: expand expect size"

function get_export_nid() {
    local node_export_mem=$1
    for ((nid = 0; nid < ${#tmp_list[@]}; nid++)); do
        [ "${tmp_list[nid]}" -eq "$node_export_mem" ] && break
    done
    key_log_3="OBMM:.*conti_pool_thread: nid=$nid, expand done, ret="
    key_log_4="OBMM:.*conti_pool_thread: nid=$nid, contract done, ret="
}

function pre_test() {
    deploy_exec
    DEID="$(get_eid_by_ip)"
}

function run_test() {
    # ------------------------------- 检查默认参数 ------------------------------------
    cat ${KO_PARA}/mempool_size | grep -w '1G'
    CHECK_RESULT $? 0

    ## ------------------------------- 默认1G内存池（每个node 1G/NODE_NUM）。内存池内存快速借出 ------------------------------------
    echo "$POOL_EXPAND_DONE_DEBUG" > "$SYS_DYNAMIC_DEBUG_CTL"
    ## 单节点export $pool_pre_node（未超出内存池范围）
    pool_pre_node=$((1 * GB2B / NODE_NUM))
    pool_pre_node_hex=0x$(printf "%x" $pool_pre_node)
    dmesg -C
    numa_mem_init "$pool_pre_node"
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    check_dmesg "$key_log_1 $pool_pre_node_hex"
    CHECK_RESULT $? 0
    dmesg -T | grep "$key_log_2"
    CHECK_RESULT $? 0 1

    # 查找是哪个nid借出的内存
    get_export_nid "$((pool_pre_node_hex))"

    # 等待内存池扩充
    for ((i = 0; i < 10; i++)); do
        sleep 3
        dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_3}${pool_pre_node_hex}" && break
    done

    # unexport
    dmesg -C
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0

    # 内存池扩充后，回收内存会直接回收至系统，不再回收至内存池
    check_dmesg "${key_log_4}${pool_pre_node_hex}"
    CHECK_RESULT $? 0 1

    ## 单节点export $pool_pre_node+mem_allocator_granu M（超出，申请系统内存）
    dmesg -C
    pool_pre_node_p2=$((pool_pre_node + GRANU))
    pool_pre_node_p2_hex=0x$(printf "%x" $pool_pre_node_p2)
    numa_mem_init "$pool_pre_node_p2"
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    check_dmesg "$key_log_1 $pool_pre_node_p2_hex" "$key_log_2 0x200000"
    CHECK_RESULT $? 0

    # 查找是哪个nid借出的内存
    get_export_nid "$((pool_pre_node_p2))"

    # 等待内存池扩充
    for ((i = 0; i < 60; i++)); do
        sleep 5
        dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_3}${pool_pre_node_hex}" && break
        sync
    done
    check_dmesg "${key_log_3}${pool_pre_node_hex}"
    CHECK_RESULT $? 0

    # unexport
    dmesg -C
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0

    # 内存池扩充后，回收内存会直接回收至系统，不再回收至内存池
    check_dmesg "${key_log_4}${pool_pre_node_p2_hex}"
    CHECK_RESULT $? 0 1

    # ------------------------------- 内存池大小设置2G（单位支持K/M/G） ------------------------------------
    for pool_size in 2G $((2 * KB2B))M $((2 * MB2B))K; do
        rmmod obmm.ko
        dmesg -C
        insmod_obmm mempool_size=$pool_size
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        cat ${KO_PARA}/mempool_size | grep -w "$pool_size"
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        pool_pre_node=$((2 * GB2B / NODE_NUM))
        pool_pre_node_hex=0x$(printf "%x" $pool_pre_node)
        # 等待内存池扩充
        for ((i = 0; i < 10; i++)); do
            sleep 3
            dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_3}${pool_pre_node_hex}" && break
        done

        ## 单节点export $pool_pre_node（未超出内存池范围）
        dmesg -C
        numa_mem_init $pool_pre_node
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        cat export.log
        EXP_MEM_ID=$(get_id export.log)
        check_dmesg "$key_log_1 ${pool_pre_node_hex}"
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        dmesg -T | grep "$key_log_2"
        CHECK_RESULT $? 0 1 "pool_size=$pool_size"

        # 查找是哪个nid借出的内存
        get_export_nid "$((pool_pre_node_hex))"

        # 等待内存池扩充
        for ((i = 0; i < 10; i++)); do
            sleep 3
            dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_3}${pool_pre_node_hex}" && break
        done
        check_dmesg "${key_log_3}${pool_pre_node_hex}"
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        # unexport
        dmesg -C
        test_unexport $EXP_MEM_ID
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        # 内存池扩充后，回收内存会直接回收至系统，不再回收至内存池
        check_dmesg "${key_log_4}${pool_pre_node_hex}"
        CHECK_RESULT $? 0 1 "pool_size=$pool_size"

        ## 单节点export $pool_pre_node+mem_allocator_granu M（超出，申请系统内存）
        dmesg -C
        pool_pre_node_p2=$((pool_pre_node + GRANU))
        pool_pre_node_p2_hex=0x$(printf "%x" $pool_pre_node_p2)
        numa_mem_init $pool_pre_node_p2
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"
        cat export.log
        EXP_MEM_ID=$(get_id export.log)
        check_dmesg "$key_log_1 ${pool_pre_node_p2_hex}"
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        # 等待内存池扩充
        for ((i = 0; i < 10; i++)); do
            sleep 3
            dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_3}${pool_pre_node_hex}" && break
        done
        check_dmesg "${key_log_3}${pool_pre_node_hex}"
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        # unexport
        dmesg -C
        test_unexport $EXP_MEM_ID
        CHECK_RESULT $? 0 0 "pool_size=$pool_size"

        # 内存池扩充后，回收内存会直接回收至系统，不再回收至内存池
        check_dmesg "${key_log_4}${pool_pre_node_p2_hex}"
        CHECK_RESULT $? 0 1 "pool_size=$pool_size"
    done
    
    # ------------------------------- 内存池大小设置0 ------------------------------------
    rmmod obmm.ko
    dmesg -C
    insmod_obmm mempool_size=0G
    CHECK_RESULT $? 0
    cat ${KO_PARA}/mempool_size | grep -w '0G'
    CHECK_RESULT $? 0
    # 内存池没有扩充
    sleep 30
    dmesg -T | grep "${key_log_3}"
    CHECK_RESULT $? 0 1

    # export 2M
    dmesg -C
    numa_mem_init $GRANU
    CHECK_RESULT $? 0
    test_export $numa_mem_list $EXP_COMMON_FLAG $DEID &> export.log
    CHECK_RESULT $? 0
    cat export.log
    EXP_MEM_ID=$(get_id export.log)
    check_dmesg "$key_log_1 0x200000" "$key_log_2 0x200000"
    CHECK_RESULT $? 0

    # 查找是哪个nid借出的内存
    get_export_nid "$((pool_pre_node_hex))"
    # 内存池没有扩充
    sleep 30
    dmesg -T | grep "${key_log_3}"
    CHECK_RESULT $? 0 1

    # unexport
    dmesg -C
    test_unexport $EXP_MEM_ID
    CHECK_RESULT $? 0
    
    # 等待内存池收缩
    for ((i = 0; i < 10; i++)); do
        sleep 3
        dmesg -T | grep -vE "$JUNK_LOGS" | grep -q "${key_log_4}0x200000" && break
    done

    # ------------------------------- 内存池大小设置超出预留内存总量 ------------------------------------
    rmmod obmm.ko
    dmesg -C
    mem_total=$(cat /proc/meminfo | grep ^MemTotal | awk '{print $2}')
    set_pool_size=$((mem_total * KB2B / GB2B + 2))
    pre_node=$(((mem_total * KB2B / GB2B + 1) / NODE_NUM * GB2B))
    pre_node_hex=0x$(printf "%x" $pre_node)
    # 配置内存池总大小$set_pool_sizeG<平均每个node $((set_pool_size/NODE_NUM))>，每个node实际预留内存总量$(((mem_total/KB2B/GB2B+1)/NODE_NUM))
    insmod_obmm mempool_size=${set_pool_size}G
    CHECK_RESULT $? 0
    cat ${KO_PARA}/mempool_size | grep -w "${set_pool_size}G"
    CHECK_RESULT $? 0

    # 等待内存池扩充（无法达到预期）
    for ((i = 0; i < 10; i++)); do
        sleep 3
        dmesg -T | grep -vE "$JUNK_LOGS" | grep "${key_log_5} ${pre_node_hex}" | wc -l | grep -w 3 && break
    done
    act_sizes=$(dmesg -T | grep "${key_log_5} ${pre_node_hex}" | awk -F 'actual size' '{print $2}')
    for act_size in $act_sizes; do
        diff=$((${pre_node_hex} - act_size))
        if [$((set_pool_size * GB2B / NODE_NUM - pre_node)) -gt $diff]; then
            exit 1
        fi
    done
}

function post_test() {
    # 恢复ko
    rmmod obmm
    insmod_obmm
}

main "$@"