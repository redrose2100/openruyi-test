sed -i 's/\r$//' ./common/com_ubse.sh
source ./common/com_ubse.sh
node_ids=(1 2)
rpm_install=()
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    for nodeId in "${node_ids[@]}"; do
        read -ra result < <(install_rpm "$nodeId")
        rpm_install+=("${result[@]}")
        echo "rpm_install: $rpm_install"
    done
    echo "rpm_install: $rpm_install"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${#rpm_install[@]}" -eq 8 ]; then
        for value in "${rpm_install[@]}"; do
            if [ "$value" == "false" ]; then
                echo "There are issues with installing therpm package"
                exit 1
            fi
        done
    else
        echo "return_values length is not 8, exiting"
        exit 1
    fi
    for nodeId in "${node_ids[@]}"; do
        stop_ubse "$nodeId"
    done
    results=()
    ubse_status=()
    for nodeId in "${node_ids[@]}"; do
        result=$(start_ubse "$nodeId")
        results+=("$result")
        ubse_status=$(exec_service "$nodeId" "status")
        if echo "$ubse_status" | grep -q "active"; then
            ubse_status+=("true")
        else
            ubse_status+=("false")
        fi
    done
    for value in "${results[@]}"; do
        if [ "$value" == "false" ]; then
            echo "start ubse fail"
            exit 1
        fi
    done
    for value in "${ubse_status[@]}"; do
        if [ "$value" == "false" ]; then
            echo "ubse status is inactive"
            exit 1
        fi
    done
    echo "start ubse success"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    LOG_INFO "End to restore the test environment."
}

main "$@"