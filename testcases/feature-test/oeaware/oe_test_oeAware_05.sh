#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-06
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    LOG_INFO "安装oeAware-manager"
    DNF_INSTALL "oeAware-manager"

    LOG_INFO "启动服务"
    systemctl daemon-reload 
    systemctl start oeaware
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "start oeaware failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    LOG_INFO "操作步骤1、修改log_path为不存在的路径,重启服务"
    log_path_new='/var/log/oeAware_new2'
    log_path_new2="${log_path_new//\//\\\/}"
    sed -i -e '/^log_path: / s/: .*/: '"$log_path_new2"'/' /etc/oeAware/config.yaml
    systemctl daemon-reload
    systemctl restart oeaware
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
    cd $log_path_new || exit
    if [ ! -f "server.log" ]; then
       echo "logfile does not exist"
    fi
    rm -rf $log_path_new
    LOG_INFO "预期结果１、服务启动成功，无报错，日志自动生成"


    LOG_INFO "End to run test."
    }

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
