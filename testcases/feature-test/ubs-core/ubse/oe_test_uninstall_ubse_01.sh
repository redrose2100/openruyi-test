sed -i 's/\r$//' ./common/com_ubse.sh
source ./common/com_ubse.sh
node_ids=(1 2)
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    install_rpm "1"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    info="Cleaning up / removing"
    return_values=()
    result1=$(P_SSH_CMD --cmd "rpm -evh python3-ubs-engine" --node "1")
    if echo "$result1" | grep -q "$info"; then
        echo "uninstall python3-ubs-engine success"
    else
        echo "uninstall python3-ubs-engine fail"
    fi
    return_info1=$(get_version "1" "python3-ubs-engine")
    read -r version_python3 release_python3 <<< "$return_info1"
    echo "Version: $version_python3"
    echo "Release: $release_python3"
    return_values+=("$version_python3")
    
    result2=$(P_SSH_CMD --cmd "rpm -evh ubs-engine-client-devel" --node "1")
    if echo "$result2" | grep -q "$info"; then
        echo "uninstall ubs-engine-client-devel success"
    else
        echo "uninstall ubs-engine-client-devel fail"
    fi
    return_info2=$(get_version "1" "ubs-engine-client-devel")
    read -r version_ubs_engine_devel release_ubs_engine_devel <<< "$return_info2"
    echo "Version: $version_ubs_engine_devel"
    echo "Release: $release_ubs_engine_devel"
    return_values+=("$version_ubs_engine_devel")

    result3=$(P_SSH_CMD --cmd "rpm -evh ubs-engine-client-libs" --node "1")
    if echo "$result3" | grep -q "$info"; then
        echo "uninstall ubs-engine-client-libs success"
    else
        echo "uninstall ubs-engine-client-libs fail"
    fi
    return_info3=$(get_version "1" "ubs-engine-client-libs")
    read -r version_ubs_engine_libs release_ubs_engine_libs <<< "$return_info3"
    echo "Version: $version_ubs_engine_libs"
    echo "Release: $release_ubs_engine_libs"
    return_values+=("$version_ubs_engine_libs")

    result4=$(P_SSH_CMD --cmd "rpm -evh ubs-engine" --node "1")    
    if echo "$result4" | grep -q "$info"; then
        echo "uninstall ubs-engine success"
    else
        echo "uninstall ubs-engine fail"
    fi
    return_info4=$(get_version "1" "ubs-engine")
    read -r version_ubs_engine release_ubs_engine <<< "$return_info4"
    echo "Version: $version_ubs_engine"
    echo "Release: $release_ubs_engine"
    return_values+=("$version_ubs_engine")

    if [ "${#return_values[@]}" -eq 4 ]; then
        for value in "${return_values[@]}"; do
            if [ "$value" != "false" ]; then
                echo "install rpm fail"
                exit 1
            fi
        done
    else
        echo "return_values length is not 4, exiting"
        exit 1
    fi
    echo "uninstall rpms success"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    install_rpm "1"
    LOG_INFO "End to restore the test environment."
}

main "$@"