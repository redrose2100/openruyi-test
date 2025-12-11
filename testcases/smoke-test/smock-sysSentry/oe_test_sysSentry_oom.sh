source "./comm/lib.sh"
set -x

function pre_test(){
    pre_oom_env
}
function run_test(){
    start_RA oom
    CHECK_RESULT $? 0 0
    # /root/mugen/testcases/cli-test/sysSentry/RA/oom &  #后面改一下
    echo 50000 | sudo tee /proc/sys/vm/nr_hugepages
    # oom_pid=$!

    check_oom_dmesg 0 0
    CHECK_RESULT $? 0 0

    # kill -9 $oom_pid
    check_RA_oom 0 0
    CHECK_RESULT $? 0 0

    check_alarmd 1005 71 " " 3
    CHECK_RESULT $? 0 0

    check_oom_sentry_msg_monitor 0 0 true
    CHECK_RESULT $? 0 0
 
}
function post_test(){
    clean_sysSentry_message

}

main "$@"