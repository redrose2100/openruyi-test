#!/usr/bin/bash

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	systemctl restart oeaware
	# cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	oeawarectl analysis -t 3 | grep "use dynamic smt"
	CHECK_RESULT $? 0 0 "Check SMT suggestion failed."
	local cpu_count=$(lscpu | grep -w 'CPU:' | awk '{print $2}')
	local thresh=$(awk '/dynamic_smt:/ {getline; print $2}' /etc/oeAware/analysis_config.yaml)
	stress-ng --cpu $(( cpu_count*(thresh+3)/100 )) -t 30 &
	# stress-ng --cpu $cpu_count -t 30 &
	oeawarectl analysis -t 3 | grep "use dynamic smt"
	CHECK_RESULT $? 0 1 "Check SMT suggestion failed."
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	
	LOG_INFO "End to restore the test environment."
}

main "$@"
