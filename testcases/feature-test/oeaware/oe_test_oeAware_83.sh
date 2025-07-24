#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	systemctl restart oeaware
	
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	oeawarectl -e dynamic_smt_tune | grep "Instance enabled successfully"
	CHECK_RESULT $? 0 0 "Check SMT failed"
	oeawarectl -d dynamic_smt_tune
	CHECK_RESULT $? 0 0 "Check SMT failed"
	oeawarectl -e dynamic_smt_tune -d 1 | grep -E 'Instance enabled failed, because params .*? invalid.'
	CHECK_RESULT $? 0 0 "Check SMT invalid params failed"
	oeawarectl -e dynamic_smt_tune -i 1 | grep -E 'Instance enabled failed, because params .*? invalid.'
	CHECK_RESULT $? 0 0 "Check SMT invalid params failed"
	oeawarectl -e dynamic_smt_tune -e 1 | grep -E 'Instance enabled failed, because params .*? invalid.'
	CHECK_RESULT $? 0 0 "Check SMT invalid params failed"
	oeawarectl -e dynamic_smt_tune -threshold_test 1 | grep -E 'Instance enabled failed, because params .*? invalid.'
	CHECK_RESULT $? 0 0 "Check SMT invalid params failed"
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	
	LOG_INFO "End to restore the test environment."
}

main "$@"
