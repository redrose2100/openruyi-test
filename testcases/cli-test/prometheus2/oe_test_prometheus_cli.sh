#!/usr/bin/bash

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL prometheus2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {

    function kill_process() {
        kill -9 "$(pgrep -x 'prometheus')" >/dev/null
        if pgrep -x "prometheus" >/dev/null; then
            LOG_INFO "Failed to terminate prometheus."
        else
            LOG_INFO "Succeed to terminate prometheus."
        fi
    }

    function wait_for_ready() {
        LOG_INFO "Waiting for prometheus is ready."
        while ! grep "Server is ready to receive web requests." ./log; do
            echo 'wait for server' >/dev/null
        done
        LOG_INFO "Prometheus is ready."
    }

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
    touch ./log
    prometheus --config.file="prometheus.yml" >./log 2>&1 &
    wait_for_ready
    current_job_name="$(curl -s 'http://localhost:9090/config' | grep 'job_name' | awk '{print $3}')"
    echo current job name is $current_job_name
    [[ "${current_job_name}" = "test_prometheus_cli" ]]
    CHECK_RESULT $? 0 0 "Failed to use specific config file."
    LOG_INFO "Finish to check flag: --config.file"
    kill_process

    LOG_INFO "Start to check flag: --web.listen-address"
    touch ./log
    free_port="$(GET_FREE_PORT localhost)"
    prometheus --web.listen-address="0.0.0.0:$free_port" >./log 2>&1 &
    wait_for_ready
    curl -s "http://localhost:$free_port" | grep 'Found'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.listen-address'
    kill_process

    LOG_INFO "Start to check flag: --web.external-url"
    touch ./log
    prometheus --web.external-url="the_external_url" >./log 2>&1 &
    wait_for_ready
    curl -s 'localhost:9090' | grep '<a href="/the_external_url">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.external-url'
    kill_process

    LOG_INFO "Start to check flag: --web.route-prefix"
    touch ./log
    prometheus --web.route-prefix="the_prefix" >./log 2>&1 &
    wait_for_ready
    curl -s 'localhost:9090' | grep '<a href="/the_prefix">Found</a>.'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.route-prefix'
    kill_process

    LOG_INFO "Start to check flag: --web.page-title"
    touch ./log
    prometheus --web.page-title="the title" >./log 2>&1 &
    wait_for_ready
    curl -s 'localhost:9090/config' | grep '<title>the title</title>'
    CHECK_RESULT $? 0 0 'Failed to use flag: --web.page-title'
    kill_process

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    rm ./log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
