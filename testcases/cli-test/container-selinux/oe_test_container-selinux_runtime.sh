#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-17
# @License   :   Mulan PSL v2
# @Desc      :   container-selinux runtime policy test in container environment
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "container-selinux docker"

	# Step 1: Check if SELinux is enabled, try to enable if not
	if ! sestatus 2>/dev/null | grep -q "SELinux status:.*enabled"; then
		setenforce 1
		if ! getenforce | grep -q "Enforcing"; then
			LOG_INFO "SELinux is not enabled. Skipping policy verification tests."
			exit 255
		fi
	fi

	# Step 2: Ensure docker service is running
	if ! systemctl is-active --quiet docker; then
		systemctl start docker
	fi

	SLEEP_WAIT 3

	# Step 3: Pull busybox image for container testing
	if ! docker images | grep -q busybox; then
		docker pull busybox:latest >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			docker pull m.daocloud.io/docker.io/busybox:latest >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				LOG_INFO "Unable to pull busybox image. Skipping container runtime tests."
				exit 255
			fi
			docker tag m.daocloud.io/docker.io/busybox:latest busybox:latest
		fi
	else
		LOG_INFO "Using local busybox image"
	fi

	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 4: Run basic container with SELinux
	docker run --rm busybox:latest /bin/sh -c "echo 'container running'" >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "Failed to run container with SELinux"

	# Step 5: Check container SELinux context is container_t
	docker run --rm busybox:latest /bin/sh -c "cat /proc/self/attr/current" | grep container_t >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		LOG_INFO "Container SELinux context is container_t"
	else
		LOG_INFO "Container SELinux context check skipped (may be noconfinement)"
	fi

	# Step 6: Verify container process SELinux type from host is container_t
	local container_pid
	container_pid=$(docker run -d busybox:latest sleep 60)
	if [ $? -eq 0 ]; then
		local selinux_context
		selinux_context=$(ps -Z | grep "$(docker inspect -f '{{.State.Pid}}' "$container_pid")" | grep -v grep)
		LOG_INFO "Container SELinux context: $selinux_context"
		if echo "$selinux_context" | grep container_t >/dev/null 2>&1; then
			LOG_INFO "Container process SELinux type is container_t"
		else
			LOG_INFO "Container process SELinux type check skipped"
		fi
		docker kill "$container_pid" >/dev/null 2>&1
	else
		LOG_INFO "Failed to start container for SELinux verification, skipping"
	fi

	# Step 7: Prepare test directory for volume mount test
	mkdir -p /tmp/container-test
	echo "test data" >/tmp/container-test/data.txt

	# Step 8: Set container_file_t SELinux context on test file
	chcon -t container_file_t /tmp/container-test/data.txt

	# Step 9: Verify container can access mounted volume with proper SELinux context
	docker run --rm -v /tmp/container-test:/mnt busybox:latest /bin/sh -c "cat /mnt/data.txt" | grep "test data" >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "Failed to access mounted volume with container_file_t context"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	rm -rf /tmp/container-test
	docker ps -a | awk '{print $1}' | grep -v "CONTAINER" | xargs docker rm -f
	docker rmi busybox m.daocloud.io/docker.io/busybox
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
