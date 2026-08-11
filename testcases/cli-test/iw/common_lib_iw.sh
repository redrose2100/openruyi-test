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
# @Date      :   2026/08/10
# @License   :   Mulan PSL v2
# @Desc      :   iw test common library
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function iw_deploy_env() {
    DNF_INSTALL "iw iproute"
    modprobe mac80211_hwsim radios=2
    SLEEP_WAIT 1
    HWSIM_DEV=""
    for f in /sys/class/net/wlan*; do
        [ -e "$f" ] || continue
        HWSIM_DEV="${f##*/}"
        break
    done
    if [ -z "$HWSIM_DEV" ]; then
        LOG_INFO "Cannot create virtual wireless device, skip the test."
        exit 255
    fi
    HWSIM_PHY_NUM=$(iw dev "$HWSIM_DEV" info 2>&1 | grep -i "wiphy" | awk '{print $2}')
    HWSIM_PHY="phy$HWSIM_PHY_NUM"
    export HWSIM_DEV HWSIM_PHY
    ip link set "$HWSIM_DEV" up
}

function iw_clear_env() {
    if [ -n "$HWSIM_DEV" ]; then
        ip link set "$HWSIM_DEV" down
        iw dev "$HWSIM_DEV" del
    fi
    rmmod mac80211_hwsim
    DNF_REMOVE
}
