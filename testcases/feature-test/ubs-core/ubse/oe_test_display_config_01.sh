#!/usr/bin/bash

source "./common/com_ubse.sh"
source "./common/com_ubse_cli.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    stop_ubse 1
    stop_ubse 2
    P_SSH_CMD --cmd 'sed -i "/isLender/s/=.*/=false/" /etc/ubse/ubse.conf' --node 2
    start_ubse 1
    start_ubse 2
    return_nodes_by_role 1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    output=$(P_SSH_CMD --cmd "sudo -u ubse /usr/bin/ubsectl display memory -t config" --node 1)
    dict=$(echo "$output" | convert_cli_output_to_json)

    node2_slot_id=($(get_slot_id 2))
    node2_host_name=$(P_SSH_CMD --cmd "hostname" --node 2)

    node2_config=$(jq -n --arg hostname "$node2_host_name" --arg slot_id "$node2_slot_id" --arg isLender "false" \
     '{node:"\($hostname)(\($slot_id))", isLender:$isLender}')

    exists1=$(echo "$dict" | jq --argjson new_object "$node2_config" 'any(.[]; .node == $new_object.node and .isLender == $new_object.isLender)')
    if [ "$exists1" = 'true' ]; then
        echo "display config success."
    else
        echo "display config fail."
        exit 1
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    stop_ubse 1
    stop_ubse 2
    P_SSH_CMD --cmd 'sed -i "/isLender/s/=.*/=true/" /etc/ubse/ubse.conf' --node 2
    LOG_INFO "End to restore the test environment."
}

main "$@"