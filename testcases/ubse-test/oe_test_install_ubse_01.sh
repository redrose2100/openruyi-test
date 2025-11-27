sed -i 's/\r$//' ./common/com_ubse.sh
source ./common/com_ubse.sh
node_ids=(1 2)
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    for nodeId in "${node_ids[@]}"; do
        get_package "$nodeId"
    done
    for nodeId in "${node_ids[@]}"; do
        P_SSH_CMD --cmd "rpm -evh python3-ubs-engine-1.0.0-1.noarch" --node $nodeId
        P_SSH_CMD --cmd "rpm -evh ubs-engine-client-devel" --node $nodeId
        P_SSH_CMD --cmd "rpm -evh ubs-engine-client-libs" --node $nodeId
        P_SSH_CMD --cmd "rpm -evh ubs-engine-1.0.0-1.aarch64" --node $nodeId
    done
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    info="Updating / installing"
    return_values=()
    for nodeId in "${node_ids[@]}"; do
        result1=$(P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-1.0.0-1.aarch64.rpm" --node $nodeId)
        if echo "$result1" | grep -q "$info"; then
            echo "install ubs-engine-1.0.0.1.aarch64.rpm success"
        else
            echo "install ubs-engine-1.0.0.1.aarch64.rpm fail"
        fi
        return_info1=$(get_version "$nodeId" "ubs-engine")
        read -r version_ubse_engine release_ubse_engine <<< "$return_info1"
        return_values+=("$version_ubse_engine")
    done

    for nodeId in "${node_ids[@]}"; do
        result2=$(P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-client-libs-1.0.0-1.aarch64.rpm" --node $nodeId)
        if echo "$result2" | grep -q "$info"; then
            echo "install ubs-engine-client-libs-1.0.0-1.aarch64.rpm success"
        else
            echo "install ubs-engine-client-libs-1.0.0-1.aarch64.rpm fail"
        fi
        return_info2=$(get_version $nodeId "ubs-engine-client-libs")
        read -r version_ubse_engine_libs release_ubse_engine_libs <<< "$return_info2"
        return_values+=("$version_ubse_engine_libs")
    done

    for nodeId in "${node_ids[@]}"; do
        result3=$(P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-client-devel-1.0.0-1.aarch64.rpm" --node $nodeId)
        if echo "$result3" | grep -q "$info"; then
            echo "install ubs-engine-client-libs-1.0.0-1.aarch64.rpm success"
        else
            echo "install ubs-engine-client-libs-1.0.0-1.aarch64.rpm fail"
        fi
        return_info3=$(get_version $nodeId "ubs-engine-client-devel")
        read -r version_ubse_engine_devel release_ubse_engine_devel <<< "$return_info3"
        return_values+=("$version_ubse_engine_devel")
    done

    for nodeId in "${node_ids[@]}"; do
        result4=$(P_SSH_CMD --cmd "rpm -ivh /root/manager/python3-ubs-engine-1.0.0-1.noarch.rpm" --node $nodeId)    
        if echo "$result4" | grep -q "$info"; then
            echo "install python3-ubs-engine-1.0.0.1-noarch.rpm success"
        else
            echo "install python3-ubs-engine-1.0.0.1-noarch.rpm fail"
        fi
        return_info4=$(get_version $nodeId "python3-ubs-engine")
        read -r version_python3 release_python3 <<< "$return_info4"
        return_values+=("$version_python3")
    done
    echo "return_values: ${return_values[@]}"

    if [ "${#return_values[@]}" -eq 8 ]; then
        for value in "${return_values[@]}"; do
            echo "checking value: $value"
            if [ "$value" = "false" ]; then
                echo "install rpm fail"
                exit 1
            fi
        done
    else
        echo "return_values length is not 8, exiting"
        exit 1
    fi
    echo "install rpms success"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    LOG_INFO "End to restore the test environment."
}

main "$@"