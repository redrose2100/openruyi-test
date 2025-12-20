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
# @Desc      :   Test traffic_top
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "nginx trafficserver"
    sed -i "s/listen       80/listen       8080/" /etc/nginx/nginx.conf
    sed -i "s/listen       \[/\#listen       \[/" /etc/nginx/nginx.conf
    LOG_INFO "trafficserver has been installed"
    echo "map http://localhost:8080/ http://${NODE1_IPV4}:81/" > /etc/trafficserver/remap.config  
    pkill [TS_MAIN]
    pkill traffic_m
    rm -rf /usr/local/var/trafficserver/server.lock
    rm -rf /usr/local/var/trafficserver/manager.lock
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    traffic_top -V|grep "Apache Traffic Server" 
    CHECK_RESULT $? 0 0 "failed to show version" 
    #Display traffic_server infomation
    nohup  traffic_top www.gitee.com >/tmp/show.log 2>&1 &
    SLEEP_WAIT 15
    grep "CACHE" /tmp/show.log 
    CHECK_RESULT $? 0 0 "failed to display traffic_server infomation"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    pkill [TS_MAIN]
    pkill traffic_m
    rm -rf /tmp/show.log
    rm -rf /usr/local/var/trafficserver/server.lock
    rm -rf /usr/local/var/trafficserver/manager.lock
    DNF_REMOVE 
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
