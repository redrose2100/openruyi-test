#! /bin/bash
# @Author: Ethan-Zhang
# @Data: 2021-08-05 22:02:00
# @Email: ethanzhang55@outlook.com
# @License: Mulan PSL v2

SCRIPT_PATH=$(
    cd "$(dirname "$0")" || exit 1
    pwd
)
MUGEN_PATH=$(dirname $SCRIPT_PATH)

INTERVAL=10
SUCCEED=0
FAIL=0

function usage() {
    printf "Usage:  \n
    This is a lisener to achieve and post latest statistic of results
    \n
    -t:		configuration the number of intervala seconds of posting messages\n
    -p:		configuration the URL of the server for posting messages\n
    -h:		help
    \n
    Example: 
        post the latest results every second to 127.0.0.1/test:
          bash results_lisener.sh -t 1 -p 127.0.0.1/test
        
	post the latest results every hour to 127.0.0.1/test:
	  bash results_lisener.sh -t 3600 -p 127.0.0.1/test
        \n
"
}

function run_listener() {
    while :
    do
        if [[ -d ${MUGEN_PATH}/results ]];then	
	    if [[ -d ${MUGEN_PATH}/results/succeed ]];then
	        SUCCEED=$(ls -l "${MUGEN_PATH}/results/succeed" | grep '^-' | wc -l)
	    else
		SUCCEED=0
	    fi
	    if [[ -d ${MUGEN_PATH}/results/failed ]];then
	        FAIL=$(ls -l "${MUGEN_PATH}/results/failed" | grep '^-' | wc -l)
	    else
		FAIL=0
	    fi
        else
	    SUCCEED=0
	    FAIL=0
        fi
	
        curl -d "{'succeed': $SUCCEED, 'fail': $FAID}" -H 'Content-Type: application/json'  -X POST $@ 
	
	sleep ${INTERVAL}s

    done
}

while getopts "t:p:h" option;do
	case $option in
	t)
	    if echo "$@" | grep -qe ' *-p *';then
	        INTERVAL=$OPTARG
	    else
	        usage
                exit 1
            fi		
	    ;;
	p)
		[[ ! -z $(echo "$@" | grep -e ' *-h *') ]] && {
	        usage
	        exit 1
	    }
	    if echo "$@" | grep -qe '^ *-p *.* *-t *';then
		INTERVAL=$(echo "$@" | awk {'print $NF'})
		[[ -z $(echo $INTERVAL | grep -e '^[[:digit:]]*$') ]] && {
                    usage
		    exit 1
		}
	    fi
	    url=$OPTARG
	    run_listener $url
            ;;
        h)
	    usage
	    exit 1
	    ;;
        *)
	    usage
	    exit 1
	    ;;
	esac
done


