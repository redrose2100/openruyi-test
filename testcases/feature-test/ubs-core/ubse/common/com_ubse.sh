source "$OET_PATH/libs/locallibs/common_lib.sh"
function get_package(){
    local node1=$1
    files=("ubs-engine-1.0.0-1.aarch64.rpm" "ubs-engine-client-libs-1.0.0-1.aarch64.rpm" "ubs-engine-client-devel-1.0.0-1.aarch64.rpm" "python3-ubs-engine-1.0.0-1.noarch.rpm")
    for file in "${files[@]}"; do
        result=$(P_SSH_CMD --cmd "ls /root/manager/$file" --node "$node1")
        if echo "$result" | grep -q "No such file or directory"; then
            echo "Fail $file not found on node $node1"
            exit 1
        else
            echo "Fail $file found on node $node1"
        fi
    done
}

function get_version(){
    local node1=$1
    local rpm_name=$2
    result=$(P_SSH_CMD --cmd "rpm -qi $rpm_name" --node "$node1")
    if echo "$result" | grep -q "Version"; then
        version=$(echo "$result" | grep "Version" | awk -F: '{print $2}' | tr -d ' ')
        release=$(echo "$result" | grep "Release" | awk -F: '{print $2}' | tr -d ' ')
        echo "$version $release"
    else
        echo "false false"
    fi 
}

function install_rpm(){
    local node1=$1
    return_values=()
    return_info1=$(get_version "$node1" "ubs-engine")
    read -r version_ubse_engine release_ubse_engine <<< "$return_info1"
    if [ "$version_ubse_engine" = "false" ]; then
         P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-1.0.0-1.aarch64.rpm" --node "$node1"
    fi
    return_info1=$(get_version "$node1" "ubs-engine")
    read -r version_ubse_engine release_ubse_engine <<< "$return_info1"
    return_values+=("$version_ubse_engine")

    return_info2=$(get_version "$node1" "ubs-engine-client-libs")
    read -r version_ubse_engine_libs release_ubse_engine_libs <<< "$return_info2"
    if [ "$version_ubse_engine_libs" = "false" ]; then
        P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-client-libs-1.0.0-1.aarch64.rpm" --node "$node1"
    fi
    return_info2=$(get_version "$node1" "ubs-engine")
    read -r version_ubse_engine_libs release_ubse_engine_libs <<< "$return_info1"
    return_values+=("$version_ubse_engine_libs")

    return_info3=$(get_version "$node1" "ubs-engine-client-devel")
    read -r version_ubse_engine_devel release_ubse_engine_devel <<< "$return_info3"
    if [ "$version_ubse_engine_devel" = "false" ]; then
        P_SSH_CMD --cmd "rpm -ivh /root/manager/ubs-engine-client-devel-1.0.0-1.aarch64.rpm" --node "$node1"
    fi
    return_info3=$(get_version "$node1" "ubs-engine")
    read -r version_ubse_engine_devel release_ubse_engine_devel <<< "$return_info1"
    return_values+=("$version_ubse_engine_devel")

    return_info4=$(get_version "$node1" "python3-ubs-engine")
    read -r version_python3 release_python3 <<< "$return_info4"
    if [ "$version_python3" = "false" ]; then
        P_SSH_CMD --cmd "rpm -ivh /root/manager/python3-ubs-engine-1.0.0-1.noarch.rpm" --node "$node1"
    fi
    return_info4=$(get_version "$node1" "python3-ubs-engine")
    read -r version_python3 release_python3 <<< "$return_info4"
    return_values+=("$version_python3")
    echo "${return_values[@]}"
}

function get_ubse_pid(){
    local nodeId=$1
    commond="ps -ef | grep '/usr/bin/ubse' | grep -v grep | awk '{print \$2}'"
    result=$(P_SSH_CMD --cmd "$commond" --node "$nodeId")
    if [ -n "$result" ]; then
        echo "$result"
    else
        echo "false"
    fi

}

function get_count(){
    local nodeId=$1
    local keyword=$2
    commond="journalctl -u ubse | grep -c '$keyword'"
    result=$(P_SSH_CMD --cmd "$commond" --node "$nodeId")
    if [ -z "$result" ]; then
        echo 0
    else
        num=$((result))
        echo $num
    fi
}

function exec_service(){
    local nodeId=$1
    local action=$2
    result=$(P_SSH_CMD --cmd "systemctl $action ubse" --node "$nodeId")
    echo $result
}

