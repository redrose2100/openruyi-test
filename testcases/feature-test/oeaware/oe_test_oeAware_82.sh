#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    systemctl restart oeaware
    if ["${NODE1_FRAME}"="x86_64"];then
        echo "the environment does not support testing"
        exit 255
    fi
    if ["$(cat /sys/devices/system/cpu/smt/active)"="1"];then
        echo "the environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e dynamic_smt_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Check SMT failed"
    oeawarectl -d dynamic_smt_tune | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Check SMT failed"
    oeawarectl -e dynamic_smt_tune -threshold "IllegalInputs" | grep "Instance enabled failed, because threshold value is not a integer"
    CHECK_RESULT $? 0 0 "Check SMT invalid threshold failed"
    oeawarectl -d dynamic_smt_tune
    oeawarectl -e dynamic_smt_tune -threshold "%1!4@5\(IA?" | grep "Instance enabled failed, because threshold value is not a integer"
    CHECK_RESULT $? 0 0 "Check SMT invalid threshold failed"
    oeawarectl -d dynamic_smt_tune
    oeawarectl -e dynamic_smt_tune -threshold "@\>1\&:\}!?" | grep "Instance enabled failed, because threshold value is not a integer"
    CHECK_RESULT $? 0 0 "Check SMT invalid threshold failed"
    oeawarectl -d dynamic_smt_tune
    oeawarectl -e dynamic_smt_tune -threshold 191.801 | grep "Instance enabled failed, because threshold value is not a integer"
    CHECK_RESULT $? 0 0 "Check SMT invalid threshold failed"
    oeawarectl -d dynamic_smt_tune
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
