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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/04/25
# @License   :   Mulan PSL v2
# @Desc      :   Scanning remote system vulnerabilities
# #############################################
# shellcheck disable=SC2034

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "expect scap-security-guide openscap"
    DNF_INSTALL "openscap scap-security-guide" 2
    EXECUTE_T="60m"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect -c"
	set timeout 3600
    spawn oscap-ssh ${NODE2_USER}@${NODE2_IPV4} 22 oval eval --report /root/remote-vulnerability.html /usr/share/xml/scap/ssg/content/ssg-ol7-oval.xml
	expect {
		\"*yes/no*\" {
			send \"yes\\r\"
			exp_continue
		}
		\"s password: \" {
			send \"${NODE2_PASSWORD}\\r\"
			exp_continue
		
		}
		timeout
	}
"
    grep oscap /root/remote-vulnerability.html
    CHECK_RESULT $? 0 0 "exec 'oscap-ssh' failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE 2 "$@"
    DNF_REMOVE "$@"
    rm -rf /root/remote-vulnerability.html
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
