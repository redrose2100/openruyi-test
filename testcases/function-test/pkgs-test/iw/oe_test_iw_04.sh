#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/08/11
# @License   :   Mulan PSL v2
# @Desc      :   iw device type switch, interface management, channel/freq settings and power save test
# ############################################

source "${OET_PATH}"/testcases/function-test/pkgs-test/iw/common_lib_iw.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    iw_deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # iw dev <devname> set type station - set to station
    iw dev "$HWSIM_DEV" set type station
    CHECK_RESULT $? 0 0 "iw set type station command failed"
    iw dev "$HWSIM_DEV" info | grep "type managed"
    CHECK_RESULT $? 0 0 "iw verify type managed command failed"
    # iw phy <phyname> interface add testif type monitor
    iw phy "$HWSIM_PHY" interface add testif type monitor
    CHECK_RESULT $? 0 0 "iw phy interface add command failed"
    iw dev testif info | grep monitor
    CHECK_RESULT $? 0 0 "iw new interface info command failed"
    # iw dev testif del - remove virtual interface
    iw dev testif del
    CHECK_RESULT $? 0 0 "iw interface del command failed"
    iw dev testif info  2>&1 | grep "No such device"
    CHECK_RESULT $? 0 0 "iw verify interface del command failed"
    # iw dev <devname> interface add testif2 type managed
    iw dev "$HWSIM_DEV" interface add testif2 type managed
    CHECK_RESULT $? 0 0 "iw dev interface add command failed"
    iw dev testif2 info | grep managed
    CHECK_RESULT $? 0 0 "iw verify dev interface add command failed"
    # iw dev testif2 del - remove interface
    iw dev testif2 del
    CHECK_RESULT $? 0 0 "iw dev interface del command failed"
    iw dev testif2 info  2>&1 | grep "No such device"
    CHECK_RESULT $? 0 0 "iw verify dev interface del command failed"
    # iw dev <devname> get power_save - get current power save
    iw dev "$HWSIM_DEV" get power_save | grep -i "Power save"
    CHECK_RESULT $? 0 0 "iw get power_save command failed"
    # iw dev <devname> set power_save off - disable power save
    iw dev "$HWSIM_DEV" set power_save off
    CHECK_RESULT $? 0 0 "iw set power_save off command failed"
    iw dev "$HWSIM_DEV" get power_save | grep -i "off"
    CHECK_RESULT $? 0 0 "iw verify power_save off command failed"
    # iw dev <devname> set channel 1 - set channel in monitor mode
    ip link set "$HWSIM_DEV" down
    iw dev "$HWSIM_DEV" set type monitor
    ip link set "$HWSIM_DEV" up
    iw dev "$HWSIM_DEV" set channel 1
    CHECK_RESULT $? 0 0 "iw dev set channel command failed"
    # iw dev <devname> set freq 2412 - set freq in monitor mode
    iw dev "$HWSIM_DEV" set freq 2412
    CHECK_RESULT $? 0 0 "iw dev set freq command failed"
    # iw dev <devname> set type managed - switch to managed
    ip link set "$HWSIM_DEV" down
    iw dev "$HWSIM_DEV" set type managed
    CHECK_RESULT $? 0 0 "iw set type managed command failed"
    ip link set "$HWSIM_DEV" up
    iw dev "$HWSIM_DEV" info | grep "managed"
    CHECK_RESULT $? 0 0 "iw dev set type managed failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    iw_clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
