#!/usr/bin/bash

source "./common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    clear_env
    DNF_INSTALL prometheus2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {

    LOG_INFO "Start testing..."

    if ! IS_FREE_PORT 9090; then
        LOG_WARN "prometheus default bind port 9090 is not available!"
        LOG_WARN "Please free the port 9090 for prometheus."
        exit 126
    fi

    LOG_INFO "Start to check flag: --version"
    prometheus --version
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    LOG_INFO "Finish to check flag: --version"

    LOG_INFO "Start to check flag: --help"
    prometheus --help
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    LOG_INFO "Finish to check flag: --help"

    LOG_INFO "Start to check flag: --config.file"
    LOG_INFO "Start prometheus with sepecific config file."
    start_process --config.file="prometheus.yml"
    wait_for_ready
    curl -s "localhost:9090/config" | grep 'job_name: test_prometheus_cli'
    CHECK_RESULT $? 0 0 "Failed to use specific config file."
    LOG_INFO "Finish to check flag: --config.file"
    clear_env

    LOG_INFO "Start to check flag: --web.listen-address"
    free_port="$(GET_FREE_PORT localhost)"
    start_process --web.listen-address="0.0.0.0:$free_port"
    wait_for_ready "$free_port"
    curl -s "http://localhost:$free_port" | grep 'Found'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.listen-address'
    clear_env

    LOG_INFO "Start to check flag: --web.read-timeout=5m"
    start_process --web.read-timeout=5m
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.read-timeout=5m'
    clear_env

    LOG_INFO "Start to check flag: --web.max-connections=512"
    start_process --web.max-connections=512
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.max-connections=512'
    clear_env

    LOG_INFO "Start to check flag: --web.external-url"
    start_process --web.external-url="the_external_url"
    wait_for_ready
    curl -s 'http://localhost:9090' | grep '<a href="/the_external_url">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.external-url'
    clear_env

    LOG_INFO "Start to check flag: --web.route-prefix"
    start_process --web.route-prefix="the_prefix"
    wait_for_ready
    curl -s 'http://localhost:9090' | grep '<a href="/the_prefix">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.route-prefix'
    clear_env

    LOG_INFO "Start to check flag: --web.user-assets"
    start_process --web.user-assets=./
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.user-assets'
    clear_env

    LOG_INFO "Start to check flag: --web.enable-lifecycle"
    start_process --web.enable-lifecycle
    wait_for_ready
    curl -s -X POST 'http://localhost:9090/-/quit'
    CHECK_RESULT "$(pgrep 'prometheus')" 1 0 'Failed to use flag: --web.enable-lifecycle'
    clear_env

    LOG_INFO "Start to check flag: --web.enable-admin-api"
    start_process --web.enable-admin-api
    wait_for_ready
    curl -s -X POST 'http://localhost:9090/api/v1/admin/tsdb/snapshot' | grep '"status":"success"'
    CHECK_RESULT $? 0 0 'Failed to use flag:  --web.enable-admin-api'
    clear_env

    LOG_INFO "Start to check flag: --web.console.templates"
    start_process --web.console.templates=./
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.console.templates'
    clear_env

    LOG_INFO "Start to check flag:  --web.console.libraries"
    start_process --web.console.libraries=./
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.console.libraries'
    clear_env

    LOG_INFO "Start to check flag: --web.page-title"
    start_process --web.page-title="the title"
    wait_for_ready
    curl -s 'http://localhost:9090/config' | grep '<title>the title</title>'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.page-title'
    clear_env

    LOG_INFO "Start to check flag: --web.cors.origin"
    start_process --web.cors.origin=".*"
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.cors.origin'
    clear_env

    LOG_INFO "Start to check flag: --storage.tsdb.path"
    start_process --storage.tsdb.path="./the_data/"
    wait_for_ready
    CHECK_RESULT "$(ls ./the_data | grep -cE 'chunks_head|lock|queries.active|wal')" 4 0 'Failed to use flag: --storage.tsdb.path'
    clear_env

    LOG_INFO "Start to check flag: --storage.tsdb.retention"
    start_process --storage.tsdb.retention=1m
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention'
    clear_env

    LOG_INFO "Start to check flag: --storage.tsdb.retention.time"
    start_process --storage.tsdb.retention.time=1m
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention.time'
    clear_env

    LOG_INFO "Start to check flag:  --storage.tsdb.retention.size"
    start_process --storage.tsdb.retention.size=1MB
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.retention.size'
    clear_env

    LOG_INFO "Start to check flag: --storage.tsdb.no-lockfile"
    start_process --storage.tsdb.no-lockfile
    wait_for_ready
    CHECK_RESULT "$(ls ./data | grep -cE 'lock')" 0 0 'Failed to use flag: --storage.tsdb.no-lockfile'
    clear_env

    LOG_INFO "Start to check flag: --storage.tsdb.allow-overlapping-blocks"
    start_process --storage.tsdb.allow-overlapping-blocks
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.allow-overlapping-blocks'
    clear_env

<<<<<<< HEAD
    LOG_INFO "Start to check flag: --storage.tsdb.wal-compression"
    start_process --storage.tsdb.wal-compression
    CHECK_RESULT $? 0 0 'Failed to use flag: --storage.tsdb.wal-compression'
    clear_env

=======
>>>>>>> 709085f9e51ddf0c38450662d93d34ddf4e7ee66
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    clear_env
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
