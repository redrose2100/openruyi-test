sed -i 's/\r$//' ./common/com_ubse.sh
sed -i 's/\r$//' ./common/com_ubse_cli.sh
source ./common/com_ubse.sh
source ./common/com_ubse_cli.sh
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
    output=$(P_SSH_CMD --cmd "ubsectl display cluster" --node 1)
    dict=$(echo "$output" | convert_cli_output_to_json)
    dict=$(echo "$dict" |jq 'map(. + { "bonding_eid": .["bonding-eid"] } | del(.["bonding-eid"]))')

    node1_slot_id=($(get_slot_id 1))
    node2_slot_id=($(get_slot_id 2))
    node1_host_name=$(P_SSH_CMD --cmd "hostname" --node 1)
    node2_host_name=$(P_SSH_CMD --cmd "hostname" --node 2)
    node1_eid="4245:4944:0000:0000:0000:0000:0${node1_slot_id}00:0000"
    node2_eid="4245:4944:0000:0000:0000:0000:0${node2_slot_id}00:0000"

    return_info=$(return_nodes_by_role "1")
    read -r masterId standbyId <<< "$return_info"

    if [ "$masterId" = '1' ]; then
        node1_role='master'
        node2_role='standby'
    else
        node1_role='standby'
        node2_role='master'
    fi

    node1_cluster=$(jq -n --arg hostname "$node1_host_name" --arg bonding_eid "$node1_eid" --arg role $node1_role \
    --arg slot_id "$node1_slot_id" '{node:"\($hostname)(\($slot_id))", role:$role, bonding_eid:$bonding_eid}')
    node2_cluster=$(jq -n --arg hostname "$node2_host_name" --arg bonding_eid "$node2_eid" --arg role $node2_role \
    --arg slot_id "$node2_slot_id" '{node:"\($hostname)(\($slot_id))", role:$role, bonding_eid:$bonding_eid}')

    exists1=$(echo "$dict" | jq --argjson new_object "$node1_cluster" 'any(.[]; .node == $new_object.node and .role == $new_object.role and .bonding_eid == $new_object.bonding_eid)')
    exists2=$(echo "$dict" | jq --argjson new_object "$node2_cluster" 'any(.[]; .node == $new_object.node and .role == $new_object.role and .bonding_eid == $new_object.bonding_eid)')
    if [ "$exists1" = 'true' ] && [ "$exists2" = 'true' ]; then
        echo "display cluster success."
    else
        echo "display cluster fail."
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