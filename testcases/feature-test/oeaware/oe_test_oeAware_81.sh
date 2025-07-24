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
    oeawarectl -e dynamic_smt_tune -threshold 0 | grep "Instance enabled successfully"
    grep -q "^0" /proc/sys/kernel/sched_util_ratio
    CHECK_RESULT $? 0 0 "Check SMT by threshold failed"
    oeawarectl -d dynamic_smt_tune | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Check SMT by threshold failed"
    oeawarectl -e dynamic_smt_tune -threshold -1 2>&1 | grep "Instance enabled failed, because the threshold range is \[0, 100\], but is -1"
    CHECK_RESULT $? 0 0 "Check SMT beyond threshold failed"
    oeawarectl -d dynamic_smt_tune | grep "Instance disabled successfully"
    oeawarectl -e dynamic_smt_tune -threshold 101 2>&1  | grep "Instance enabled failed, because the threshold range is \[0, 100\], but is 101"
    CHECK_RESULT $? 0 0 "Check SMT beyond threshold failed"
    oeawarectl -d dynamic_smt_tune | grep "Instance disabled successfully"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
