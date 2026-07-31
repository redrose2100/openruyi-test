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
# @Date      :   2026-07-30
# @License   :   Mulan PSL v2
# @Desc      :   btrfs-progs common functions
# ############################################
# shellcheck disable=SC1090
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# Setup loop device, format with btrfs, and mount
# Parameters: $1 - loop file path, $2 - mount point, $3 - loop file size in MB (default: 256)
# Returns: LOOP_DEV variable set to the loop device path
function btrfs_setup_loopdev() {
	local loop_file="$1"
	local mount_point="$2"
	local loop_size="${3:-256}"

	# Create loopback file
	dd if=/dev/zero of="$loop_file" bs=1M count="$loop_size" >/dev/null 2>&1

	# Setup loop device
	LOOP_DEV=$(losetup --find --show "$loop_file")
	if [ -z "$LOOP_DEV" ]; then
		LOG_ERROR "Failed to setup loopback device for $loop_file"
		return 1
	fi

	# Format with btrfs
	mkfs.btrfs -f "$LOOP_DEV" >/dev/null 2>&1

	# Mount
	mkdir -p "$mount_point"
	mount "$LOOP_DEV" "$mount_point" >/dev/null 2>&1

	LOG_INFO "Loop device $LOOP_DEV mounted at $mount_point"
	return 0
}

# Cleanup loop device and mount point
# Parameters: $1 - loop file path, $2 - mount point
# Global: LOOP_DEV - loop device path (optional)
function btrfs_cleanup_loopdev() {
	local loop_file="$1"
	local mount_point="$2"

	# Unmount
	if mountpoint "$mount_point" >/dev/null 2>&1; then
		umount "$mount_point" >/dev/null 2>&1
	fi

	# Detach loop device
	if [ -n "$LOOP_DEV" ]; then
		losetup -d "$LOOP_DEV" >/dev/null 2>&1
	fi

	# Remove loop file and mount point
	rm -f "$loop_file"
	rm -rf "$mount_point"

	LOG_INFO "Cleanup completed for $loop_file"
	return 0
}

# Create test data on mounted btrfs filesystem
# Parameters: $1 - mount point, $2 - size in MB for test file (default: 10)
function btrfs_create_test_data() {
	local mount_point="$1"
	local data_size="${2:-10}"

	# Create binary test file
	dd if=/dev/zero of="$mount_point/testdata.bin" bs=1M count="$data_size" >/dev/null 2>&1

	# Create text test file
	echo "btrfs test file content" >"$mount_point/testfile.txt"

	LOG_INFO "Test data created on $mount_point"
	return 0
}

# Setup loop device only (no format/mount)
# Parameters: $1 - loop file path, $2 - loop file size in MB (default: 256)
# Returns: LOOP_DEV variable set to the loop device path
function btrfs_setup_loopfile() {
	local loop_file="$1"
	local loop_size="${2:-256}"

	# Create loopback file
	dd if=/dev/zero of="$loop_file" bs=1M count="$loop_size" >/dev/null 2>&1

	# Setup loop device
	LOOP_DEV=$(losetup --find --show "$loop_file")
	if [ -z "$LOOP_DEV" ]; then
		LOG_ERROR "Failed to setup loopback device for $loop_file"
		return 1
	fi

	LOG_INFO "Loop device $LOOP_DEV created for $loop_file"
	return 0
}

# Create a file and format it with btrfs (no loop device setup/mount)
# Parameters: $1 - file path, $2 - file size in MB (default: 128), $3 - extra mkfs.btrfs options (optional)
function btrfs_mkfs_file() {
	local file_path="$1"
	local file_size="${2:-128}"
	local mkfs_opts="${3:-}"

	dd if=/dev/zero of="$file_path" bs=1M count="$file_size" >/dev/null 2>&1
	mkfs.btrfs -f $mkfs_opts "$file_path" >/dev/null 2>&1
}

# Remove test files created by btrfs_mkfs_file
# Parameters: $@ - file paths to remove
function btrfs_cleanup_files() {
	rm -f "$@"
}
