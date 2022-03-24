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
# @Author    :   Songsong Wang
# @Contact   :   sswang@hit.edu.cn 
# @Date      :   2022/03/05
# @License   :   Mulan PSL v2
# @Desc      :   Test trafficserver.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    trafficserver has been installed
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm -rf /usr/local/var/trafficserver/manager.lock
    pkill [TS_MAIN]
    pkill traffic_m    
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    #Show Traffic Server Version
    traffic_manager --version | grep "Apache Traffic Server"
    CHECK_RESULT $? 0 0 "failed to show traffic server version" 
    #Set max number of librecords metrics and configurations
    nohup traffic_manager -m 2500 >metrics.log 2>&1&    
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to set max number of librecords metrics and configurations"
    #Vertical-bar-separated Debug Tags
    nohup traffic_manager -T text >debug.log 2>&1&    
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to vertical-bar-separated debug tags"
    #Vertical-bar-separated Behavior Tags
    nohup traffic_manager -B text >behavior.log 2>&1&    
    SLEEP_WAIT 15
    CHECK_RESULT $? 0 0 "failed to vertical-bar-separated debug tags"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    test -f metrics.log && rm -rf metrics.log
    test -f debug.log && rm -rf debug.log
    test -f behavior.log && rm -rf behavior.log
    test -f /usr/local/var/trafficserver/server.lock && rm -rf /usr/local/var/trafficserver/server.lock
    test -f /usr/local/var/trafficserver/manager.lock && rm -rf /usr/local/var/trafficserver/manager.lock
    pkill [TS_MAIN]
    pkill traffic_m
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
