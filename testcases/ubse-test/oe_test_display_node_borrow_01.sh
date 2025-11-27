sed -i 's\/r$//' ./common/com_start_ubse.sh
source ./common/com_start_ubse.sh
function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    res1=$(P_SSH_CMD --cmd "ubsectl display memory -t node_borrow" --node 1)
    dict1=$(echo "$res1" | convert_cli_output_to_json)
    lend_node=$(echo dict1|grep -o '"lend":"[^"]*"' | sed 's/"lend":"\([^"]*\)"/\1/')
    size=$(echo dict1|grep -o '"size":"[^"]*"' | sed 's/"size":"\([^"]*\)"/\1/')
    if ["$lend_node" == "node01(2)"] && ["$size" == "256"];then
       echo "query success"
       exit 0
    else
       exit 1
    fi
    res2=$(P_SSH_CMD --cmd "ubsectl display memory -t node_borrow" --node 2)
    dict2=$(echo "$res2" | convert_cli_output_to_json)
    lend_node2=$(echo dict2|grep -o '"lend":"[^"]*"' | sed 's/"lend":"\([^"]*\)"/\1/')
    size2=$(echo dict2|grep -o '"size":"[^"]*"' | sed 's/"size":"\([^"]*\)"/\1/')
    if ["$lend_node2" == "node01(2)"] && ["$size2" == "256"];then
       echo "query success"
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