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

    result=$(mem_borrow_common "${node_ids[0]}" "numa_create test_ubse_mem_numa_sdk 128M")
    if [[ $result =~ "Successfully" ]]
    then
        echo "create successfully"
    else
        exit 1
    fi

    result=$(mem_borrow_common "${node_ids[0]}" "numa_get test_ubse_mem_numa_sdk")
    if [[ $result =~ "Successfully" ]]
    then
        echo "get memory successfully"
    else
        exit 1
    fi

    result=$(mem_borrow_common "${node_ids[0]}" "numa_list")
    if [[ $result =~ "test_ubse_mem_numa_sdk" ]]
    then
        echo "list memory successfully"
    else
        exit 1
    fi

    result=$(mem_borrow_common "${node_ids[0]}" "numa_delete test_ubse_mem_numa_sdk")
    if [[ $result =~ "Successfully" ]]
    then
        echo "delete memory successfully"
    else
        exit 1
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mem_borrow_common "${node_ids[0]}" "numa_delete test_ubse_mem_numa_sdk"
    LOG_INFO "End to restore the test environment."
}

main "$@"