function check_ubse_status(){
    local nodeId=$1
    local active=$2
    local count=$3
    for i in $(seq 1 60); do
        if [ "$active" == "start" ] || [ "$active" == "restart" ]; then
            res=$(get_count "$nodeId" "started successfully")
        fi
        if [ "$active" == "stop" ]; then
            res=$(get_count "$nodeId" "Deactivated successfully")
        fi
        if [ "$res" -ne "$count" ]; then
            echo "true"
            return 0
        fi
        sleep 3
    done
    echo "false"
} 

function stop_ubse(){
    local nodeId=$1
    pid=$(get_ubse_pid "$nodeId") 
    if [ "$pid" != "false" ]; then
        count=$(get_count "$nodeId" "Deactivated successfully")
        exec_service "$nodeId" "stop"
        result=$(check_ubse_status "$nodeId" "stop" "$count")
        echo $result
    else
        echo "true"
        return 0
    fi
}

function start_ubse(){
    local nodeId=$1
    count=$(get_count "$nodeId" "started successfully")
    exec_service "$nodeId" "start"
    result=$(check_ubse_status "$nodeId" "start" "$count")
    if [ "$result" == "false" ]; then
        echo "false"
    fi
    pid=$(get_ubse_pid "$nodeId")
    echo $pid 
}

function display_node_role(){
    local nodeId=$1
    local role=$2
    result=$(P_SSH_CMD --cmd "ubsectl display cluster" --node "$nodeId")
    info=$(echo "$result" | sed 's/-//g' | awk 'NF' | tr -s ' ')
    extracted_date=$(awk 'NR>1 && $1 ~ /^[^$(]/ {print $1, $2}' <<< "$info")
    declare -A node_role_dict
    
    while IFS= read -r line; do
        nodeId_res=$(echo "$line" | awk -F'[()]' '{print $2}')
        role_res=$(echo "$line" | awk '{print $2}')
        if [ "$role_res" == "$role" ]; then 
            echo "$nodeId_res"
            return 0
        fi
    done <<< "$extracted_date"
    echo "false"
}

function return_nodes_by_role(){
    local nodeId=$1
    for i in $(seq 1 60); do
        masterId=$(display_node_role "$nodeId" "master")
        standbyId=$(display_node_role "$nodeId" "standby")
        if [ "$masterId" != "false" ] && [ "$standbyId" != "false" ]; then
            echo "$masterId $standbyId"
            return 0
        fi
        sleep 6
    done
    exit 1
}

function convert_cli_output_to_json(){
    grep -vE '^-{4,}' | awk NF | awk '{$1=$1}1' | awk -v FS="[[:space:]]+" '
    BEGIN {
        print "[";
        first = 1;
    }
    NR==1{
        for(i=1; i<=NF; i++){
            keys[i] = $i;
        }
    }
    NR>1 {
        if(NF == 0) next;
        if(!first){
            printf ",\n";
        } else {
            first = 0;
        }
        printf" {";
        for(i=1;i<=NF;i++){
            value=$i;
            gsub(/"/,"\\\"",value);
            printf "\"%s\":\"%s\"",keys[i],value;
            if(i<NF) printf ",";
        }
        printf "}";
        }
        END {
            printf "\n]\n";
        }'
}

function check_memory() {
    local nodeId=$1
    result=$(P_SSH_CMD --cmd "ubsectl check memory" --node "$nodeId")
    echo "$result"
}

function check_mem_nodes_num() {
    local nodeId=$1
    local nodeSize=$2
    for _ in $(seq 1 60); do
        ok_num=$(check_memory "$nodeId" | grep -v nok | grep -c ok)
        if [ "$ok_num" == $((nodeSize)) ]; then
            echo "true"
            return 0
        fi
        sleep 6
    done
    echo "false"
    exit 1
}

function mem_borrow_common() {
    local nodeId=$1
    local cmd=$2
    local cmd_list="expect -c '
            spawn python ${ubse_script_dir}/ubse_mem_app.py
            expect \"ubse_mem_app>\"
            send \"${cmd}\n\"
            expect \"ubse_mem_app>\"
            send \"exit\n\"
            expect eof
            '"
    result=$(P_SSH_CMD --node "${nodeId}" --cmd "${cmd_list}")
    echo "$result"
}