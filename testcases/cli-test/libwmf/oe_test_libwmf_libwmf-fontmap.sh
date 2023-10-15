#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   lidikuan
# @Contact   :   1004224576@qq.com
# @Date      :   2022/7/18
# @Desc      :   Test "libwmf libwmf-fontmap" command
# ##################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test(){
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL libwmf
    LOG_INFO "End to prepare the test environment!"
}
function run_test(){
    LOG_INFO "Start to run test"
    libwmf-fontmap --map=test /common 
    cat /common | grep "xml version"
    CHECK_RESULT $? 0 0 "common libwmf-fontmap error"
    LOG_INFO "End of test"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf test*
    LOG_INFO "Finish environment cleanup!"
}
main"$@"
