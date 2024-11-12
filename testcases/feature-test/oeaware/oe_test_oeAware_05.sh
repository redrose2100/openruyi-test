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
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    log_path_new='/var/log/oeAware_new2'
    log_path_new2="${log_path_new//\//\\\/}"
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    sed -i -e '/^log_path: / s/: .*/: '"$log_path_new2"'/' /etc/oeAware/config.yaml
    systemctl restart oeaware
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
    test -f $log_path_new/server.log
    CHECK_RESULT $? 0 0 "logfile does not exist"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeawar
    DNF_REMOVE "$@"
    rm -rf $log_path_new
    LOG_INFO "End to restore the test environment."
}

main "$@"
