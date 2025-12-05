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

    set_smap_run_mode 1 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to set run mode"

    local vm_pid=$(get_vm_pid smap-2u4g-1)

    smap_mig_out_sync ${__var__remote_numa[0]} ${vm_pid} 0 2048 1 1 60000 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate out"

    wait_proc_mem_numa gt 60 0 ${vm_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage"

    smap_mig_out_sync ${__var__remote_numa[0]} ${vm_pid} 0 0 1 1 60000 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate out"

    wait_proc_mem_numa eq 60 0 ${vm_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    set_smap_run_mode 0

    cleanup_2m_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"