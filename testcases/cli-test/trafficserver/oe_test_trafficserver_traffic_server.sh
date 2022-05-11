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
# @Desc      :   Test traffic_server
# #############################################
source "../common/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "trafficserver"
    pkill [TS_MAIN]
    pkill traffic_m
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm -rf /usr/local/var/trafficserver/manager.lock
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    #run the regression test suite
    traffic_server -R 1 
    CHECK_RESULT $? 0 0 "failed to regression" 
    #Print version string
    traffic_server -V |grep "Apache Traffic Server"
    CHECK_RESULT $? 0 0 "failed to print version string"
    #List Regression Tests
    traffic_server -l |grep SDK_API
    CHECK_RESULT $? 0 0 "failed to list regression tests"
    #Port descriptor for HTTP Accept
    nohup traffic_server -p http://localhost:8080 > /tmp/HTTP.log 2>&1&
    SLEEP_WAIT 15 
    CHECK_RESULT $? 0 0 "failed to port descriptor for HTTP Accept" 
    #Set Number of UDP Threads
    nohup traffic_server -U 1 > /tmp/UDP.log 2>&1&
    SLEEP_WAIT 15 
    #Run Specific Regression Test
    nohup traffic_server -r list >/tmp/Specific.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to run specific regression test"
    #Clear Cache on Startup
    nohup traffic_server -K >/tmp/Cache.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to clear cache on startup"
    #Clear HostDB on Startup
    nohup traffic_server -k >/tmp/HostDB.log 2>&1&
    SLEEP_WAIT 15 0 0 "failed to clear HostDB on startup"
    #Maintenance Command to Execute
    traffic_server -C check|grep CHECK
    CHECK_RESULT $? 0 0 "failed to maintenance command to execute"
    #Max number of librecords metrics and configurations
    nohup traffic_server -m 2500 >/tmp/metrics.log 2>&1&
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to set max number of librecords metrics and configurations"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    pkill [TS_MAIN]
    pkill traffic_m
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm -rf /usr/local/var/trafficserver/manager.lock
    rm -rf /tmp/*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
