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
#        free_port="$(GET_FREE_PORT localhost)"
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
	touch /boot/abc
	restore -C -f /root/boot.bak.bz2 | grep "Some files were modified!"
	CHECK_RESULT $? 1 0 "Error! Added file detected."
	mv /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4668.img /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4669.img
	restore -C -f /root/boot.bak.bz2 | grep "Some files were modified!"
	CHECK_RESULT $? 0 0 "Failed to detecte revision files"
	mv /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4669.img /boot/initramfs-0-rescue-cc63de2ddad7424f885cb8e9c1ef4668.img
	restore -t -f /root/boot.bak.bz2 | grep "Dump   date:"
	CHECK_RESULT $? 0 0 "Failed to print backup profile informaintioin"
	mkdir boot.test
	cd boot.test/
	restore -r -f /root/boot.bak.bz2
	count=`ls /root/boot.test|wc -w`
	if [ "$count" -eq "0" ];
	then
		 LOG_ERROR "Failed to restore backup files in this folder"
	fi
	cd /root/mugen/testcases/cli-test/dump
	rm -rf /root/boot.test/
	LOG_INFO "Finish test!"
}
main "$@"
