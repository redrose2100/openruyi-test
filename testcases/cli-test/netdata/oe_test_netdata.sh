#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/1/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "netdata" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL netdata
    mkdir /root/test
    touch /root/test/test.txt  
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_netdata."
    netdata
    CHECK_RESULT $? 0 0 "Failed : start"
    netdata -v 2>&1 | grep "netdata v1.16.0"
    CHECK_RESULT $? 0 0 "Failed option: -v"
    netdata -c /etc/netdata/netdata.conf 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -c filename"
    netdata -d 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -d"
    netdata -h 2>&1 | grep "SYNOPSIS"
    CHECK_RESULT $? 0 0 "Failed option: -h"
    netdata -P /root/test/test.txt 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -P"
    ip=`ifconfig ens33 | grep 'inet' | awk '{print $2}' | head -1`
    netdata -i $ip 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -i IP" 
    netdata -p 19999 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -p"
    netdata -t 1 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -t"
    netdata -u netdata 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -u"
    netdata -s /  2>&1
    CHECK_RESULT $? 0 0 "Failed option: -s"
    netdata -V 2>&1 | grep "netdata v1.16.0"
    CHECK_RESULT $? 0 0 "Failed option: -V"
    netdata -W stacksize=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W stacksize=N"
    netdata -W debug_flags=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W debug_flags=N"
    netdata -W unittest 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W unittest"
    netdata -W createdataset=10 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W createdataset=N"
    netdata -W set section option value 2>&1
    CHECK_RESULT $? 0 0 "Failed option: -W set section option value" 
    netdata -W simple-pattern pattern string | grep "RESULT"
    CHECK_RESULT $? 0 0 "Failed option: -W simple-pattern pattern string"
    ./killpid.sh &
    netdata -D 2>&1 
    CHECK_RESULT $? 0 0 "Failed option: -D"
    LOG_INFO "End to run testcase:oe_test_netdata."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE 
    rm -rf /root/test/
    LOG_INFO "End to restore the test environment." 
}

main "$@"
