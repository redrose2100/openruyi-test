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
#@Author    	:   LifanHan
#@Contact   	:   514362169@qq.com
#@Date      	:   2022-07-25 15:11:43
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test pywbem_wbemcli command
#####################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/pywbem/common/checkenv.sh"


function pre_test() {
    # 判断 python3-pywbem 版本是否为0.12.4, 如果不是skip退出 
    checkversion0124
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-pywbem tog-pegasus"
    systemctl start tog-pegasus
    LOG_INFO "End to prepare the test environment."
}


function run_test()
{
    LOG_INFO "Start to run test."
    wbemcli -V
    CHECK_RESULT $? 0 0 "wbemcli: failed to test options -V"
    echo CONN | wbemcli --statistics http://0.0.0.0:5988 2>&1 | grep "stats_enabled=True"
    CHECK_RESULT $? 0 0 "wbemcli: failed to test options --statistics"
    echo CONN | wbemcli -l all='file' http://0.0.0.0:5988 2>&1 | grep "log=on"
    CHECK_RESULT $? 0 0 "wbemcli: failed to test options -l"
    wbemcli -h | grep "help"
    CHECK_RESULT $? 0 0 "wbemcli: failed to test option -h"
    LOG_INFO "End to run test."
}


function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}    


main "$@"

