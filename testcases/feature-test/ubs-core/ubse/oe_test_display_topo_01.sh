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
    output=$(P_SSH_CMD --cmd "ubsectl display topo -t cpu" --node 1)
    dict=$(echo "$output" | get_topo_by_cli)
    dict=$(echo "$dict" |jq 'map(. + { "peer_socket": .["peer-socket"] } | del(.["peer-socket"]))')

    result=$(echo "$dict" | jq -c '.[] | select(.["peer_socket"] != "-") | select(.["socket"] == .["peer_socket"])')

    if [ -z "$result" ]; then
        echo "display topo fail."
        exit 1
    else
        echo "display topo success."
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