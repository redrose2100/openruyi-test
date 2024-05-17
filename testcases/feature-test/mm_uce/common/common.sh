#!/bin/bash
COMMON_LIB="${OET_PATH}"/libs/locallibs/common_lib.sh 
if [ -f "${COMMON_LIB}" ];then
    source "${OET_PATH}"/libs/locallibs/common_lib.sh
fi

GHES_REC="Hardware error from APEI Generic Hardware Error Source"
HARDWARE_ERROR="[Hardware Error]"
MEMORY_FAILURE="Memory failure"
IGNORED_ACTION="Ignored"

SIGBUS='signal 7'
LOG=./mm_uce.log
TMP_DIR=/tmp

function usage()
{
    echo "Usage: $0 [copyfromuser|copytouser|cow|all|getuser|putuser] [-c|--count] <value> [-d|--debug]"   
    echo "Usage: $0 [coredump] [-f|--filesystem] <ext4|pipefs|tmpfs|all> [-d|--debug]"   
    echo "Usage: $0 [-C|--check] [-d|--debug]"   
    echo "Usage: $0 [-h|--help]"   
    exit 1
}

function init()
{
        if ! ARGS=$(getopt -u -o "-hdc:fC" -l "count:,help,debug,filesystem:,check,all" -- "$@"); then
                usage
                exit 1
        fi

    IFS=' ' read -r -a args_array <<< "${ARGS}"
    set -- "${args_array[@]}"

    while true; do
        case $1 in
            -d|--debug)
                IS_DEBUG="true"
                shift
                ;;
            -h|--help)
                IS_HELP="true"
                break
                ;;
            -c|--count)
                count="$2"
                shift 2
                ;;
            -f|--filesystem)
                fs=$2
                shift 2
                ;;
            -C|--check)
                IS_CHECK="true"
                shift
                ;;
            copyfromuser|copytouser|cow|getuser|putuser|coredump|all)
                shift
                ;;
            --|'')
                shift
                break
                ;;
            *)
                usage
                ;;
        esac
    done
    
    [ "${IS_HELP}" == "true" ] && usage && exit 0
    [ "${IS_DEBUG}" == "true" ] && set -x
    [ -z "${count}" ] && count=1
    [ "${IS_CHECK}" == "true" ] && (user_mm_uce_test --check; exit 0)
    return 0
}

function do_copyfromuser()
{
    user_mm_uce_test --copyfrom  -c $count
}

function do_copytouser()
{
    enable_tracepoint
    user_mm_uce_test --copyto -c $count
}

function do_copyonwrite()
{
    user_mm_uce_test --copyonwrite  -c $count
}


function do_getuser()
{
    user_mm_uce_test --getuser -c $count
}

function do_putuser()
{
    enable_tracepoint
    user_mm_uce_test --putuser -c $count
}

function do_coredump_action()
{
    coredump_count=0
    while [ $coredump_count -lt $count ]
    do
        user_mm_uce_test --coredump
        ((coredump_count++))
    done
}

function set_coredump_tmpfs_path()
{
    path=$(mount|grep -E "\<tmpfs\>"|awk -F" " '{print $3}'|head -n 1) 
    echo "$path/core.%e-%p-%t-%c">/proc/sys/kernel/core_pattern   
}

function set_coredump_pipefs_path()
{
    pattern=$(cat /proc/sys/kernel/core_pattern)
    if [ "${pattern%"${pattern#?}"}" != "|" ];then
        if [ -f /usr/lib/systemd/systemd-coredump ];then
            echo '|/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h' > /proc/sys/kernel/core_pattern
	elif [ -e /usr/share/apport/apport ];then
            echo '|/usr/share/apport/apport -p%p -s%s -c%c -d%d -P%P -u%u -g%g -- %E;' > /proc/sys/kernel/core_pattern 
	fi
    fi
    path="/var/lib/systemd/coredump/"
    mkdir -p "${path}"
}

function set_coredump_ext4_path()
{
    path=$(mount|grep -E "\<ext4\>"|awk -F" "  '{print $3}'|head -n 1)
    [ -z "${path}" ] && echo "no ext4 fs" && exit 1
    echo "${path}/core.%e-%p-%c-%t">/proc/sys/kernel/core_pattern   
}

function clean_corefile()
{
    path=$1
    rm -f "${path}"/core.user_mm_uce_tes*
}

function do_coredump()
{
  ulimit -c unlimited
  echo '1'>/proc/sys/kernel/core_uses_pid
  case $fs in
  'tmpfs')
      set_coredump_tmpfs_path
      do_coredump_action
      clean_corefile "$path"
      ;;
  'pipefs'|'')
      set_coredump_pipefs_path
      do_coredump_action
      clean_corefile "$path"
      ;;
  'ext4')
      set_coredump_ext4_path
      do_coredump_action
      clean_corefile "$path"
      ;;
   'all')
      set_coredump_tmpfs_path
      do_coredump_action
      clean_corefile "$path"
      set_coredump_pipefs_path
      do_coredump_action
      clean_corefile "$path"
      set_coredump_ext4_path
      do_coredump_action
      clean_corefile "$path"
      ;;
   *)
      echo 'not support now'
      exit 1
      ;;
  esac
}

