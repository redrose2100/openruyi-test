#!/bin/bash
# shellcheck disable=SC1009,SC1020,SC1035,SC1072,SC1073,SC1091,SC2002,SC2004,SC2015,SC2034,SC2046,SC2048,SC2068,SC2086,SC2153,SC2154
readonly CPU_TOPO='/root/cpu_socket_topology'
readonly SYS_MEMPOOL_ALLOCATOR='/sys/module/obmm/parameters/mempool_allocator'
readonly NODEINFO="/sys/devices/system/node/node"
readonly CNA_PATH="/sys/devices/ub_bus_controller0/00001/primary_cna"
readonly EID_PATH="/sys/devices/ub_bus_controller0/00001/eid"
readonly EXP_COMMON_FLAG='0'
# pmd_mapping不等于100且未配置rotadata=full时，该接口显示预留地址范围
readonly RSV_MEM_RANGE='/sys/kernel/debug/pmd_mapping_reserved_range'
# 大页相关路径
readonly SYS_MEM_ALLOCATOR_GRANU='/sys/module/obmm/parameters/mem_allocator_granu'
readonly SYS_MEMPOOL_ALLOCATOR='/sys/module/obmm/parameters/mempool_allocator'
readonly SYS_MEMPOOL_SIZE='/sys/module/obmm/parameters/mempool_size'
cat $SYS_MEM_ALLOCATOR_GRANU | grep -iw 32M && readonly GRANU_M=32 || readonly GRANU_M=2
# obmm_export测试需要mmap时使用的FLAG
readonly EXP_MMAP_FLAG='1'
# obmm_export测试常规使用的FLAG
readonly EXP_COMMON_FLAG='0'
# KB转换B
readonly KB2B=1024
# MB转换B
readonly MB2B=$((1024 * 1024))
# GB转换B
readonly GB2B=$((1024 * 1024 * 1024))
readonly GRANU=$((GRANU_M * MB2B))
# ko内核模块参数路径
readonly KO_PARA="/sys/module/obmm/parameters"
# 垃圾日志
readonly JUNK_LOGS='Fallback order for Node |OBMM: cache maintainence'
# 系统页面大小
readonly PAGE_SIZE=$(getconf PAGE_SIZE)

# debug日志
readonly SYS_DYNAMIC_DEBUG_CTL="/sys/kernel/debug/dynamic_debug/control"
expand_done_line_num=$(cat "$SYS_DYNAMIC_DEBUG_CTL" | grep "conti_pool_thread.*expand done" | awk -F: '{print $2}' | awk '{print $1}')
expand_done_file=$(cat "$SYS_DYNAMIC_DEBUG_CTL" | grep "conti_pool_thread.*expand done" | awk -F: '{print $1}')
POOL_EXPAND_DONE_DEBUG="module obmm file $expand_done_file line $expand_done_line_num +p"
contrace_expect_file=$(cat "$SYS_DYNAMIC_DEBUG_CTL" | grep "contract expect size" | awk -F: '{print $1}')
contrace_expect_file_line_num=$(cat "$SYS_DYNAMIC_DEBUG_CTL" | grep "conti_pool_thread.*contract done" | awk -F: '{print $2}' | awk '{print $1}')
POOL_CONTRACT_EXPECT_DONE_DEBUG="module obmm file $contrace_expect_file line $contrace_expect_file_line_num +p"

ls -l /usr/bin/numactl || yum install numactl -y
NODE_NUM=$(numactl -H | grep available | awk '{print $2}')

ALLOCATOR_GRANU=$(grep -q null $SYS_MEM_ALLOCATOR_GRANU || cat $SYS_MEM_ALLOCATOR_GRANU)
MEMPOOL_ALLOCATOR=$(grep -q null $SYS_MEMPOOL_ALLOCATOR || cat $SYS_MEMPOOL_ALLOCATOR)
MEMPOOL_SIZE=$(grep -q null $SYS_MEMPOOL_SIZE || cat $SYS_MEMPOOL_SIZE)

para=""
if [[ -n $ALLOCATOR_GRANU ]]; then
    para="$para mem_allocator_granu=$ALLOCATOR_GRANU"
fi
if [[ -n $MEMPOOL_ALLOCATOR ]]; then
    para="$para mempool_allocator=$MEMPOOL_ALLOCATOR"
fi
if [[ -n $MEMPOOL_SIZE ]]; then
    para="$para mempool_size=$MEMPOOL_SIZE"
fi

