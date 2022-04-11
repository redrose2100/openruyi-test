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
    rm -rf /usr/local/var/trafficserver/server.lock
    rm  -rf /usr/local/var/trafficserver/manager.lock
    nohup traffic_manager -B text >manager.log 2>&1 &
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    #Print usage information
    traffic_ctl -h |grep "Commands"
    CHECK_RESULT $? 0 0 "failed to print usage infomation"
    #Print version string
    traffic_ctl -V |grep "traffic_ctl"
    CHECK_RESULT $? 0 0 "failed to print version string" 
    #Clear all current alarms
    traffic_ctl alarm clear
    CHECK_RESULT $? 0 0 "failed to clear current alarms" 
    #List all current alarms
    traffic_ctl alarm list
    CHECK_RESULT $? 0 0 "failed to list current alarms" 
    #Resolve alarms(number 1)
    traffic_ctl alarm resolve 1
    CHECK_RESULT $? 0 0 "failed to resolve the alarms"
    #Show default information configuration values
    traffic_ctl config defaults |grep "exec_thread.autoconfig"
    CHECK_RESULT $? 0 0 "failed to show default information configuration values"
    #Show detailed information about configuration values
    traffic_ctl config describe proxy.config.exec_thread.autoconfig |grep "Name"
    CHECK_RESULT $? 0 0 "failed to show detailed information about proxy.config.exec_thread.autoconfig"
    #Get one or more configuration values
    traffic_ctl config get proxy.config.http.insert_response_via_str |grep "proxy.config.http.insert_response_via_str"
    CHECK_RESULT $? 0 0 "failed to get proxy.config.http.insert_response_via_str configuration value"
    #Get configuration matching a regular expression
    traffic_ctl config match proxy.config.http.insert_response_via_str|grep "proxy.config"
    CHECK_RESULT $? 0 0 "failed to get configuration matching a regular expression"
    #Request a configuration reload
    traffic_ctl config reload
    CHECK_RESULT $? 0 0 "failed to request a configuration reload"
    #Configure Traffic Server to insert header in the response to the client:Via
    traffic_ctl config set proxy.config.http.insert_response_via_str 1  |grep "set"
    CHECK_RESULT $? 0 0 "failed to configure Traffic Server to insert header in the response to the client"
    #Check the configuration status
    traffic_ctl config status |grep "Apache Traffic Server"
    CHECK_RESULT $? 0 0 "failed to check the configuration status"   
    #Set down HOST
    traffic_ctl host down HOST --reason active 
    CHECK_RESULT $? 0 0 "failed to set down HOST"
    #Get one or more host statuses
    traffic_ctl host status HOST |grep "proxy.process.host_status"
    CHECK_RESULT $? 0 0 "failed to get host statuses" 
    #Set up HOST
    traffic_ctl host up HOST --reason active
    CHECK_RESULT $? 0 0 "failed to set up HOST "

    #Clear all metric values
    traffic_ctl metric clear
    CHECK_RESULT $? 0 0 "failed to clear metric values"
    #Get metrics matching a regular expression
    traffic_ctl metric match 
    CHECK_RESULT $? 0 0 "failed to get metrics matching a regular expression"
    #Clear one metric values
    traffic_ctl metric zero 1
    CHECK_RESULT $? 0 0 "failed to clear one metric values"
    #Send message to plugins
    traffic_ctl plugin msg 1
    CHECK_RESULT $? 0 0 "failed to send message to plugins  " 
    #Show a full stack trace of the traffic_server process
    traffic_ctl server backtrace |grep "Thread "
    CHECK_RESULT $? 0 0 "failed to show a full stack trace of the traffic_server process"
    #Drain the requests
    traffic_ctl server drain
    CHECK_RESULT $? 0 0 "failed to drain the requests"
    #Restart Traffic Server
    traffic_ctl server restart
    CHECK_RESULT $? 0 0 "failed to restart Traffic Server"
    #Stop the proxy
    traffic_ctl server stop
    CHECK_RESULT $? 0 0 "failed to stop the proxy"
    #Start the proxy 
    traffic_ctl server start 
    CHECK_RESULT $? 0 0 "failed to start the proxy"
    #Show the proxy status
    traffic_ctl server status | grep "Proxy"
    CHECK_RESULT $? 0 0 "failed to show the proxy status"
    traffic_ctl server stop
    #Take one storage volumes offline
    traffic_ctl storage offline 1
    CHECK_RESULT $? 0 0 "failed to offline"
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
