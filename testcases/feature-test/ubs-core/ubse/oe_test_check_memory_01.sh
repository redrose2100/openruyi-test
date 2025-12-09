#!/usr/bin/bash

source "$OET_PATH/testcases/feature-test/ubs-core/ubse/common/com_ubse.sh"
function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    P_SSH_CMD --cmd "systemctl stop ubse" --node 1
    P_SSH_CMD --cmd "systemctl stop ubse" --node 2
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    res=$(start_ubse 1)
    echo "Start result:$res"
    sleep 120
    res1=$(P_SSH_CMD --cmd "ubsectl check memory" --node 1)
    dict=$(echo "$res1" | convert_cli_output_to_json)
    node_status=$(echo "$dict" | jq -r '.[] | select(.node == "-(2)") | .status')
    if [[ "$node_status" != "nok" ]];then
       exit 1
    fi
    res2=$(start_ubse 2)
    echo "Start result:$res2"
    sleep 300
    for i in {1..60};do
        res3=$(P_SSH_CMD --cmd "ubsectl display cluster" --node 1)
        dict2=$(echo "$res3" | convert_cli_output_to_json)
        role_controller=$(echo "$dict2" | jq -r '.[] | select(.node == "controller(1)") | .role')
        role_node01=$(echo "$dict2" | jq -r '.[] | select(.node == "node01(2)") | .role')
        if [[ "$role_controller" != "-" && "$role_node01" != "-" ]];then
           echo "All roles are ready:controller=$role_controller,node01=$role_node01"
           break
        fi
        sleep 5
    done
    res4=$(P_SSH_CMD --cmd "ubsectl check memory" --node 1)
    dict3=$(echo "$res4" | convert_cli_output_to_json)
    node_status1=$(echo "$dict3" | jq -r '.[] | select(.node == "node01(2)") | .status')
    if [[ "$node_status1" == "ok" ]];then
       exit 0
    else
       exit 1
    fi
    LOG_INFO "End to run test."
}
function post_test(){
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"