## usage: 根据实际numa节点数，在export时的分配各个numa内存
## input: $1: export总内存大小（十进制，单位：Byte）
##        $2: 指定使用那个cpu socket（默认是第一行即socket 0）
## output: null
function numa_mem_init() {
    local total_size="$1"
    local socket_line="${2:-1}"
    local mem_gap numa_list node_size free_huge_page free_size
    local mem_line=0

    check_cpu_socket || return 1

    [ -z "${total_size}" ] && return 1
    tmp_list=(x x x x x x x x x x x x x x x x)
    mem_gap=$total_size

    echo 1 > /proc/sys/vm/compact_memory
    echo 3 > /proc/sys/vm/drop_caches

    # 根据启动参数判断是高位地址预留流程，还是内核线性映射大页内存
    if cat /proc/cmdline | grep 'pmd_mapping=100%'; then
        # 设置大页
        set_hugepages
    else
        for ((i = 0; i < $NODE_NUM; ++i)); do
            node_size=$(numactl -H | grep "node $i size" | awk '{print $4}')
            mem_line=$((mem_line + node_size))

            # 低4G内存不可用，提前置零
            [ "$mem_line" -gt 4096 ] && break
            tmp_list[$i]=0
        done
    fi

    # 筛选出cpu socket对应的numa节点
    numa_list="$(sed -n "${socket_line}"p "$CPU_TOPO" | awk -F: '{print $2}')"

    # 从该cpu socket的最后一个节点开始分配
    for i in $(echo $numa_list | tr ' ' '\n' | sed '/^$/d' | sort -r); do
        # 若该numa节点已经被设置，则跳过
        [ ${tmp_list[$i]} == x ] || continue

        if cat /proc/cmdline | grep 'pmd_mapping=100%'; then
            if cat "$SYS_MEMPOOL_ALLOCATOR" | grep hugetlb_pud; then
                free_huge_page=$(cat ${NODEINFO}$i/hugepages/hugepages-1048576kB/free_hugepages)
                free_size=$((free_huge_page * GB2B))
            else
                free_huge_page=$(cat ${NODEINFO}$i/hugepages/hugepages-2048kB/free_hugepages)
                free_size=$((free_huge_page * 2 * MB2B))
            fi
        else
            free_size=$(numactl -H | grep "node $i free" | awk '{print $4}')
            free_size=$((free_size * MB2B))
        fi

        if [ $free_size -ge $((mem_gap * 2)) ]; then
            # 若该numa节点空闲内存大小 >= 剩余所需内存的2倍
            tmp_list[$i]=$mem_gap
        elif [ $free_size -ge $mem_gap ]; then
            if cat "$SYS_MEMPOOL_ALLOCATOR" | grep hugetlb_pud; then
                # 1G大页模式，直接从该node取出剩余所需
                tmp_list[$i]=$mem_gap
            else
                # 其他模式
                if [ $i -eq 0 ]; then
                    # 如果是第一个节点
                    tmp_list[$i]=$mem_gap
                else
                    # 其他模式，从该node取出剩余所需70%的剩余所需
                    tmp_list[$i]=$(((((mem_gap / (2 * MB2B)) * 70) / 100) * 2 * MB2B))
                fi
            fi
        else
            # 若剩余所需内存 > 该numa节点空闲内存大小
            if cat "$SYS_MEMPOOL_ALLOCATOR" | grep hugetlb_pud; then
                # 1G大页模式，取出该node所有剩余1G大页
                tmp_list[$i]=$((free_size / GB2B * GB2B))
            else
                # 为防止申请内存失败，只export该节点50%的内存
                tmp_list[$i]=$(((((free_size / (2 * MB2B)) * 50) / 100) * 2 * MB2B))
            fi
        fi

        mem_gap=$((mem_gap - tmp_list[$i]))
        [ $mem_gap -eq 0 ] && break
    done

    # debug
    numastat -vm

    # 校验
    [ "$mem_gap" -eq 0 ] || return 1

    numa_mem_list=$(echo ${tmp_list[@]} | tr 'x' '0' | tr ' ' ',')
    echo $numa_mem_list
}

## usage: 设置大页
## input: null
## output: null
function set_hugepages() {
    echo 3 > /proc/sys/vm/drop_caches
    for ((i = 0; i < $NODE_NUM; i++)); do
        if cat "$SYS_MEMPOOL_ALLOCATOR" | grep hugetlb_pud; then
            echo 32 > ${NODEINFO}$i/hugepages/hugepages-1048576kB/nr_hugepages
        else
            echo 4096 > ${NODEINFO}$i/hugepages/hugepages-2048kB/nr_hugepages
        fi
    done
}

## usage: 清理大页
## input: null
## output: null
function clean_hugepages() {
    echo 3 > /proc/sys/vm/drop_caches
    for ((i = 0; i < $NODE_NUM; i++)); do
        echo 0 > ${NODEINFO}$i/hugepages/hugepages-2048kB/nr_hugepages
        echo 0 > ${NODEINFO}$i/hugepages/hugepages-1048576kB/nr_hugepages
    done
}

