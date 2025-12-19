source "$OET_PATH/libs/locallibs/common_lib.sh"
function convert_cli_output_to_json(){
    grep -vE '^-{4,}' | awk NF | awk '{$1=$1}1' | awk -v FS="[[:space:]]+" '
    BEGIN {
    print "[";
    first_record = 1;
    }
    NR == 1 {
        for (i = 1; i <= NF; i++){
        keys[i] = $i;
        }
    }
    NR > 1 {
        if (NF == 0) next;
        if (!first_record){
            printf ",\n";
        } else {
            first_record = 0;
        }
        printf "  {";
        for (i = 1; i <= NF; i++){
            value = $i;
            gsub(/"/, "\\\"", value);
            printf "\"%s\": \"%s\"", keys[i], value;
            if (i < NF) printf ", ";
        }
        printf "}";
    }
    END {
        print "\n]";
    }'
}

function get_slot_id(){
    local node=$1
    lcne_return=$(echo "$(P_SSH_CMD --cmd 'curl -X GET "http://127.0.0.1:34256/restconf/data/huawei-vbussw-service:vbussw-service/iou-infos"'\
      --node $node)" | grep '<slot-id>')
      nodeId=$(echo "$lcne_return" | awk -F'[<>]' 'NR==1 {print $3}')
      echo $nodeId
}

function get_topo_by_cli(){
    grep -vE '^-{4,}' | awk NF | awk '{$1=$1}1' | grep -v Links | awk -v FS="[[:space:]]+" '
    BEGIN {
    print "[";
    first_record = 1;
    }
    NR == 2 {
        for (i = 1; i <= NF; i++){
        keys[i] = $i;
        }
    }
    NR > 2 {
        if (NF == 0) next;
        if (!first_record){
            printf ",\n";
        } else {
            first_record = 0;
        }
        printf "  {";
        for (i = 1; i <= NF; i++){
            value = $i;
            gsub(/"/, "\\\"", value);
            printf "\"%s\": \"%s\"", keys[i], value;
            if (i < NF) printf ", ";
        }
        printf "}";
    }
    END {
        print "\n]";
    }'
}