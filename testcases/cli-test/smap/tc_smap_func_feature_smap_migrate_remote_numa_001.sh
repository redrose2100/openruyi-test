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

    set_smap_remote_numa_info $(get_unique_vm_numa smap-2u4g-1) ${__var__remote_numa[0]} 10000 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to set remote numa info"

    local vm_pid=$(get_vm_pid smap-2u4g-1)

    smap_mig_out ${__var__remote_numa[0]} ${vm_pid} 100 1 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate out"

    wait_proc_mem_numa gt 60 0 ${vm_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage"

    smap_enable_process_migrate 0 1 1 ${vm_pid} | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to disable process migrate"

    set_smap_remote_numa_info $(get_unique_vm_numa smap-2u4g-1) ${__var__remote_numa[1]} 10000 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to set remote numa info"

    local mem_ids=$(get_mem_ids ${__var__remote_numa[0]})

    smap_migrate_remote_numa ${__var__remote_numa[0]} ${__var__remote_numa[1]} ${#mem_ids[@]} ${mem_ids[@]} | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate pid form ${__var__remote_numa[0]} to ${__var__remote_numa[1]}"

    smap_enable_process_migrate 1 1 1 ${vm_pid} | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to enable process migrate"

    wait_proc_mem_numa eq 60 0 ${vm_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage in numa:${__var__remote_numa[0]}"

    wait_proc_mem_numa gt 60 0 ${vm_pid} ${__var__remote_numa[1]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage in numa:${__var__remote_numa[1]}"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    smap_enable_process_migrate 1 1 1 ${vm_pid}

    cleanup_2m_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"