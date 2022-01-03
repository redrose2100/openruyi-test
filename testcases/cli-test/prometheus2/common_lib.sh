#!/usr/bin/bash

source "../common/common_lib.sh"

function is_running() {
    if pgrep -x "prometheus" >/dev/null; then
        return 0
    else
        return 1
    fi
}

function clear_env() {
    if is_running; then
        LOG_INFO "Prometheus is running."
        LOG_INFO "Start to terminate it."
        kill_process
    fi

    if [ -d "./data" ]; then
        rm -rf ./data
    fi

    if [ -f "./log" ]; then
        rm -rf ./log
    fi
}

function kill_process() {
    if is_running; then
        result="$(kill -9 "$(pgrep -x 'prometheus')")"
        if pgrep -x "prometheus" >/dev/null; then
            LOG_WARN "Failed to terminate prometheus."
        else
            LOG_INFO "Succeed to terminate prometheus."
        fi
    fi

}

function wait_for_ready() {
    LOG_INFO "Waiting for Prometheus to be ready."
    while ! grep "Server is ready to receive web requests." ./log; do
        sleep 1s
    done
    LOG_INFO "Prometheus is ready."
}