## usage: 从日志中获取 obmm_export/obmm_import 成功后返回的mem_id
## input: $1: log path
## output: null
function get_id() {
    grep 'SUCCESS: mem_id' "$1" | awk -F'[=,]' '{print $2}'
}

## usage: 判断numa和cpu socket的拓扑关系
## input: null
## output: null
function check_cpu_socket() {
    local cpu_index socket i

    cat "$CPU_TOPO" && return 0

    for ((i = 0; i < $NODE_NUM; ++i)); do
        cpu_index=$(numactl -H | grep "node $i cpus:" | awk '{print $4}')
        # 远端numa就跳过
        [ -z "$cpu_index" ] && continue
        socket=$(cat /sys/devices/system/cpu/cpu"${cpu_index}"/topology/physical_package_id)
        [ -z "$socket" ] && continue
        grep -q "^${socket}:" "$CPU_TOPO" || echo "${socket}:" >> "$CPU_TOPO"
        sed -i "/^${socket}:/ s/$/ $i/g" "$CPU_TOPO"
    done
    cat "$CPU_TOPO"
    return 0
}

## usage: 插入obmm.ko
## input: ko入参
## output: null
function insmod_obmm_default() {
    if [ "$ENV_TYPE" = 'vm' ]; then
        modprobe obmm skip_cache_maintain=true $*
    else
        modprobe obmm $*
    fi
}

## usage: 根据环境类型插入obmm.ko
## input: ko入参
## output: null
function insmod_obmm() {
    if [ "$ENV_TYPE" = 'vm' ]; then
        modprobe obmm skip_cache_maintain=true $para $*
    else
        modprobe obmm $para $*
    fi
    echo "$POOL_EXPAND_DONE_DEBUG" > "$SYS_DYNAMIC_DEBUG_CTL"
    echo "$POOL_CONTRACT_EXPECT_DONE_DEBUG" > "$SYS_DYNAMIC_DEBUG_CTL"
}

## usage: 通过ip及numa id获取该环境中指定numa对应的cna （不可被sshfun调用）
## input: $1: ip
## input: $2: numa_id 非必填
## output: null
function get_cna_by_ip() {

    local numa_id=${1:-0}
    local cna_path path_cna
    if [[ "$numa_id" == "0" ]]; then
        cna_path="$CNA_PATH"
    else
        local path_id
        # 通过numa id获取cna_path路径中ub_bus_controller后面的数字编号；适用于多socket场景；
        path_id=$(get_socket_index_by_numa $numa_id)
        cna_path="/sys/devices/ub_bus_controller${path_id}/0000$((path_id+1))/primary_cna"
    fi
    path_cna=$(($(cat $cna_path)))
    echo "$path_cna"
}

## usage: 通过numa id获取该numa所属socket （不可被sshfun调用）
## input: $1: numa_id 非必填
## output: socket_index
function get_socket_index_by_numa() {
    local numa_id=${1:-0}
    local socket_index
    check_cpu_socket &> /dev/null || return 1
    socket_index=$(awk -v target="$numa_id" -F: '
        {
            gsub(/^[ \t]+|[ \t]+$/, "", $2)
            split($2, parts, /[ \t]+/)
            for (i in parts) {
                if (parts[i] == target) {
                    print NR - 1
                    exit
                }
            }
        }
' "$CPU_TOPO")
    echo "$socket_index"
}

function get_eid_by_ip() {
    local numa_id=${1:-0}
    local eid_path path_eid
    if [[ "$numa_id" == "0" ]]; then
        eid_path="$EID_PATH"
    else
        local path_id
        # 通过numa id获取eid_path路径中ub_bus_controller后面的数字编号；适用于多socket场景；
        path_id=$(get_socket_index_by_numa $numa_id)
        eid_path="/sys/devices/ub_bus_controller${path_id}/0000$((path_id+1))/eid"
    fi

    path_eid=$(($(cat $eid_path)))
    echo "$path_eid"
}

## usage: 部署测试所需二进制（必须在控制端执行，不能通过sshfun调用）（不可被sshfun调用）
## input: $1: ip（默认入参是'local'，即在本地部署，若在远端执行则传入对应ip）
## output: null
function deploy_exec() {
    file="test_export test_unexport"
    chmod 777 $file
    cp $file /usr/bin
}

## usage: 检查dmesg日志
## input: $1 ~ $N: 预期的日志信息（可大于1条）
## output: null
function check_dmesg() {
    # debug
    dmesg -T | grep -vE "$JUNK_LOGS" | tail -n 300

    while [ $# -gt 0 ]; do
        dmesg | grep -vE "$JUNK_LOGS" | tail -n 300 | grep -qE "$1" || return 1
        shift 1
    done
    return 0
}
