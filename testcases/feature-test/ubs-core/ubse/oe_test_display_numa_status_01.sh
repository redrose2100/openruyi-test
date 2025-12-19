#!/usr/bin/bash

source "./common/com_ubse.sh"
source "./common/com_ubse_cli.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    stop_ubse 1
    stop_ubse 2
    start_ubse 1
    start_ubse 2
    return_nodes_by_role 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    output=$(P_SSH_CMD --cmd "sudo -u ubse /usr/bin/ubsectl display memory -t numa_status" --node 1)
    dict=$(echo "$output" | convert_cli_output_to_json)
    total_free_mem1=$(echo "$dict" |jq -c 'group_by(.node) | map({node: .[0].node, total:map(.total | tonumber) | add})')
    total_free_mem1=$(echo "$total_free_mem1" | jq 'map(.total |= tostring)')
    node1_free_mem=$(echo $(echo "$(P_SSH_CMD --cmd "free | grep Mem" --node 1)"| awk '{print $2}')/1024 | bc)
    node2_free_mem=$(echo $(echo "$(P_SSH_CMD --cmd "free | grep Mem" --node 2)"| awk '{print $2}')/1024 | bc)

    node1_slot_id=($(get_slot_id 1))
    node2_slot_id=($(get_slot_id 2))
    node1_host_name=$(P_SSH_CMD --cmd "hostname" --node 1)
    node2_host_name=$(P_SSH_CMD --cmd "hostname" --node 2)
    node1_total_free_mem=$(jq -n --arg hostname "$node1_host_name" --arg slot_id "$node1_slot_id" --arg total $node1_free_mem \
    '{node:"\($hostname)(\($slot_id))", total:$total}')
    node2_total_free_mem=$(jq -n --arg hostname "$node2_host_name" --arg slot_id "$node2_slot_id" --arg total $node2_free_mem \
    '{node:"\($hostname)(\($slot_id))", total:$total}')

    exists1=$(echo "$total_free_mem1" | jq --argjson new_object "$node1_total_free_mem" 'any(.[]; .node == $new_object.node and .total == $new_object.total)')
    exists2=$(echo "$total_free_mem1" | jq --argjson new_object "$node2_total_free_mem" 'any(.[]; .node == $new_object.node and .total == $new_object.total)')
    if [ "$exists1" = 'true' ] && [ "$exists2" = 'true' ]; then
        echo "display numa_status success."
    else
        echo "display numa_status fail."
        exit 1
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    stop_ubse 1
    stop_ubse 2
    LOG_INFO "End to restore the test environment."
}

main "$@"