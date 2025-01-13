#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/07/03
# @License   :   Mulan PSL v2
# @Desc      :   Test strongswan-starter.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL strongswan
    systemctl list-unit-files | grep strongswan-starter.service
    if [ "$?" -eq 0 ]; then
            service=strongswan-starter.service
    else
            service=strongswan.service
    fi
    
    touch {/etc/strongswan/ipsec.d/triplets.dat,/etc/tnc_config}
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution ${service}
    test_reload ${service}
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop  ${service}
    rm -rf /etc/strongswan/ipsec.d/triplets.dat /etc/tnc_config
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
