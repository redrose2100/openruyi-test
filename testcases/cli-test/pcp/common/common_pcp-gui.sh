#!/usr/bin/bash

# Copyright (c) 2023. xFusion Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   liyongqiang
# @Contact   :   liyongqiang@xfusion.com
# @Date      :   2023/11/26
# @License   :   Mulan PSL v2
# @Desc      :   common function for pcp-gui test
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function deploy_env() {
	DNF_INSTALL "pcp pcp-gui"
	systemctl enable pmcd
	systemctl start pmcd
	systemctl enable pmlogger
	systemctl start pmlogger
	SLEEP_WAIT 10
	if grep -v ^# /etc/sysconfig/pmcd  | grep "PMCD_LOCAL=1"; then
		host_name="localhost"
	else
		host_name=$(hostname)
	fi
	archive_data="$(pcp -h "$host_name" | grep 'pmlogger:' | awk -F: '{print $NF}')"
	export archive_data
	export metric_name="disk.dev.write"
}

