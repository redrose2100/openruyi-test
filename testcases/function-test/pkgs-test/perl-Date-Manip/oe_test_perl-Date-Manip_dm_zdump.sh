#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   GuanMingYang && LiPengZhe
#@Contact   	:   2464167028@qq.com
#@Date      	:   2022-07-20
#@License   	:   Mulan PSL v2
#@Desc      	:   Test "dm_date and dm_zdump" command
#####################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to perpare the test environment"
    DNF_INSTALL perl-Date-Manip 
    LOG_INFO "End to perpare the test environment"
}
function run_test()
{
    LOG_INFO "Start to run test"
    dm_zdump --help | grep "usage"
    CHECK_RESULT $? 0 0 "option--help is error"
    dm_zdump -v PRC | grep "Asia"
    CHECK_RESULT $? 0 0 "option-v is error"
    dm_zdump --verbose PRC | grep "Asia"
    CHECK_RESULT $? 0 0 "option-verbose is error"
    dm_zdump -c 1940 -v PRC | grep "Asia"
    CHECK_RESULT $? 0 0 "option-c is error"
    dm_zdump --cutoff 1940 -v PRC | grep "Asia"
    CHECK_RESULT $? 0 0 "option-cutoff is error"
    LOG_INFO "End of the test"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}
main "$@"