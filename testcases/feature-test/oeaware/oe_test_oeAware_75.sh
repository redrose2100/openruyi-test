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
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn: analysis config 'dynamic_smt:threshold\([^)]+\)' value must be a number"
    CHECK_RESULT $? 0 1 "Check SMT threshold failed."
    sed -i '/^dynamic_smt:/,/^  /{ /threshold:/ s/\(threshold:\s*\)[^#]*\s*/\1IllegalInput / }' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn: analysis config 'dynamic_smt:threshold\([^)]+\)' value must be a number"
    CHECK_RESULT $? 0 0 "Check SMT threshold failed."
    sed -i '/^dynamic_smt:/,/^  /{ /threshold:/ s/\(threshold:\s*\)[^#]*\s*/\11i45lA\& / }' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn: analysis config 'dynamic_smt:threshold\([^)]+\)' value must be a number"
    CHECK_RESULT $? 0 0 "Check SMT threshold failed."
    sed -i '/^dynamic_smt:/,/^  /{ /threshold:/ s/\(threshold:\s*\)[^#]*\s*/\1$#\{\]?\> / }' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 2>&1 | grep -E "Warn: analysis config 'dynamic_smt:threshold\([^)]+\)' value must be a number"
    CHECK_RESULT $? 0 0 "Check SMT threshold failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
