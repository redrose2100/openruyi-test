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


function get_cpu_socket_mapping() {
    local node_num=1

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

    echo "${unique_package_ids[@]}"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 获取lcne-topology数据
    lcne_xml=$(P_SSH_CMD --node 1 --cmd "curl -s -X GET 'http://127.0.0.1:34256/restconf/data/huawei-lingqu-topology:lingqu-topology/nodes' -H 'Accept: application/yang-data+xml' -H 'Content-Type: application/yang-data+xml'")

    # 获取ubse CPU拓扑信息
    ubse_output=$(P_SSH_CMD --cmd "expect -c '
                              spawn python ubse_mem_app.py
                              expect \"ubse_mem_app>\"
                              send \"cpu_topo\r\"
                              expect \"ubse_mem_app>\"
                              send \"exit\r\"
                              expect eof
                              '" --node 1)

    # 获取CPU socket映射
    socket_ids=($(get_cpu_socket_mapping))

    # 提取所有唯一的ubpu用于映射
    unique_chip_ids=$(echo "$lcne_xml" | grep -oP '<ubpu>\K[0-9]+' | sort -u -n)

    # 建立ubpu到socket-id的映射
    declare -A chip_to_socket_map
    i=0
    for chip_id in $unique_chip_ids; do
        if [ $i -lt ${#socket_ids[@]} ]; then
            chip_to_socket_map[$chip_id]=${socket_ids[$i]}
            LOG_INFO "Mapped ubpu $chip_id to socket-id ${socket_ids[$i]}"
        else
            chip_to_socket_map[$chip_id]=$chip_id
            LOG_INFO "No socket-id available for ubpu $chip_id, using ubpu as socket-id"
        fi
        ((i++))
    done

    # 从lcne_xml提取UP端口信息
    declare -A lcne_links

    # 创建临时文件存储LCNE链接
    lcne_links_file=$(mktemp)

    # 创建临时的映射文件来传递数组数据
    temp_map_file=$(mktemp)
    for key in "${!chip_to_socket_map[@]}"; do
        echo "$key:${chip_to_socket_map[$key]}" >> "$temp_map_file"
    done

    # 解析XML并直接写入临时文件
    echo "$lcne_xml" | awk -v map_file="$temp_map_file" -v output_file="$lcne_links_file" '
    BEGIN {
        while ((getline line < map_file) > 0) {
            split(line, parts, ":")
            chip_map[parts[1]] = parts[2]
        }
        close(map_file)

        slot_id = ""
        chip_id = ""
        port_id = ""
        remote_slot = ""
        remote_chip = ""
        remote_port = ""
        in_up_port = 0
    }

    /<slot>/ {
        slot_id = $0
        gsub(/.*<slot>|<\/slot>.*/, "", slot_id)
        slot_id = trim(slot_id)
    }

    /<ubpu>/ {
        chip_id = $0
        gsub(/.*<ubpu>|<\/ubpu>.*/, "", chip_id)
        chip_id = trim(chip_id)
    }

    /<physical-port>/ {
        port_id = ""
        remote_slot = ""
        remote_chip = ""
        remote_port = ""
        in_up_port = 0
    }

    /<physical-port-id>/ {
        port_id = $0
        gsub(/.*<physical-port-id>|<\/physical-port-id>.*/, "", port_id)
        port_id = trim(port_id)
    }

    /<remote-slot>/ {
        remote_slot = $0
        gsub(/.*<remote-slot>|<\/remote-slot>.*/, "", remote_slot)
        remote_slot = trim(remote_slot)
        if (remote_slot == "-") remote_slot = "N/A"
    }

    /<remote-ubpu>/ {
        remote_chip = $0
        gsub(/.*<remote-ubpu>|<\/remote-ubpu>.*/, "", remote_chip)
        remote_chip = trim(remote_chip)
        if (remote_chip == "-") remote_chip = "N/A"
    }

    /<remote-physical-port-id>/ {
        remote_port = $0
        gsub(/.*<remote-physical-port-id>|<\/remote-physical-port-id>.*/, "", remote_port)
        remote_port = trim(remote_port)
        if (remote_port == "-") remote_port = "N/A"
    }

    /<physical-port-status>up<\/physical-port-status>/ {
        in_up_port = 1
    }

    /<\/physical-port>/ {
        if (in_up_port == 1 && slot_id != "" && chip_id != "" && port_id != "" &&
            remote_slot != "N/A" && remote_chip != "N/A" && remote_port != "N/A") {

            socket_id = (chip_id in chip_map) ? chip_map[chip_id] : chip_id
            remote_socket_id = (remote_chip in chip_map) ? chip_map[remote_chip] : remote_chip

            key = slot_id "-" socket_id "-" port_id
            value = remote_slot "-" remote_socket_id "-" remote_port

            print key "=" value >> output_file
        }
        in_up_port = 0
    }

    function trim(str) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", str)
        return str
    }
    '

    # 从临时文件读取LCNE链接到数组
    while IFS='=' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            lcne_links["$key"]="$value"
            LOG_INFO "LCNE link: $key -> $value"
        fi
    done < "$lcne_links_file"

    # 清理临时文件
    rm -f "$temp_map_file" "$lcne_links_file"

    # 从ubse_output提取链接信息
    declare -A ubse_links

    # 创建临时文件存储UBSE链接
    ubse_links_file=$(mktemp)

    echo "$ubse_output" | grep "ubse_cpu_topo_info" -A 6 | awk -v output_file="$ubse_links_file" '
    BEGIN {
        slot_id = ""
        socket_id = ""
        port_id = ""
        peer_slot_id = ""
        peer_socket_id = ""
        peer_port_id = ""
        count = 0
    }
    /slot id=/ && !/peer/ {
        slot_id = $0
        gsub(/.*slot id=/, "", slot_id)
        gsub(/[^0-9]/, "", slot_id)
        count++
    }
    /socket ids=/ && !/peer/ {
        socket_id = $0
        gsub(/.*socket ids=/, "", socket_id)
        gsub(/[^0-9]/, "", socket_id)
        count++
    }
    /port id=/ && !/peer/ {
        port_id = $0
        gsub(/.*port id=/, "", port_id)
        gsub(/[^0-9]/, "", port_id)
        count++
    }
    /peer slot id=/ {
        peer_slot_id = $0
        gsub(/.*peer slot id=/, "", peer_slot_id)
        gsub(/[^0-9]/, "", peer_slot_id)
        count++
    }
    /peer socket ids=/ {
        peer_socket_id = $0
        gsub(/.*peer socket ids=/, "", peer_socket_id)
        gsub(/[^0-9]/, "", peer_socket_id)
        count++
    }
    /peer port id=/ {
        peer_port_id = $0
        gsub(/.*peer port id=/, "", peer_port_id)
        gsub(/[^0-9]/, "", peer_port_id)
        count++

        # 输出到文件
        if (slot_id != "" && socket_id != "" && port_id != "" &&
            peer_slot_id != "" && peer_socket_id != "" && peer_port_id != "") {
            key = slot_id "-" socket_id "-" port_id
            value = peer_slot_id "-" peer_socket_id "-" peer_port_id

            print key "=" value >> output_file

        }

        # 重置变量
        slot_id = ""
        socket_id = ""
        port_id = ""
        peer_slot_id = ""
        peer_socket_id = ""
        peer_port_id = ""
        count = 0
    }
    '

    # 从临时文件读取UBSE链接到数组
    while IFS='=' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ] && [ "$key" != "$value" ]; then
            ubse_links["$key"]="$value"
            LOG_INFO "UBSE link: $key -> $value"
        fi
    done < "$ubse_links_file"

    # 清理临时文件
    rm -f "$ubse_links_file"

    # 比较两个数据源的链接信息
    local mismatch_found=0

    # 检查LCNE中的链接是否都在UBSE中存在
    for key in "${!lcne_links[@]}"; do
        local lcne_value="${lcne_links[$key]}"
        local ubse_value="${ubse_links[$key]}"

        if [ -z "$ubse_value" ]; then
            LOG_ERROR "Link found in LCNE but not in UBSE: $key -> $lcne_value"
            mismatch_found=1
        elif [ "$lcne_value" != "$ubse_value" ]; then
            LOG_ERROR "Link mismatch for $key: LCNE=$lcne_value, UBSE=$ubse_value"
            mismatch_found=1
        else
            LOG_INFO "Link match: $key -> $lcne_value"
        fi
    done

    # 统计信息
    local lcne_count=${#lcne_links[@]}
    local ubse_count=${#ubse_links[@]}

    LOG_INFO "LCNE link count: $lcne_count"
    LOG_INFO "UBSE link count: $ubse_count"

    if [ $lcne_count -eq 0 ]; then
        LOG_ERROR "No links found in LCNE data"
        mismatch_found=1
    fi

    if [ $ubse_count -eq 0 ]; then
        LOG_ERROR "No links found in UBSE data"
        mismatch_found=1
    fi

    if [ $mismatch_found -eq 1 ]; then
        LOG_ERROR "LCNE and UBSE link data do not match"
        return 1
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "End to restore the test environment."
}

main "$@"