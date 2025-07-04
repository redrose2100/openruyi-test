#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   The system log is recorded in a fixed log file
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	grep Storage /etc/systemd/journald.conf | grep -E "Storage=auto|Storage=persistent" || exit 1
	if [ -d /run/log/journal ]; then
		journallog_path="/run/log/journal"
	else
		journallog_path="/var/log/journal"
	fi
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
	LOG_INFO "Start executing testcase."
	folder=$(find "${journallog_path}/" -mindepth 1 -maxdepth 1 -type d | head -n 1)
	cp -r "${folder}" "${folder}bak"
	rm -rf "${folder:?}"
	systemctl restart systemd-journald.service
	if [ ! -d "${folder}" ]; then
		((exec_result++))
		cp -r "${folder}bak" "${folder}"
	fi
	CHECK_RESULT "$(find "${folder}" -maxdepth 1 -type f -name "*journal" | wc -l)" 1
	sudo journalctl --file "${folder}/system.journal" | tee systemlog1
	logsize=$(stat -c%s systemlog1)
	test "${logsize}" -gt 0
	CHECK_RESULT $?
	LOG_INFO "End of testcase execution."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	rm -rf "${folder}bak" systemlog1
	LOG_INFO "Finish environment cleanup."
}

main "$@"
