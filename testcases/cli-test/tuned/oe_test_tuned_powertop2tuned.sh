#!/usr/bin/bash
# Copyright (c) [2021] Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author  : wuzhihao
# @email   : zhihao@isrc.iscas.ac.cn
# @Date    : 2022-02-10
# @License : Mulan PSL v2
# @Version : 1.0
# @Desc    :Test Tuend command line
#####################################
export OET_PATH="/root/mugen"
source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$OET_PATH/testcases/cli-test/tuned/my_common_lib.sh"

function config_params(){
	LOG_INFO "Start to config params of the case."
	free_port="$(GET_FREE_PORT localhost)"
	LOG_INFO "End to config params of the case."
}
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL tuned
    LOG_INFO "End of environmental preparation!"
}

function run_test(){
	LOG_INFO "Start testing..."
	powertop2tuned test_if_profile.txt | IF_FILE_EXIXT test_if_profile
	CHECK_RESULT $? 0 0 'Failed to create a custom profile'
	powertop2tuned --help 2>&1 | grep 'usage: powertop2tuned'
    	CHECK_RESULT $? 0 0 'Failed to output version info.'
       	powertop --html=htmlfile.html --time=5 | find . -name 'htmlfile.html'
	CHECK_RESULT $? 0 0 'Failed to generate HTML reports.'
	powertop2tuned -o /etc/tuned/profile_name | IF_FILE_EXIXT profile_name
	CHECK_RESULT $? 0 0 'Failed to have directory where the profile will be written.'
	powertop2tuned -f test_force_profile | IF_FILE_EXIXT test_force_profile/tuned.conf
	CHECK_RESULT $? 0 0 'Failed to overwrites the output directory.'
	LOG_INFO "Finish test!"
}

function post_test() {
	LOG_INFO "Start environment cleanup."
	DNF_REMOVE
	LOG_INFO "Finish environment cleanup!"
}
main "$@"
