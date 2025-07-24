#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ["${NODE1_FRAME}"="x86_64"];then
        echo "the environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local cpu_count=$(lscpu | grep -w 'CPU:' | awk '{print $2}')
    local thresh=70
    sed -i "/dynamic_smt:/ { n; s/\( *threshold:\)[[:space:]]*.*/  threshold: ${thresh}/; }" /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 | grep "use dynamic smt"
    CHECK_RESULT $? 0 0 "Check SMT suggestion failed."
    stress-ng --cpu $(( cpu_count*(thresh+3)/100 )) -t 30 &
    oeawarectl analysis -t 3 | grep "use dynamic smt"
    CHECK_RESULT $? 0 1 "Check SMT suggestion failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml 
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
