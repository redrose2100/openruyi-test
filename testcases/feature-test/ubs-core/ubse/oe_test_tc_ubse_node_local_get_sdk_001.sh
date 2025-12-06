#!/usr/bin/bash

source "$OET_PATH/testcases/ubse-test/common/com_ubse.sh"
node_ids=(1 2)
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    for nodeId in "${node_ids[@]}"; do
        res=$(get_ubse_pid "$nodeId")
        if [ "$res" == "false" ]; then
            result=$(start_ubse "$nodeId")
            if [ "$result" = "false" ]; then
                exit 1
            fi
        fi
    done
    res=$(check_mem_nodes_num "${node_ids[0]}" "${#node_ids[@]}")
    if [ "$res" == "false" ]; then
      exit 1
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    output=$(P_SSH_CMD --cmd "expect -c '
                              spawn python ubse_mem_app.py
                              expect \"ubse_mem_app>\"
                              send \"node_get\r\"
                              expect \"ubse_mem_app>\"
                              send \"exit\r\"
                              expect eof
                              '" --node 1)

    # 提取 slot id
    slot_id=$(echo "$output" | grep "slot id=" | sed 's/.*slot id=\([0-9]*\).*/\1/')

    # 提取 socket ids
    socket_ids=$(echo "$output" | grep "socket ids=" | sed 's/.*socket ids=\[\([^]]*\)\].*/\1/' | tr -d ' ')

    # 将 socket ids 转换为数组
    IFS=',' read -ra socket_ids_array <<< "$socket_ids"

    # 提取 host name
    host_name=$(echo "$output" | grep "host name=" | sed 's/.*host name=\([^[:space:]]*\).*/\1/')

    # 遍历CPU目录获取physical_package_id并验证
    local cpu_package_ids=()

    # 在远程节点上遍历CPU目录
    cpu_dirs_output=$(P_SSH_CMD --cmd "find /sys/devices/system/cpu -name 'cpu[0-9]*' -type d | sort -V" --node 1)

    while IFS= read -r cpu_dir; do
        if [ -n "$cpu_dir" ]; then
            package_id=$(P_SSH_CMD --cmd "cat $cpu_dir/topology/physical_package_id 2>/dev/null" --node 1 | tr -d '[:space:]')
            if [ -n "$package_id" ]; then
                cpu_package_ids+=("$package_id")
                LOG_INFO "Node 1 CPU $(basename "$cpu_dir"): physical_package_id=$package_id"
            fi
        fi
    done <<< "$cpu_dirs_output"

    # 去重并排序
    local unique_package_ids=($(printf "%s\n" "${cpu_package_ids[@]}" | sort -u | tr '\n' ' ' | sed 's/ $//'))

    # 验证socket_ids是否匹配
    local match_found=true

    # 检查每个socket_id是否都在physical_package_ids中
    for expected_id in "${socket_ids_array[@]}"; do
        local found=false
        for actual_id in "${unique_package_ids[@]}"; do
            if [ "$expected_id" == "$actual_id" ]; then
                found=true
                break
            fi
        done
        if [ "$found" = false ]; then
            LOG_ERROR "Socket ID $expected_id not found in physical_package_ids"
            match_found=false
        fi
    done

    # 检查是否有额外的physical_package_id不在socket_ids中
    for actual_id in "${unique_package_ids[@]}"; do
        local found=false
        for expected_id in "${socket_ids_array[@]}"; do
            if [ "$actual_id" == "$expected_id" ]; then
                found=true
                break
            fi
        done
        if [ "$found" = false ]; then
            LOG_ERROR "Extra physical_package_id $actual_id not in socket_ids"
            match_found=false
        fi
    done

    if [ "$match_found" = true ]; then
        LOG_INFO "Socket IDs verification passed: ${socket_ids_array[@]}"
    else
        LOG_ERROR "Socket IDs mismatch: expected=${socket_ids_array[@]}, actual=${unique_package_ids[@]}"
        return 1
    fi

    # 验证 slot id (通过REST API)
    rest_output=$(P_SSH_CMD --cmd "curl -X GET \"http://127.0.0.1:34256/restconf/data/huawei-vbussw-inventory:vbussw-inventory/logic-entity-mappings\" -H \"Accept: application/yang-data+xml\" -H \"Content-Type: application/yang-data+xml\" -s" --node 1)

    slot_id_from_api=$(echo "$rest_output" | grep '<slot-id>' | sed 's/.*<slot-id>\([0-9]*\)<\/slot-id>.*/\1/' | head -1)

    if [ "$slot_id" != "$slot_id_from_api" ]; then
        LOG_ERROR "Slot ID mismatch: from ubse_mem_app=$slot_id, from API=$slot_id_from_api"
        return 1
    else
        LOG_INFO "Slot ID verification passed:$slot_id"
    fi

    # 获取hostname并比较
    hostname_output=$(P_SSH_CMD --cmd "hostname" --node 1)
    current_hostname=$(echo "$hostname_output" | tr -d '[:space:]')
    LOG_INFO "Current hostname: $current_hostname"

    # 比较host_name
    if [ "$host_name" != "$current_hostname" ]; then
        LOG_ERROR "Hostname mismatch: from ubse_mem_app=$host_name, current=$current_hostname"
        return 1
    else
        LOG_INFO "Hostname verification passed: $host_name"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "End to restore the test environment."
}

main "$@"