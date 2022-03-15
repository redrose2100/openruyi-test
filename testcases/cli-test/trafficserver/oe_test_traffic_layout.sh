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
# @Author    :   Yihao Lin
# @Contact   :   1165507637@qq.com
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
    #Display Traffic Server's Layout
    traffic_layout | grep "PREFIX" 
    CHECK_RESULT $? 
    #Create a Apache Traffic Server Runboot
    touch ./traffic_layout_runboot_script.txt
    echo Y >traffic_layout_runboot_script.txt

    traffic_layout init --path myats > traffic_layout_runboot_script.txt | grep "creating runroot"
    CHECK_RESULT $? 
    
    #Veriry the runboot
    traffic_layout verify | grep "PASSED"
    CHECK_RUSULT $?

    #Remove the runboot 
    mkdir -p myats
    traffic_layout remove --path myats
    CHECK_RUSULT $?

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop "${service}"
    DNF_REMOVE
    rm -rf myats
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
