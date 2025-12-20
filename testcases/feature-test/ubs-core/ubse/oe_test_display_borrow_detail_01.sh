#!/usr/bin/bash

source "$OET_PATH/testcases/feature-test/ubs-core/ubse/common/com_ubse.sh"
node_ids=(1 2)
function pre_test(){
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

function run_test(){
    LOG_INFO "Start to run test."
    result=$(mem_borrow_common "${node_ids[0]}" "fd_create test_display_borrow_detail_1 128M")
    if [[ $result =~ "Successfully" ]]
    then
        echo "create successfully"
    else
        exit 1
    fi
    result=$(mem_borrow_common "${node_ids[0]}" "numa_create test_display_borrow_detail_2 128M")
    if [[ $result =~ "Successfully" ]]
    then
        echo "create successfully"
    else
        exit 1
    fi

    res1=$(P_SSH_CMD --cmd "sudo -u ubse /usr/bin/ubsectl display memory -t borrow_detail" --node 1)
    dict1=$(echo "$res1" | convert_cli_output_to_json)
    echo "Query result:$dict1"
    type=$(echo "$dict1"|grep -o '"type":"[^"]*"' | sed 's/"type":"\([^"]*\)"/\1/')
    if [[ "$type" == "fd" ]];then
       borrow_node=$(echo "$dict1"|grep -o '"borrow_node":"[^"]*"' | sed 's/"borrow_node":"\([^"]*\)"/\1/')
       lend_node=$(echo "$dict1"|grep -o '"lend_node":"[^"]*"' | sed 's/"lend_node":"\([^"]*\)"/\1/')
       borrow_size=$(echo "$dict1"|grep -o '"borrow_size":"[^"]*"' | sed 's/"borrow_size":"\([^"]*\)"/\1/')
       status=$(echo "$dict1"|grep -o '"status":"[^"]*"' | sed 's/"status":"\([^"]*\)"/\1/')
       if [ "$borrow_node" == "controller(1)" ] && [ "$lend_node" == "node01(2)" ] && [ "$borrow_size" == "128" ] && [ "$status" == "done" ];then
           echo "query success"
           exit 0
       else
           exit 1
       fi
    fi
    if [[ "$type" == "numa" ]];then
       borrow_node=$(echo "$dict1"|grep -o '"borrow_node":"[^"]*"' | sed 's/"borrow_node":"\([^"]*\)"/\1/')
       lend_node=$(echo "$dict1"|grep -o '"lend_node":"[^"]*"' | sed 's/"lend_node":"\([^"]*\)"/\1/')
       borrow_size=$(echo "$dict1"|grep -o '"borrow_size":"[^"]*"' | sed 's/"borrow_size":"\([^"]*\)"/\1/')
       status=$(echo "$dict1"|grep -o '"status":"[^"]*"' | sed 's/"status":"\([^"]*\)"/\1/')
       if [ "$borrow_node" == "controller(1)" ] && [ "$lend_node" == "node01(2)" ] && [ "$borrow_size" == "128" ] && [ "$status" == "done" ];then
         echo "query success"
         exit 0
       else
         exit 1
       fi
    fi
    LOG_INFO "End to run test."
}
function post_test(){
    LOG_INFO "Start to restore the test environment."
    mem_borrow_common "${node_ids[0]}" "fd_delete test_display_borrow_detail_1"
    mem_borrow_common "${node_ids[0]}" "numa_delete test_display_borrow_detail_2"
    LOG_INFO "End to restore the test environment."
}

main "$@"