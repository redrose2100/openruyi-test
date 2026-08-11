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
# @Desc      :   iw basic commands, device info query, monitor mode and HT channel settings test
# ############################################

source "${OET_PATH}"/testcases/cli-test/iw/common_lib_iw.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    iw_deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # iw --help - verify help output contains Usage
    iw --help | grep -i "usage"
    CHECK_RESULT $? 0 0 "iw --help command failed"
    # iw --version - verify version output
    iw --version | grep "$(rpm -q iw | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "iw --version command failed"
    # iw commands - list all known commands
    iw commands | grep "get_wiphy"
    CHECK_RESULT $? 0 0 "iw commands command failed"
    # iw features - show supported features
    iw features | grep "features:"
    CHECK_RESULT $? 0 0 "iw features command failed"
    # iw list - list all wireless devices
    iw list | grep -i "$HWSIM_PHY"
    CHECK_RESULT $? 0 0 "iw list command failed"
    # iw phy <phyname> info - show PHY capabilities
    iw phy "$HWSIM_PHY" info | grep -i "$HWSIM_PHY"
    CHECK_RESULT $? 0 0 "iw phy info command failed"
    # iw phy <phyname> channels - show available channels
    iw phy "$HWSIM_PHY" channels | grep -i "Channel"
    CHECK_RESULT $? 0 0 "iw phy channels failed: no channel data found"
    # iw phy <phyname> reg get - regulatory domain info
    iw phy "$HWSIM_PHY" reg get | grep -i "country\|global"
    CHECK_RESULT $? 0 0 "iw phy reg get command failed"
    # iw dev <devname> set monitor active - set active flag
    ip link set "$HWSIM_DEV" down
    iw dev "$HWSIM_DEV" set monitor active
    CHECK_RESULT $? 0 0 "iw set monitor active command failed"
    ip link set "$HWSIM_DEV" up
    grep "0x20" /sys/kernel/debug/ieee80211/"$HWSIM_PHY"/netdev:"$HWSIM_DEV"/flags
    CHECK_RESULT $? 0 0 "iw set monitor active command failed after up"
    # iw dev <devname> set channel 1 HT20 - set channel with HT config
    iw dev "$HWSIM_DEV" set channel 1 HT20
    CHECK_RESULT $? 0 0 "iw dev set channel HT20 command failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    iw_clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
