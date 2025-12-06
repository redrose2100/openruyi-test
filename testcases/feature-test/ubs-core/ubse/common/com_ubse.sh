#!/usr/bin/bash

source "$OET_PATH/libs/locallibs/common_lib.sh"

ubse_script_dir="$OET_PATH/testcases/feature-test/ubs-core/ubse/common"

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
    echo "$result"
}

function check_ubse_status(){
    local nodeId=$1
    local active=$2
    local count=$3
    for _ in $(seq 1 60); do
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
        echo "$result"
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
    echo "$pid"
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