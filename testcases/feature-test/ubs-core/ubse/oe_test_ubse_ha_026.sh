sed -i 's/\r$//' ./common/com_ubse.sh
source ./common/com_ubse.sh
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    return_info=$(return_nodes_by_role "1")
    read -r masterId standbyId <<< "$return_info"

    echo "Master: $masterId" 
    echo "StadbyId: $standbyId" 
    result=$(stop_ubse "$masterId")
    if [ "$result" == "false" ]; then
        exit 1
    fi

    for i in $(seq 1 60); do
        masterId_new=$(display_node_role "$standbyId" "master")
        if [ "$masterId_new" != "$masterId" ]; then
            echo "master node change"
            break
        else
            sleep 5
        fi
    done

    if [ "$masterId_new" != "$standbyId" ]; then
        exit 1
    fi
    result=$(start_ubse "$masterId")
    if [ "$result" == "false" ]; then
        echo "start node $masterId fail"
        exit 1
    fi
    for i in $(seq 1 20); do
        masterId_new1=$(display_node_role "$standbyId" "master")
        if [ "$masterId_new1" != "$masterId_new" ]; then
            exit 1
        else
            sleep 5
        fi
    done
    return_info1=$(return_nodes_by_role "1")
    read -r masterId1 standbyId1 <<< "$return_info1"
    if [ "$masterId1" != "$standbyId" ]; then
        exit 1
    fi
    if [ "$standbyId1" != "$masterId" ]; then
        exit 1

    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    LOG_INFO "End to restore the test environment."
}

main "$@"