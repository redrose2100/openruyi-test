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
# @Date      :   2026-07-13
# @License   :   Mulan PSL v2
# @Desc      :   alsa-lib common functions
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
# Check if audio hardware exists on the system
# Returns 0 if audio hardware is found, 1 if not
function check_audio_device() {
	local has_audio=1
	DNF_INSTALL "usbutils alsa-utils"

	# Check via lspci
	if lspci 2>/dev/null | grep -i audio; then
		has_audio=0
	# Check via lsusb
	elif lsusb 2>/dev/null | grep -i audio; then
		has_audio=0
	# Check via /proc/asound/cards
	elif grep -iv 'no soundcards' /proc/asound/cards >/dev/null 2>&1; then
		has_audio=0
	# Check via aplay -l
	elif aplay -l 2>/dev/null | grep 'card'; then
		has_audio=0
	fi
	DNF_REMOVE
	return $has_audio
}

# Check audio device and skip test if not found
# Exits with code 255 to indicate skip status
function check_and_skip_if_no_audio() {
	LOG_INFO "Checking for audio hardware..."
	if ! check_audio_device; then
		LOG_INFO "No audio hardware detected. Skipping this test case."
		exit 255
	fi
	LOG_INFO "Audio hardware detected, proceeding with test."
}
