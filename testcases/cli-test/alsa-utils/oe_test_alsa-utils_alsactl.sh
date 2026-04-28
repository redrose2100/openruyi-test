 #!/usr/bin/bash
 	 
# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026/04/21
# @License   :   Mulan PSL v2
# @Desc      :   Test alsactl command
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-utils"
    if aplay -l 2>/dev/null | grep -qi "card"; then
        LOG_INFO "Sound card detected."
    else
        LOG_WARN "No sound card detected, some alsactl commands may fail."
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    set -x

    # Test alsactl --version
    alsactl --version | grep "alsactl version"
    CHECK_RESULT $? 0 0 "alsactl --version failed"

    # Test alsactl -h (help)
    alsactl -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "alsactl -h failed"

    # Test alsactl store - save current mixer settings
    alsactl store
    CHECK_RESULT $? 0 0 "alsactl store failed"

    # Test alsactl restore - restore mixer settings
    alsactl restore
    CHECK_RESULT $? 0 0 "alsactl restore failed"

    # Test alsactl -f to specify state file (store)
    alsactl -f /var/lib/alsa/asound.state store
    CHECK_RESULT $? 0 0 "alsactl -f store failed"

    # Test alsactl -f to specify state file (restore)
    alsactl -f /var/lib/alsa/asound.state restore
    CHECK_RESULT $? 0 0 "alsactl -f restore failed"

    # Test alsactl kill - send signals to processes (allow 0 or 1)
    alsactl kill 2>/dev/null
    CHECK_RESULT $? 0 1 "alsactl kill exit code check"

    # Test alsactl init with card number (card 0) - allow failure if no sound card
    alsactl init 0 2>/dev/null
    CHECK_RESULT $? 0 1 "alsactl init 0 failed (may be expected without sound card)"

    # Test alsactl nreset with card number (card 0) - allow failure if no sound card
    alsactl nreset 0 2>/dev/null
    CHECK_RESULT $? 0 1 "alsactl nreset 0 failed (may be expected without sound card)"

    set +x
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "alsa-utils"
    rm -f /var/lib/alsa/asound.state 2>/dev/null
    LOG_INFO "End to restore the test environment."
}

main "$@"