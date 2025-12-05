source "$OET_PATH/testcases/cli-test/common/common_lib.sh"
source "$OET_PATH/testcases/cli-test/smap/common/smap_case_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."

    prepare_4k_env

    set_case_var "local_numa" $(get_local_numa)
    set_case_var "remote_numa" $(get_remote_numa)

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    smap_init 0 | xargs -i test 0 -eq {} -o -1 -eq {}
    CHECK_RESULT $? 0 0 "failed to init smap"

    start_redis 6379 ${__var__local_numa[0]}

    local redis_pid=$(get_redis_pid 6379)

    start_redis_benchmark 6379 $((10 ** 11)) 128 $((64 * 1024)) $((8 * 1024)) 8
    wait_proc_mem_numa ge 180 512 ${redis_pid} ${__var__local_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected local numa usage"

    set_smap_remote_numa_info ${__var__local_numa[0]} ${__var__remote_numa[0]} 256 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to set remote numa info"

    smap_mig_out ${__var__remote_numa[0]} ${redis_pid} 100 0 | xargs -i test 0 -eq {}
    CHECK_RESULT $? 0 0 "failed to migrate out"

    wait_proc_mem_numa gt 60 240 ${redis_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 0 "unexpected remote numa usage"

    wait_proc_mem_numa gt 60 256 ${redis_pid} ${__var__remote_numa[0]}
    CHECK_RESULT $? 0 1 "unexpected remote numa usage"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    cleanup_4k_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"