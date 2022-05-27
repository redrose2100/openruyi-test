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
# @Desc      :   Test tspush
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "nginx,trafficserver"
    sed -i "s/listen       80/listen       8080/" /etc/nginx/nginx.conf
    sed -i "s/listen       \[/\#listen       \[/" /etc/nginx/nginx.conf
    LOG_INFO "trafficserver has been installed"
    echo "map http://localhost:8080/ http://${NODE1_IPV4}:81/" > /etc/trafficserver/remap.config    
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    #push file and url Print the PUSHed content to stdout
    touch /tmp/foo.txt
    nginx
    tspush -f /tmp/foo.txt -u http://localhost:8080/tmp/foo.txt -v|grep "PUSH" 
    CHECK_RESULT $? 0 0 "failed to push file and url print the PUSEed content to stdout"
    #Print Usage of tspush
    tspush -h |grep "OPTIONS"
    CHECK_RESULT $? 0 0 "show help information"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/*
    pkill [TS_MAIN]
    pkill traffic_m
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
