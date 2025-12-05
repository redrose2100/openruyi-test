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

    set_smap_remote_numa_info $(get_unique_vm_numa smap-2u4g-1) ${__var__remote_numa[0]} 10000 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to set remote numa info"

    smap_mig_out ${__var__remote_numa[0]} ${vm_pid} 25 1 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate out"

    wait_proc_mem_numa gt 60 0 ${vm_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage"

    smap_query_vm_freq ${vm_pid} 1 4096 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to query vm freq"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    cleanup_2m_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"