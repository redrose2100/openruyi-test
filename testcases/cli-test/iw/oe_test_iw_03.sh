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
# @Desc      :   iw PHY parameter settings, power management, 4addr and monitor flags config test
# ############################################

source "${OET_PATH}"/testcases/cli-test/iw/common_lib_iw.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    iw_deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # iw phy <phyname> set retry short 7 long 4 - set retry count
    iw phy "$HWSIM_PHY" set retry short 7 long 4
    CHECK_RESULT $? 0 0 "iw phy set retry command failed"
    iw phy "$HWSIM_PHY" info | grep "short.*7"
    CHECK_RESULT $? 0 0 "iw phy set retry short 7 command failed"
    iw phy "$HWSIM_PHY" info | grep "long.*4"
    CHECK_RESULT $? 0 0 "iw phy set retry long 4 command failed"
    # iw phy <phyname> set rts 500
    iw phy "$HWSIM_PHY" set rts 500
    CHECK_RESULT $? 0 0 "iw phy set rts command failed"
    iw phy "$HWSIM_PHY" info | grep "RTS.*500"
    CHECK_RESULT $? 0 0 "iw phy set rts 500 command failed"
    # iw phy <phyname> set frag 1000
    iw phy "$HWSIM_PHY" set frag 1000
    CHECK_RESULT $? 0 0 "iw phy set frag command failed"
    iw phy "$HWSIM_PHY" info| grep -i "Fragmentation.*1000"
    CHECK_RESULT $? 0 0 "iw phy set frag 1000 command failed"
    # iw phy <phyname> set txpower auto
    iw phy "$HWSIM_PHY" set txpower auto
    CHECK_RESULT $? 0 0 "iw phy set txpower command failed"
    iw dev "$HWSIM_DEV" info | grep -i "txpower.*20.*dBm"
    CHECK_RESULT $? 0 0 "iw phy set txpower 20dBm command failed"
    # iw phy <phyname> set name testphy0
    iw phy "$HWSIM_PHY" set name testphy0
    CHECK_RESULT $? 0 0 "iw phy set name command failed"
    iw phy testphy0 info | grep testphy0
    CHECK_RESULT $? 0 0 "iw phy set name testphy0 command failed"
    iw phy testphy0 set name "$HWSIM_PHY"
    # iw phy <phyname> set netns 1 - test graceful failure
    iw phy "$HWSIM_PHY" set netns 1
    CHECK_RESULT $? 0 0 "iw phy set netns command failed"
    # iw dev <devname> set power_save on - enable power save
    iw dev "$HWSIM_DEV" set power_save on
    CHECK_RESULT $? 0 0 "iw set power_save on command failed"
    iw dev "$HWSIM_DEV" get power_save | grep -i "on"
    CHECK_RESULT $? 0 0 "iw verify power_save on command failed"
    # iw dev <devname> set 4addr on
    iw dev "$HWSIM_DEV" set 4addr on
    CHECK_RESULT $? 0 0 "iw dev set 4addr on command failed"
    iw dev "$HWSIM_DEV" info | grep "4addr"
    CHECK_RESULT $? 0 0 "iw verify 4addr on command failed"
    # iw dev <devname> set 4addr off
    iw dev "$HWSIM_DEV" set 4addr off
    CHECK_RESULT $? 0 0 "iw dev set 4addr off command failed"
    iw dev "$HWSIM_DEV" info | grep "4addr"
    CHECK_RESULT $? 0 1 "iw verify 4addr off command failed"
    # iw dev <devname> set monitor none - reset monitor flags
    ip link set "$HWSIM_DEV" down
    iw dev "$HWSIM_DEV" set monitor none
    CHECK_RESULT $? 0 0 "iw set monitor none command failed"
    ip link set "$HWSIM_DEV" up
    grep "0x0" /sys/kernel/debug/ieee80211/"$HWSIM_PHY"/netdev:"$HWSIM_DEV"/flags
    CHECK_RESULT $? 0 0 "iw dev set monitor none failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    iw_clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
