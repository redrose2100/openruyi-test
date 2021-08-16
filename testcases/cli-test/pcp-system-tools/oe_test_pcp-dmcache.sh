#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-10-26
#@License       :   Mulan PSL v2
#@Desc          :   (pcp-system-tools) (pcp-dmcache,pcp-lvmcache)
#####################################

source "common/common_pcp-system-tools.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    metric_name=disk.dev.write
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    /usr/libexec/pcp/bin/pcp-dmcache --help 2>&1 | grep 'Usage'
    CHECK_RESULT $?
    /usr/libexec/pcp/bin/pcp-dmcache --version 2>&1 | grep "$pcp_version"
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pcp-dmcache -R 2 $metric_name &
    CHECK_RESULT $?
    nohup /usr/libexec/pcp/bin/pcp-dmcache -i $metric_name &
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 $(pgrep -f /usr/libexec/pcp/bin/pcp-dmcache)
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
