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
# @Desc      :   Log View
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "procps"
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
	LOG_INFO "Start executing testcase."
	ls /var/log
	CHECK_RESULT $?
	# openRuyi 等现代发行版默认使用 systemd-journald，无 /var/log/messages 文件，
	# 改用 journalctl 查看系统日志；若存在 rsyslog 的 messages 文件则兼容校验。
	if [ -f /var/log/messages ]; then
		tail -f /var/log/messages >log 2>&1 &
		row01=$(cat log | wc -l)
		SLEEP_WAIT 5
		row02=$(cat log | wc -l)
		[ $row01 -le ${row02} ]
		CHECK_RESULT $?

		cat /var/log/messages
		CHECK_RESULT $?
	else
		journalctl --no-pager -n 10
		CHECK_RESULT $? 0 0 "journalctl failed"
	fi
	LOG_INFO "End of testcase execution."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	pid=$(ps -ef | grep "tail" | grep -v grep | awk '{print $2}')
	kill -9 ${pid}
	rm -rf log
	LOG_INFO "Finish environment cleanup."
}

main $@
