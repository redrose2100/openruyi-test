#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/7/10
# @License   :   Mulan PSL v2
# @Desc      :   Test obsredis.service restart
# #############################################
#shellcheck disable=SC1091,SC2016
source "./common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    env_pre
    dnf install -y redis
    systemctl start redis
    cp -r /usr/lib/obs/server/BSConfig.pm /usr/lib/obs/server/BSConfig.pm_bak
    echo 'our $redisserver = "redis://$hostname:6379";' >> /usr/lib/obs/server/BSConfig.pm
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution obsredis.service
    test_reload obsredis.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop obsredis.service
    systemctl stop redis
    rm -rf /usr/lib/obs/server/BSConfig.pm
    mv /usr/lib/obs/server/BSConfig.pm_bak /usr/lib/obs/server/BSConfig.pm
    dnf remove -y redis
    env_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
