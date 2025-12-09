#!/usr/bin/bash

source "${OET_PATH}/testcases/feature-test/ubs-core/ubse/common/com_ubse.sh"
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

    result=$(mem_borrow_common "${node_ids[0]}" "numa_info ${node_ids[0]}")
    if [[ $result =~ "ubse_numa_mem_info" ]]
    then
        echo "get numa_info successfully"
    else
        exit 1
    fi

    result=$(mem_borrow_common "${node_ids[0]}" "numa_info 100")
    if [[ $result =~ "ubse_numa_mem_info" ]]
    then
        exit 1
    else
        echo "can't get numa_info"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    LOG_INFO "End to restore the test environment."
}

main "$@"