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
# @Author    :   wangsongsong
# @Contact   :   ss_wang@foxmail.com 
# @Date      :   2022/03/05
# @License   :   Mulan PSL v2
# @Desc      :   Test trafficserver.service restart
# #############################################

source "../common/common_lib.sh"
# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."
    DNF_INSTALL trafficserver
    traffic_server start
    LOG_INFO "End to config params of the case."
}


function pre_test() {
    LOG_INFO "Start environmental preparation."
    cat>1.c<<-EOF
	#include <stdio.h>
	int main(){
	printf("hello world\n");
	}
	EOF
   
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    /usr/bin/tsxs -o tsmodule.so -c 1.c
    CHECK_RESULT $? 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop "${service}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
