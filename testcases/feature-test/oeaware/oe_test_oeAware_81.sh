#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	systemctl restart oeaware
	
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	oeawarectl -e dynamic_smt_tune -threshold 0
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
	
	LOG_INFO "End to restore the test environment."
}

main "$@"
