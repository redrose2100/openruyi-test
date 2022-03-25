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
# @Desc      :   Test traffic_ctl
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO  "trafficserver has been installed"
    LOG_INFO "To use traffic_ctl, traffic_manager needs to be running"
    pkill traffic_m
    pkill [TS_MAIN]
    pkill traffic_s
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm  -rf /usr/local/var/trafficserver/manager.lock
    nohup traffic_manager -B text >manager.log 2>&1 &
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    #Print usage information
    traffic_ctl -h |grep "Commands"
    CHECK_RESULT $? 0 0 "failed to print usage infomation"
    SLEEP_WAIT 12 
    #Print version string
    traffic_ctl -V |grep "traffic_ctl"
    CHECK_RESULT $? 0 0 "failed to print version string" 
    SLEEP_WAIT 12 
    #Clear all current alarms
    traffic_ctl alarm clear
    CHECK_RESULT $? 0 0 "failed to clear current alarms" 
    SLEEP_WAIT 12 
    #List all current alarms
    traffic_ctl alarm list
    CHECK_RESULT $? 0 0 "failed to list current alarms" 
    SLEEP_WAIT 12 
    #Resolve alarms(number 1)
    traffic_ctl alarm resolve 1
    CHECK_RESULT $? 0 0 "failed to resolve the alarms"
    SLEEP_WAIT 12 
    #Show default information configuration values
    traffic_ctl config defaults |grep "exec_thread.autoconfig"
    CHECK_RESULT $? 0 0 "failed to show default information configuration values"
    SLEEP_WAIT 12 
    #Show detailed information about configuration values
    traffic_ctl config describe proxy.config.exec_thread.autoconfig |grep "Name"
    CHECK_RESULT $? 0 0 "failed to show detailed information about proxy.config.exec_thread.autoconfig"
    SLEEP_WAIT 12 
    #Get one or more configuration values
    traffic_ctl config get proxy.config.http.insert_response_via_str |grep "proxy.config.http.insert_response_via_str"
    CHECK_RESULT $? 0 0 "failed to get proxy.config.http.insert_response_via_str configuration value"
    SLEEP_WAIT 12 
    #Get configuration matching a regular expression
    traffic_ctl config match proxy.config.http.insert_response_via_str|grep "proxy.config"
    CHECK_RESULT $? 0 0 "failed to get configuration matching a regular expression"
    SLEEP_WAIT 12 
    #Request a configuration reload
    traffic_ctl config reload
    CHECK_RESULT $? 0 0 "failed to request a configuration reload"
    SLEEP_WAIT 12 
    #Configure Traffic Server to insert header in the response to the client:Via
    traffic_ctl config set proxy.config.http.insert_response_via_str 1  |grep "set"
    CHECK_RESULT $? 0 0 "failed to configure Traffic Server to insert header in the response to the client"
    SLEEP_WAIT 12 
    #Check the configuration status
    traffic_ctl config status |grep "Apache Traffic Server"
    CHECK_RESULT $? 0 0 "failed to check the configuration status"   
    SLEEP_WAIT 12 
    #Set down HOST
    traffic_ctl host down HOST --reason active 
    CHECK_RESULT $? 0 0 "failed to set down HOST"
    SLEEP_WAIT 12 
    #Get one or more host statuses
    traffic_ctl host status HOST |grep "proxy.process.host_status"
    CHECK_RESULT $? 0 0 "failed to get host statuses" 
    SLEEP_WAIT 12 
    
    #Set up HOST
    traffic_ctl host up HOST --reason active
    CHECK_RESULT $? 0 0 "failed to set up HOST "
    SLEEP_WAIT 12 

    #Clear all metric values
    traffic_ctl metric clear
    CHECK_RESULT $? 0 0 "failed to clear metric values"
    SLEEP_WAIT 12 
    #Get metrics matching a regular expression
    traffic_ctl metric match 
    CHECK_RESULT $? 0 0 "failed to get metrics matching a regular expression"
    SLEEP_WAIT 12 
    #Clear one metric values
    traffic_ctl metric zero 1
    CHECK_RESULT $? 0 0 "failed to clear one metric values"
    SLEEP_WAIT 12 
    #Send message to plugins
    traffic_ctl plugin msg 1
    CHECK_RESULT $? 0 0 "failed to send message to plugins  "
    SLEEP_WAIT 12 
    #Show a full stack trace of the traffic_server process
    traffic_ctl server backtrace |grep "Thread "
    CHECK_RESULT $? 0 0 "failed to show a full stack trace of the traffic_server process"
    SLEEP_WAIT 12 
    #Drain the requests
    traffic_ctl server drain
    CHECK_RESULT $? 0 0 "failed to drain the requests"
    SLEEP_WAIT 12 
    #Restart Traffic Server
    traffic_ctl server restart
    CHECK_RESULT $? 0 0 "failed to restart Traffic Server"
    SLEEP_WAIT 12 
    #Stop the proxy
    traffic_ctl server stop
    CHECK_RESULT $? 0 0 "failed to stop the proxy"
    SLEEP_WAIT 12 
    #Start the proxy 
    traffic_ctl server start 
    CHECK_RESULT $? 0 0 "failed to start the proxy"
    SLEEP_WAIT 12 
    #Show the proxy status
    traffic_ctl server status | grep "Proxy"
    CHECK_RESULT $? 0 0 "failed to show the proxy status"
    SLEEP_WAIT 12 
    traffic_ctl server stop
    SLEEP_WAIT 12 
    #Take one storage volumes offline
    traffic_ctl storage offline 1
    CHECK_RESULT $? 0 0 "failed to offline"
    SLEEP_WAIT 12 
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill traffic_m
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm  -rf /usr/local/var/trafficserver/manager.lock
    test -f manager.log && rm -rf manager.log
    LOG_INFO "End to restore the test environment."
}

main "$@"