function load_mm_uce_module
{
    modprobe mm_uce_ioctl
}

function unload_mm_uce_module
{
    modprobe -r mm_uce_ioctl
}

function load_einj_module
{
    modprobe einj
}

function unload_einj_module
{
    modprobe -r einj
}

function enable_tracepoint()
{
    user_mm_uce_test -e
}

function do_all()
{
    load_mm_uce_module
    enable_tracepoint
    do_copyfromuser
    do_copytouser
    do_copyonwrite
    do_getuser
    do_putuser
    fs='all'
    do_coredump
}

# On some machines the trigger will be happend after 15 ~ 20 seconds, so
# when no proper log is read out, just executing wait-retry loop until
# timeout.
function check_ghes_rec_result()
{
    local timeout=25
    local sleep=5
    local time=0

    {
        echo -e "<<< OS/kernel version is as follows >>>\n"
        uname -a
    } >> "${LOG}"

    cat /etc/os-release >> "${LOG}"
    ARCH=$(uname -m)
    echo -e "\n<<< dmesg information is as follows >>>\n" >> "${LOG}"
    while [ $time -lt $timeout ]
    do
        dmesg -c >> "${LOG}" 2>&1
        if [ "${ARCH}" == "aarch64" ]; then
                     einj_error="${GHES_REC}"  
        elif [ "${ARCH}" == "x86_64" ];then
                     einj_error="${HARDWARE_ERROR}"  
        fi

        if grep -Fq "${einj_error}" "${LOG}"
        then
            echo -e "\nGHES record is OK\n" >> "${LOG}"
            echo 0 >> $TMP_DIR/error.$$
            return 0
        fi
        sleep $sleep
        time=$((time + sleep))
    done
    echo -e "\nGHES record is not expected\n" >> -a "${LOG}"
    echo 1 > $TMP_DIR/error.$$
    return 1
}

function check_memory_failure_recover_result()
{
    local timeout=25
    local sleep=5
    local time=0

    echo -e "\n<<< dmesg information is as follows >>>\n" >> "${LOG}"
    while [ $time -lt $timeout ]
    do
        dmesg -c >> "${LOG}" 2>&1
        if grep -F "${MEMORY_FAILURE}" "${LOG}"|grep -qEw "${RECOVERED_ACTION}|${IGNORED_ACTION}"
        then
            echo -e "\nMemory Failure record is OK\n" >> "${LOG}"
            echo 0 >> $TMP_DIR/error.$$
            return 0
        fi
        sleep $sleep
        time=$((time + sleep))
    done
    echo -e "\nMemory Failure record is not expected\n" >> "${LOG}"
    echo 1 > $TMP_DIR/error.$$
    return 1
}

function check_sigbus_result()
{
    local timeout=25
    local sleep=5
    local time=0

    while [ $time -lt $timeout ]
    do
        if grep -Fq "${SIGBUS}" "${LOG}"
        then
            echo -e "\nSigbus record is OK\n" >> "${LOG}"
            echo 0 >> $TMP_DIR/error.$$
            return
        fi
        sleep $sleep
        time=$((time + sleep))
    done
    echo -e "\nSigbus record is not expected\n" >> "${LOG}"
    echo 1 > $TMP_DIR/error.$$
    return 1
}

function disable_transparent_hugepage()
{
    echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
}

function recover_transparent_hugepage()
{
    echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
}

function do_mm_uce_check()
{
    user_mm_uce_test --check 2>&1
}

function do_mm_uce_cleanlog()
{
    rm -f "${LOG}"
    DNF_REMOVE "$@"
}

function do_mm_uce_test()
{
    if ! init "$@";then
        exit 1
    fi

    if [ $# -lt 1 ];then
        usage
    fi

    
    
    is_loaded=$(lsmod|grep einj)
    if [ "${is_loaded}" = "" ];then
        user_mm_uce_test --check
        exit 0
    fi
    
    load_mm_uce_module
    
    case $1 in
    'copyfromuser')
        do_copyfromuser
        ;;
    'copytouser')
        do_copytouser
        ;;
    'cow')
        do_copyonwrite
        ;;
    'coredump')
        do_coredump "$@"
        ;;
    'getuser')
        do_getuser
        ;;
    'putuser')
        do_putuser
        ;;
    'all')
        do_all
        ;;
    *)
        usage
        exit 1
        ;;
    esac
}
