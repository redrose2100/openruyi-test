#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test strongswan-swanctl.service restart
# #############################################

source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL strongswan
    touch {/etc/strongswan/ipsec.d/triplets.dat,/etc/tnc_config}
    tmp_version=$(yum list installed | grep -w "strongswan" | grep -v "strongswan-" | tr -s " " | cut -d " " -f 2 | cut -d "-" -f 1 | tr -d ".")
    version=$(("$tmp_version" + 0))
    if [ "$version" -lt 580 ];
        then
        service="strongswan-swanctl.service"
    else
        service="strongswan.service"
    fi 
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution "${service}"
    systemctl start "${service}"
    sed -i 's\ExecStart=/usr/sbin/charon-systemd\ExecStart=/usr/sbin/charon-systemd -v\g' /usr/lib/systemd/system/"${service}"
    systemctl daemon-reload
    systemctl reload "${service}"
    CHECK_RESULT $? 0 0 "${service} reload failed"
    systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i 's\ExecStart=/usr/sbin/charon-systemd -v\ExecStart=/usr/sbin/charon-systemd\g' /usr/lib/systemd/system/"${service}"
    systemctl daemon-reload
    systemctl reload "${service}"
    rm -rf /etc/strongswan/ipsec.d/triplets.dat /etc/tnc_config
    systemctl stop "${service}"
    DNF_REMOVE strongswan
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
