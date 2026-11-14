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
# @Desc      :   View the user's most recent log-ins
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	# The test relies on ssh/scp (SSH_CMD/SSH_SCP) and expect, which may not
	# be installed on the test node by default (openRuyi minimal install).
	# openssh-clients provides ssh/scp; expect automates the ssh login.
	# Install directly on the local node (this script runs on NODE1), as
	# DNF_INSTALL would go through SSH_CMD which itself needs ssh.
	dnf -y install openssh-clients expect >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "Failed to install openssh-clients/expect"
	SSH_CMD "useradd -m test1;echo ${NODE2_PASSWORD}|passwd --stdin test1;
	useradd -m test2;echo ${NODE2_PASSWORD}|passwd --stdin test2" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	# Login prompt on openRuyi is like "[user@hostname ~]$", not "localhost",
	# so match the generic prompt to exit cleanly after login.
	expect -c "
	set timeout 30
	spawn ssh ${NODE2_USER}@${NODE2_IPV4}
  	expect {
  		\"*)?\" {
        send \"yes\r\"
        exp_continue
		}
        \"*assword*\" {
        send \"${NODE2_PASSWORD}\r\"
        expect \"*~]*\" {send \"exit\r\"}
        exp_continue
		}
	}
"
	expect -c "
	set timeout 30
	spawn ssh test1@${NODE2_IPV4}
  	expect {
  		\"*)?\" {
        send \"yes\r\"
        exp_continue
		}
        \"*assword*\" {
        send \"${NODE2_PASSWORD}\r\"
        expect \"*~]*\" {send \"exit\r\"}
        exp_continue
		}
	}
"
	expect -c "
	set timeout 30
	spawn ssh test2@${NODE2_IPV4}
  	expect {
  		\"*)?\" {
        send \"yes\r\"
        exp_continue
		}
        \"*assword*\" {
        send \"${NODE2_PASSWORD}\r\"
        expect \"*~]*\" {send \"exit\r\"}
        exp_continue
		}
	}
"
	# openRuyi keeps login records in the lastlog2 database (liblastlog2),
	# /var/log/wtmp stays empty, so `last -f /var/log/wtmp` always yields
	# nothing. Use lastlog2 instead; its first column is the username too.
	SSH_CMD "lastlog2>/tmp/rebootlog1" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
	SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/tmp/rebootlog1 . ${NODE2_PASSWORD}
	CHECK_RESULT $?
	num_user=$(cat rebootlog1 | grep -iE "test1|test2|${NODE2_USER}" | awk '{print$1}' | sort -u | wc -l)
	test "$num_user" -eq 3
	CHECK_RESULT $?
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	rm -rf rebootlog1
	SSH_CMD "userdel -r test1;userdel -r test2;rm -rf /tmp/rebootlog1" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
	LOG_INFO "End to restore the test environment."
}

main $@
