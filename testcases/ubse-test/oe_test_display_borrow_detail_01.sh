sed -i 's\/r$//' ./common/com_start_ubse.sh
source ./common/com_start_ubse.sh
function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    res1=$(P_SSH_CMD --cmd "ubsectl display memory -t borrow_detail" --node 1)
    dict1=$(echo "$res1" | convert_cli_output_to_json)
    echo "Query result:$dict1"
    type=$(echo dict1|grep -o '"type":"[^"]*"' | sed 's/"type":"\([^"]*\)"/\1/')
    if [["$type" == "fd"]];then
       borrow_node=$(echo dict1|grep -o '"borrow_node":"[^"]*"' | sed 's/"borrow_node":"\([^"]*\)"/\1/')
       lend_node=$(echo dict1|grep -o '"lend_node":"[^"]*"' | sed 's/"lend_node":"\([^"]*\)"/\1/')
       borrow_size=$(echo dict1|grep -o '"borrow_size":"[^"]*"' | sed 's/"borrow_size":"\([^"]*\)"/\1/')
       status=$(echo dict1|grep -o '"status":"[^"]*"' | sed 's/"status":"\([^"]*\)"/\1/')
       if ["$borrow_node" == "controller(1)"] && ["$lend_node" == "node01(2)"] && ["$borrow_size" == "128"] && ["$status" == "done"];then
       echo "query success"
       exit 0
    else
       exit 1
    fi
    if [["$type" == "numa"]];then
       borrow_node=$(echo dict1|grep -o '"borrow_node":"[^"]*"' | sed 's/"borrow_node":"\([^"]*\)"/\1/')
       lend_node=$(echo dict1|grep -o '"lend_node":"[^"]*"' | sed 's/"lend_node":"\([^"]*\)"/\1/')
       borrow_size=$(echo dict1|grep -o '"borrow_size":"[^"]*"' | sed 's/"borrow_size":"\([^"]*\)"/\1/')
       status=$(echo dict1|grep -o '"status":"[^"]*"' | sed 's/"status":"\([^"]*\)"/\1/')
       if ["$borrow_node" == "controller(1)"] && ["$lend_node" == "node01(2)"] && ["$borrow_size" == "128"] && ["$status" == "done"];then
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