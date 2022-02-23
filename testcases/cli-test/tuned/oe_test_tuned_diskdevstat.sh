#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   shangyingjie
# @Contact   :   yingjie@isrc.iscas.ac.cn
# @Date      :   2022/1/13
# @License   :   Mulan PSL v2
# @Desc      :   Test Prometheus command line
# #############################################
export OET_PATH="/root/mugen"
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
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
	diskdevstat --version 2>&1 | grep 'version'
	CHECK_RESULT $? 0 0 'Failed to output version info.'
	diskdevstat --help 2>&1 | grep 'usage: diskdevstat'
    	CHECK_RESULT $? 0 0 'Failed to output help info.'

	LOG_INFO "Finish test!"
}

function post_test() {
    	LOG_INFO "Start environment cleanup."
	DNF_REMOVE
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
