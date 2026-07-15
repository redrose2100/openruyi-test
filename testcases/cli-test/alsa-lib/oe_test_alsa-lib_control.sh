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
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-13
# @License   :   Mulan PSL v2
# @Desc      :   alsa-lib Control API test
# ############################################
# shellcheck disable=SC1091,SC2119,SC2046
source "./common_alsa-lib.sh"

function pre_test() {
    # Step 1: Prepare test environment, install dependencies
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-lib alsa-lib-devel gcc"
    
    # Step 2: Check for audio hardware, skip test if not found
    check_and_skip_if_no_audio
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

	# Step 3: Compile Control API test program
    cat > test_control.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <alsa/asoundlib.h>

int main(int argc, char *argv[]) {
    int rc;
    snd_ctl_t *handle;
    snd_ctl_card_info_t *info;
    
    rc = snd_ctl_open(&handle, "default", 0);
    if (rc < 0) {
        printf("snd_ctl_open failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        return 0;
    }
    
    snd_ctl_card_info_alloca(&info);
    rc = snd_ctl_card_info(handle, info);
    if (rc < 0) {
        printf("snd_ctl_card_info failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        snd_ctl_close(handle);
        return 0;
    }
    
    printf("Card Name: %s\n", snd_ctl_card_info_get_name(info));
    printf("Control API test passed\n");
    printf("RESULT: PASS\n");
    
    snd_ctl_close(handle);
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Failed to create test_control.c"

    gcc test_control.c -o test_control $(pkg-config --cflags --libs alsa)
    CHECK_RESULT $? 0 0 "Failed to compile test_control.c"

	# Step 4: Run Control API test
    ./test_control | grep "RESULT: PASS"
    CHECK_RESULT $? 0 0 "Control API test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f test_control.c test_control
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
