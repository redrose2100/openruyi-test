source "$OET_PATH/testcases/cli-test/common/common_lib.sh"
source "$OET_PATH/testcases/cli-test/smap/common/smap_case_common.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."

    prepare_4k_env

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    start_smap_client

    rm -rf /dev/shm/smap_config

    smap_init 0 | xargs -i test 0 -eq {} -o -1 -eq {}
    CHECK_RESULT $? 0 0 "failed to init smap"

    test -f /dev/shm/smap_config
    CHECK_RESULT $? 0 0 "smap_config not exists"

    od -N 4 -t x1 /dev/shm/smap_config | sed -n '1p' | xargs -i test '0000000 01 00 08 00' == {}
    CHECK_RESULT $? 0 0 "unexpected smap_config"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."

    cleanup_4k_env

    LOG_INFO "Finish environment cleanup!"
}

main "$@"