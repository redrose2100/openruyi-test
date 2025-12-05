source "$OET_PATH/testcases/cli-test/common/common_lib.sh"
source "$OET_PATH/testcases/cli-test/smap/common/smap_case_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."

    prepare_2m_env

    set_case_var "local_numa" $(get_local_numa)
    set_case_var "remote_numa" $(get_remote_numa)

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    smap_init 1 | xargs -i test 0 -eq {} -o -1 -eq {}
    CHECK_RESULT $? 0 0 "failed to init smap"

    start_vm smap-2u4g-1

    local vm_pid=$(get_vm_pid smap-2u4g-1)

    smap_remove ${vm_pid} 1 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to remove process"

    smap_remove_process_tracking ${vm_pid} 1 0 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to remove process tracking"

    sleep 10

    test -f /proc/${vm_pid}_t/tracking_info
    CHECK_RESULT $? 0 1 "unexpected tracking_info file"

    smap_add_process_tracking ${vm_pid} 50 1 0 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to add process tracking"

    sleep 10

    test -f /proc/${vm_pid}_t/tracking_info
    CHECK_RESULT $? 0 0 "tracking_info file not exists"

    smap_remove_process_tracking ${vm_pid} 1 0 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to remove process tracking"

    sleep 10

    test -f /proc/${vm_pid}_t/tracking_info
    CHECK_RESULT $? 0 1 "unexpected tracking_info file"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    smap_remove_process_tracking $(get_vm_pid smap-2u4g-1) 1 0

    cleanup_2m_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"