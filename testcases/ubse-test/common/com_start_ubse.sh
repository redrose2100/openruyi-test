source "$OET_PATH/libs/locallibs/common_lib.sh"
function start_ubse(){
    local node1=$1
    local count=$(get_count $node1 "started successfully")
    result=$(P_SSH_CMD --cmd "systemctl restart ubse" --node $node1)
    if ! check_ubse_status $node1 "restart" "$count"; then
        echo "false"
        return 1
    fi
    local pid=$(get_pid $node1)
    if [ -n "$pid" ]; then
        echo "$pid"
        return 0
    else
        echo "false"
        return 1
    fi
}
function get_count(){
    local node1=$1
    local keyword=$2
    result=$(P_SSH_CMD --cmd "journalctl -u ubse | grep -c '$keyword'" --node $node1)
    if [[ -z "$result" ]]; then
        echo 0
    else
       res=$(echo "$result" | tr -d '\r\n')
       if [[ $res =~ ^[0-9]+$ ]];then
            echo "$res"
       else
            echo 0
       fi
    fi
}
function check_ubse_status(){
    local node1=$1
    local active=$2
    local count=$3
    local i
    for i in {1..60}; do
        local res
        if [ "$active" = "start" ] || [ "$active" = "restart" ]; then
            res=$(get_count "$node1" "started successfully")
        elif [ "$active" = "stop" ]; then
            res=$(get_count "$node1" "Deactivated successfully")
        else
            echo "invalid parameter '$active'"
            return 1
        fi
        if [ "$res" -ne "$count" ]; then
            return 0
        fi
        sleep 3
    done
    return 1
}
function get_pid(){
    local node1=$1
    result=$(P_SSH_CMD --cmd "ps -ef | grep '/usr/bin/ubse' | grep -v grep |awk '{print \$2}' | head -1" --node $node1)
    echo "$result"
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

