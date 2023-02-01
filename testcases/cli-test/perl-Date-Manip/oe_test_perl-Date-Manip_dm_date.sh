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
    echo "2017" > datefile.txt
    dm_date --help | grep "usage"
    CHECK_RESULT $? 0 0 "option--help is error"
    dm_date --date=2012 -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2012"
    CHECK_RESULT $? 0 0 "option--date is error"
    dm_date -d 2012 -u -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2011"
    CHECK_RESULT $? 0 0 "option-d is error"
    dm_date --file=datefile.txt -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2017"
    CHECK_RESULT $? 0 0 "option--file is error"
    dm_date -f datefile.txt --universal -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2016"
    CHECK_RESULT $? 0 0 "option-f is error"
    dm_date --reference=datefile.txt -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2022"
    CHECK_RESULT $? 0 0 "option--reference is error"
    dm_date -r datefile.txt -u -R +'%a, %d %b %Y %H:%M:%S %z' | grep "2022"
    CHECK_RESULT $? 0 0 "option-r is error"
    dm_date --rfc-2822 | grep "2022"
    CHECK_RESULT $? 0 0 "option--rfc is error"
    dm_date --utc -R | grep "2022"
    CHECK_RESULT $? 0 0 "option--utc is error"
    dm_date --universal -R | grep "2022"
    CHECK_RESULT $? 0 0 "option--universal is error"
    LOG_INFO "End of the test"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf datefile.txt
    LOG_INFO "Finish environment cleanup."
}
main "$@"