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

    # 在节点1上获取所有节点信息
    output=$(P_SSH_CMD --cmd "expect -c '
                              spawn python ubse_mem_app.py
                              expect \"ubse_mem_app>\"
                              send \"node_list\r\"
                              expect \"ubse_mem_app>\"
                              send \"exit\r\"
                              expect eof
                              '" --node 1)

    LOG_INFO "Full output from ubse_mem_app: $output"

    # 存储所有节点信息的关联数组
    declare -A node_info_map

    # 使用更可靠的方法分割节点信息块
    # 将输出按行读取，然后组装完整的节点信息块
    node_blocks=()
    current_block=""
    in_block=false

    while IFS= read -r line; do
        # 检查是否开始新的节点信息块
        if [[ "$line" =~ "ubse_node_info(" ]]; then
            if [[ -n "$current_block" ]]; then
                node_blocks+=("$current_block")
            fi
            current_block="$line"
            in_block=true
        elif [[ "$in_block" == true ]]; then
            current_block="$current_block"$'\n'"$line"
            if [[ "$line" =~ ^[[:space:]]*\)[[:space:]]*$ ]]; then
                node_blocks+=("$current_block")
                current_block=""
                in_block=false
            fi
        fi
    done <<< "$output"

    # 添加最后一个块（如果有）
    if [[ -n "$current_block" ]]; then
        node_blocks+=("$current_block")
    fi

    LOG_INFO "Number of node blocks found: ${#node_blocks[@]}"

    # 解析每个节点信息块
    for block in "${node_blocks[@]}"; do
        if [[ -n "$block" && "$block" =~ ubse_node_info ]]; then
            LOG_INFO "Processing node block:"
            LOG_INFO "$block"

            # 将块内容转换为单行以便于解析
            block_oneline=$(echo "$block" | tr '\n' ' ' | sed 's/INFO: //g')
            LOG_INFO "Block oneline: $block_oneline"

            # 提取 slot id
            slot_id=$(echo "$block_oneline" | sed -n 's/.*slot id=\([0-9]*\).*/\1/p')

            # 提取 socket ids
            socket_ids=$(echo "$block_oneline" | sed -n 's/.*socket ids=\[\([^]]*\)\].*/\1/p' | tr -d ' ')

            # 提取 host name
            host_name=$(echo "$block_oneline" | sed -n 's/.*host name=\([^[:space:]]*\).*/\1/p')

            LOG_INFO "Extracted: slot_id='$slot_id', socket_ids='$socket_ids', host_name='$host_name'"

            if [[ -n "$host_name" && -n "$slot_id" ]]; then
                node_info_map["$host_name"]="$slot_id|$socket_ids"
                LOG_INFO "Successfully parsed node: host_name=$host_name, slot_id=$slot_id, socket_ids=$socket_ids"
            else
                LOG_ERROR "Failed to parse node information from block"
                LOG_ERROR "Block content: $block"
            fi
        fi
    done

    # 打印所有解析到的节点信息
    LOG_INFO "All parsed node info:"
    for host in "${!node_info_map[@]}"; do
        LOG_INFO "Host: $host -> ${node_info_map[$host]}"
    done

    # 验证每个节点
    for node_num in 1 2; do
        LOG_INFO "Verifying node $node_num"

        # 获取当前节点的实际信息
        current_hostname=$(P_SSH_CMD --cmd "hostname" --node $node_num | tr -d '[:space:]')
        LOG_INFO "Node $node_num actual hostname: $current_hostname"

        # 检查节点信息是否存在
        if [[ -z "${node_info_map[$current_hostname]}" ]]; then
            LOG_ERROR "No matching node info found for hostname: $current_hostname"
            LOG_ERROR "Available hostnames in node_info_map: ${!node_info_map[@]}"
            return 1
        fi

        # 解析节点信息
        IFS='|' read -r slot_id socket_ids <<< "${node_info_map[$current_hostname]}"
        LOG_INFO "Node $node_num expected: slot_id=$slot_id, socket_ids=$socket_ids"

        # 验证 slot id (通过REST API)
        rest_output=$(P_SSH_CMD --cmd "curl -X GET \"http://127.0.0.1:34256/restconf/data/huawei-vbussw-inventory:vbussw-inventory/logic-entity-mappings\" -H \"Accept: application/yang-data+xml\" -H \"Content-Type: application/yang-data+xml\" -s" --node $node_num)

        slot_id_from_api=$(echo "$rest_output" | grep '<slot-id>' | sed 's/.*<slot-id>\([0-9]*\)<\/slot-id>.*/\1/' | head -1)
        LOG_INFO "Node $node_num slot id from API: $slot_id_from_api"

        if [ "$slot_id" != "$slot_id_from_api" ]; then
            LOG_ERROR "Slot ID mismatch for node $node_num: from ubse_mem_app=$slot_id, from API=$slot_id_from_api"
            return 1
        else
            LOG_INFO "Slot ID verification passed for node $node_num:$slot_id"
        fi

        # 验证 socket ids
        LOG_INFO "Start to collect physical_package_id from CPU topology on node $node_num"
        local cpu_package_ids=()

        # 在远程节点上遍历CPU目录
        cpu_dirs_output=$(P_SSH_CMD --cmd "find /sys/devices/system/cpu -name 'cpu[0-9]*' -type d | sort -V" --node $node_num)

        while IFS= read -r cpu_dir; do
            if [ -n "$cpu_dir" ]; then
                package_id=$(P_SSH_CMD --cmd "cat $cpu_dir/topology/physical_package_id 2>/dev/null" --node $node_num | tr -d '[:space:]')
                if [ -n "$package_id" ]; then
                    cpu_package_ids+=("$package_id")
                    LOG_INFO "Node $node_num CPU $(basename "$cpu_dir"): physical_package_id=$package_id"
                fi
            fi
        done <<< "$cpu_dirs_output"

        # 去重并排序
        local unique_package_ids=($(printf "%s\n" "${cpu_package_ids[@]}" | sort -u | tr '\n' ' ' | sed 's/ $//'))

        # 将socket_ids字符串转换为数组
        IFS=',' read -ra expected_socket_ids <<< "$socket_ids"

        # 验证socket_ids是否匹配
        local match_found=true

        # 检查每个expected_socket_id是否都在physical_package_ids中
        for expected_id in "${expected_socket_ids[@]}"; do
            local found=false
            for actual_id in "${unique_package_ids[@]}"; do
                if [ "$expected_id" = "$actual_id" ]; then
                    found=true
                    break
                fi
            done
            if [ "$found" = false ]; then
                LOG_ERROR "Node $node_num: Socket ID $expected_id not found in physical_package_ids"
                match_found=false
            fi
        done

        # 检查是否有额外的physical_package_id不在expected_socket_ids中
        for actual_id in "${unique_package_ids[@]}"; do
            local found=false
            for expected_id in "${expected_socket_ids[@]}"; do
                if [ "$actual_id" = "$expected_id" ]; then
                    found=true
                    break
                fi
            done
            if [ "$found" = false ]; then
                LOG_ERROR "Node $node_num: Extra physical_package_id $actual_id not in socket_ids"
                match_found=false
            fi
        done

        if [ "$match_found" = true ]; then
            LOG_INFO "Node $node_num socket IDs verification passed: ${expected_socket_ids[@]}"
        else
            LOG_ERROR "Node $node_num socket IDs mismatch: expected=${expected_socket_ids[@]}, actual=${unique_package_ids[@]}"
            return 1
        fi

        LOG_INFO "All verifications passed for node $node_num"
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "End to restore the test environment."
}

main "$@"