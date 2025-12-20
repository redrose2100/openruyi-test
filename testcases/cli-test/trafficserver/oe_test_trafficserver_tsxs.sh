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
# @Desc      :   Test tsxs
# #############################################
source "../common/common_lib.sh"
function config_params() {
    LOG_INFO "Start to config params of the case."
    DNF_INSTALL "trafficserver trafficserver-devel"
    traffic_server start
    LOG_INFO "End to config params of the case."
}
function pre_test() {
    LOG_INFO "Start environmental preparation."
    cat>1.c<<END
	#include <stdio.h>
	int main(){
	printf("hello world\n");
	}
END
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    tsxs -I/foo/include  -L/foo/lib -o 1.so -i 1.c
    CHECK_RESULT $? 0 0 "failed to install a trafficserver plugins" 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf 1.*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
