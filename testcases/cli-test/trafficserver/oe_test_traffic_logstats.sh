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
    LOG_INFO "trafficserver has been installed"
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    #Produce JSON formatted output
    traffic_logstats -j|grep "total"
    CHECK_RESULT $?
    #Only produce the summary
    traffic_logstats -s |grep "Cache" 
    CHECK_RESULT $? 
    #Print version string
    traffic_logstats -V |grep "Apache" 
    CHECK_RESULT $?
    #Produce URL stats as a JSON object instead of array 
    traffic_logstats -A |grep "Cache" 
    CHECK_RESULT $? 
    #Incremental log parsing
    traffic_logstats -i |grep "HTTP" 
    CHECK_RESULT $? 
    #Eliminate metrics that can be inferred from other values
    traffic_logstats -C |grep "Cache" 
    CHECK_RESULT $? 
    #Produce HTTP headers suitable as a CGI
    traffic_logstats -c |grep "content" 
    CHECK_RESULT $? 
    #Report stats per user instead of host
    traffic_logstats -r |grep "IPv6" 
    CHECK_RESULT $? 
    #Don't validate the log format field names
    traffic_logstats -n |grep "Origin" 
    CHECK_RESULT $?
 
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop "${service}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
