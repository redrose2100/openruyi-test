#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	systemctl restart oeaware
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	oeawarectl -e numa_sched_tune | grep "Instance enabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	cat /sys/kernel/debug/sched_features | grep "PARAL"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	oeawarectl -d numa_sched_tune | grep "Instance disabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	cat /sys/kernel/debug/sched_features | grep "NO_PARAL"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"

	echo PARAL > /sys/kernel/debug/sched_features
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	oeawarectl -e numa_sched_tune | grep "Instance enabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	tail -n 10 /var/log/oeAware/server.log | grep "\[NUMA_SCHED\] numa sched is already enabled on system"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	oeawarectl -d numa_sched_tune | grep "Instance disabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	cat /sys/kernel/debug/sched_features | grep "PARAL"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"

	echo NO_PARAL > /sys/kernel/debug/sched_features
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	oeawarectl -e numa_sched_tune | grep "Instance enabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	cat /sys/kernel/debug/sched_features | grep "PARAL"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	oeawarectl -d numa_sched_tune | grep "Instance disabled successfully."
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	cat /sys/kernel/debug/sched_features | grep "NO_PARAL"
	CHECK_RESULT $? 0 0 "Check disabling numa failed"
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	LOG_INFO "End to restore the test environment."
}

main "$@"
