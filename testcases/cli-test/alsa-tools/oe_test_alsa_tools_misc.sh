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
# @Date      :   2026/07/29
# @License   :   Mulan PSL v2
# @Desc      :   Test misc alsa-tools commands (GTK/GUI tools, simple checks)
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools alsa-utils alsa-tools-firmware"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test echomixer command (needs Echoaudio hardware)
    echomixer 2>&1 | grep -i "echoaudio\|cards"
    CHECK_RESULT $? 0 0 "echomixer execution check failed"
    # Test envy24control command (GTK tool)
    envy24control 2>&1 | grep -i "envy24\|gtk\|display"
    CHECK_RESULT $? 0 0 "envy24control execution check failed"
    # Test hdajackretask command (GTK tool)
    hdajackretask 2>&1 | grep -i "retask\|gtk\|display"
    CHECK_RESULT $? 0 0 "hdajackretask execution check failed"
    # Test hdspconf command (GTK tool, needs HDSP hardware)
    hdspconf 2>&1 | grep -i "hdspconf\|copyright\|gtk"
    CHECK_RESULT $? 0 0 "hdspconf execution check failed"
    # Test hwmixvolume command (GTK tool)
    hwmixvolume 2>&1 | grep -i "mixvolume\|version\|python"
    CHECK_RESULT $? 0 0 "hwmixvolume execution check failed"
    # Test init_audigy command
    init_audigy 2>&1 | grep -i "ld10k1"
    CHECK_RESULT $? 0 0 "init_audigy execution check failed"
    # Test init_audigy_eq10 command
    init_audigy_eq10 2>&1 | grep -i "ld10k1"
    CHECK_RESULT $? 0 0 "init_audigy_eq10 execution check failed"
    # Test init_live command
    init_live 2>&1 | grep -i "ld10k1\|lo10k1"
    CHECK_RESULT $? 0 0 "init_live execution check failed"
    # Test rmedigicontrol command
    rmedigicontrol 2>&1 | grep -i "medi\|emu10k1"
    CHECK_RESULT $? 0 0 "rmedigicontrol execution check failed"
    timeout 3 hdsploader -D /dev/snd/pcmCARD0DATAPTR 2>&1 | grep -i "Looking for"
    CHECK_RESULT $? 0 0 "hdsploader -D option check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
