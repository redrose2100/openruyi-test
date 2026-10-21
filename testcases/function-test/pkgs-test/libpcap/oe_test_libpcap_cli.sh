#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-08-04
# @License   :   Mulan PSL v2
# @Desc      :   libpcap CLI tools (pcap-config) option validation
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "libpcap libpcap-devel"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 1: Verify pcap-config binary is installed
	command -v pcap-config
	CHECK_RESULT $? 0 0 "pcap-config binary not found"

	# Step 2: Verify pcap-config --help shows usage information
	pcap-config --help 2>&1 | grep -q "Usage"
	CHECK_RESULT $? 0 0 "pcap-config --help failed"

	# Step 3: Verify pcap-config --version outputs a version string
	libpcap_devel_version=$(rpm -qa libpcap-devel | awk -F"-" '{print $3}')
	if [ -z "$libpcap_devel_version" ]; then
		LOG_WARN "libpcap-devel version not found, skipping version check"
	else
		pcap-config --version | grep -q "${libpcap_devel_version}"
		CHECK_RESULT $? 0 0 "pcap-config --version did not output version"
	fi

	# Step 4: Verify pcap-config --libs outputs linker flags containing -lpcap
	pcap-config --libs | grep -q '\-lpcap'
	CHECK_RESULT $? 0 0 "pcap-config --libs did not output -lpcap"

	# Step 5: Verify pcap-config --additional-libs runs without error (output may be empty)
	pcap-config --additional-libs >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "pcap-config --additional-libs failed"

	# Step 6: Verify pcap-config --static --libs outputs -lpcap
	pcap-config --static --libs | grep -q '\-lpcap'
	CHECK_RESULT $? 0 0 "pcap-config --static --libs did not output -lpcap"

	# Step 7: Verify pcap-config --static-pcap-only --libs outputs -lpcap
	pcap-config --static-pcap-only --libs | grep -q '\-lpcap'
	CHECK_RESULT $? 0 0 "pcap-config --static-pcap-only --libs did not output -lpcap"

	# Step 8: Verify pcap-config (no arguments) exits successfully without crashing
	pcap-config >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "pcap-config without args failed"

	# Step 9: Verify pcap-config --static --additional-libs runs without error
	pcap-config --static --additional-libs >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "pcap-config --static --additional-libs failed"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
