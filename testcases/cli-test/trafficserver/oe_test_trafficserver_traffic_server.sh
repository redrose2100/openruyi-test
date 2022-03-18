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

function pre_test() {
    LOG_INFO "Start environmental preparation."
    trafficserver has been installed
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    #run the regression test suite
    sudo bin/traffic_server -R 1
    CHECK_RESULT $? 
    #Print version string
    traffic_server -V
    CHECK_RESULT $? 
    #List Regression Tests
    traffic_server -l |grep SDK_API
    CHECK_RESULT $? 
    #Print usage information
    traffic_server -h
    CHECK_RESULT $? 
    #Port descriptor for HTTP Accept
    nohup traffic_server -p http://localhost:8080 >HTTP.log 2>&1&
    SLEEP_WAIT 15 
    CHECK_RESULT $? 
    #Set Number of UDP Threads
    nohup traffic_server -U 1 >UDP.log 2>&1&
    SLEEP_WAIT 15 
    #Run Specific Regression Test
    nohup traffic_server -r list >Specific.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $?
    #Clear Cache on Startup
    nohup traffic_server -K >Cache.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $?
    #Clear HostDB on Startup
    nohup traffic_server -k >HostDB.log 2>&1&
    SLEEP_WAIT 15
    #Maintenance Command to Execute
    traffic_server -C check
    CHECK_RESULT $?
    #Max number of librecords metrics and configurations
    nohup traffic_server -m 2500 >metrics.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop "${service}"
    rm -f *.log 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
