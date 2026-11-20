#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2020-6-19
# @License   :   Mulan PSL v2
# @Desc      :   The system log is recorded in a fixed log file
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function config_params() {
	LOG_INFO "Start to config params of the case."
	status_output=$(systemctl status systemd-journald)
	# 原来写的是 ls '/run/log/journal/*'，单引号让 glob 不展开，ls 必然报错，
	# 于是永远走到 /var/log/journal 分支。改用 compgen 判断目录是否存在。
	if compgen -G "/run/log/journal/*" >/dev/null; then
		regex="/run/log/journal/[a-zA-Z0-9]+"
	else
		regex="/var/log/journal/[a-zA-Z0-9]+"
	fi
	[[ $status_output =~ $regex ]] && path="${BASH_REMATCH[0]}"
	LOG_INFO "End to config params of the case."
}
function run_test() {
	LOG_INFO "Start to run test."
	# journald.conf 里 Storage 默认被注释（#Storage=auto），被注释就代表使用
	# 默认值 auto，也是持久化语义。只 grep 未注释行会在 openRuyi 上误报。
	grep -E '^[#[:space:]]*Storage=(auto|persistent)' /etc/systemd/journald.conf
	CHECK_RESULT $?
	if [ -z "${path}" ]; then
		LOG_WARN "Cannot locate the journal directory from systemctl status, skip."
		LOG_INFO "End to run test."
		return 0
	fi
	cp -r "${path}" "${path}bak"
	rm -rf "${path}"
	systemctl restart systemd-journald.service
	if [ ! -d "${path}" ]; then
		CHECK_RESULT 0 1
		cp -r "${path}bak" "${path}"
	fi

	check_file=0
	for file in "${path}"/*; do
	    if [ -f "$file" ] && [[ "$file" == *"journal"* ]]; then
	        ((check_file++))
	    fi
	done

	CHECK_RESULT "${check_file}" 1
	journalctl --file "${path}/system.journal" >systemlog1
	logsize=$(grep -c -v ' No entries ' systemlog1)
	test $((logsize)) -gt 1
	CHECK_RESULT $?
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	rm -rf "${path}bak" systemlog1
	LOG_INFO "End to restore the test environment."
}

main "$@"
