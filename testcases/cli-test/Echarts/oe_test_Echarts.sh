#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2022-02-01
# @License   :   Mulan PSL v2
# @Desc      :   package Echarts test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "npm httpd"
    systemctl stop firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    npm install echarts --save
    CHECK_RESULT $? 0 0 "echarts Installation failure error"
    ln -s  node_modules/echarts/ echarts
    CHECK_RESULT $? 0 0 "ln -s  node_modules/echarts/ echarts Soft connection making failed"
    cp index.html /var/www/html/
    CHECK_RESULT $? 0 0 "cp index.html /var/www/html/ Copy failed"
    systemctl start httpd
    CHECK_RESULT $? 0 0 "httpd Start failed"
    curl http://localhost | grep "销售额" | grep "季度销量"
    CHECK_RESULT $? 0 0 "curl http://localhost | grep \"销售额\" | grep \"季度销量\" Access failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment." 
    systemctl start firewalld
    npm uninstall echarts --save
    rm -rf node_modules/echarts/ echarts
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
