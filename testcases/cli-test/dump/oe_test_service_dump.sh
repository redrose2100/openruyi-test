#!/usr/bin/bash
# Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
# http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author : wuzhihao
# @email : zhihao@isrc.iscas.ac.cn
# @Date : 2022-02
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc :
#####################################
export OET_PATH="/root/mugen"
source "$OET_PATH/libs/locallibs/common_lib.sh"




function config_params() {
        LOG_INFO "Start to config params of the case."
        free_port="$(GET_FREE_PORT localhost)"
        LOG_INFO "End to config params of the case."
}




function pre_test() {
        LOG_INFO "Start environmental preparation."
        DNF_INSTALL dump
        LOG_INFO "End of environmental preparation!"
}

function run_test(){
	LOG_INFO "Start testing..."
	cd ~
	dump -0uj -f /root/boot.bak.bz2 /boot/ -u 2>&1 | grep "DUMP IS DONE"
	CHECK_RESULT $? 0 0 "Failed to dump file."
	dump -W 2>&1 | grep "Last dump"
	CHECK_RESULT $? 0 0 "Failed to print out, for all file systems in /etc/dumpdate."
	expect <<EOF
		spawn dump -0 -B126880 -b20 -f /root/boot.bak.bz2 /boot/ -u 
		expect {
		"("yes" or "no")"
	}
		send "yes\r"
		expect eof
EOF
	CHECK_RESULT $? 0 0 "Failed to allocate disks."
	dump -0u -a -f /root/boot.bak.bz2 /boot/ -u 2>&1 | grep "DUMP IS DONE"
	CHECK_RESULT $? 0 0 "Failed to  stands for ‘auto-size’."
	dump -0 -f -z /dev 2>&1 | grep "DUMP IS DONE"
	CHECK_RESULT $? 0 0 "Failed to compresses every block to be written on to the tape using the zlib library."
	if [[ !"$(dump -S /dev/)" =~ ^|0-9|+$ ]]; then
		LOG_ERROR "Failed to estimated number of bytes the dump will take."
	fi
	cd /root/mugen/testcases/cli-test/dump
	LOG_INFO "Finish test!"
}


#function post_test() {
#	LOG_INFO "start environment cleanup."
#	sed -i 's\ExecStart = /usr/sbin/dump --log.level=debug\ExecStart = /usr/sbin/dump\g' /usr/lib/systemd/system/dump.service
#	systemctl daemon-reload
#	systemctl reload prometheus.service
#	systemctl stop prometheus.service
#	DNF_REMOVE
#	LOG_INFO "Finish environment cleanup!"
#}

main "$@"
