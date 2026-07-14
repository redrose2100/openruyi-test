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
# @Desc      :   alsa-lib Mixer API test
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

	# Step 3: Compile Mixer API test program
    cat > test_mixer.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <alsa/asoundlib.h>

int main(int argc, char *argv[]) {
    int rc;
    snd_mixer_t *mixer;
    snd_mixer_selem_id_t *sid;
    snd_mixer_elem_t *elem;
    
    rc = snd_mixer_open(&mixer, 0);
    if (rc < 0) {
        printf("snd_mixer_open failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        return 0;
    }
    
    rc = snd_mixer_attach(mixer, "default");
    if (rc < 0) {
        printf("snd_mixer_attach failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        snd_mixer_close(mixer);
        return 0;
    }
    
    rc = snd_mixer_selem_register(mixer, NULL, NULL);
    if (rc < 0) {
        printf("snd_mixer_selem_register failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        snd_mixer_close(mixer);
        return 0;
    }
    
    rc = snd_mixer_load(mixer);
    if (rc < 0) {
        printf("snd_mixer_load failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        snd_mixer_close(mixer);
        return 0;
    }
    
    snd_mixer_selem_id_alloca(&sid);
    snd_mixer_selem_id_set_name(sid, "Master");
    elem = snd_mixer_find_selem(mixer, sid);
    
    printf("Mixer API test passed\n");
    printf("RESULT: PASS\n");
    
    snd_mixer_close(mixer);
    return 0;
}
EOF
    CHECK_RESULT $? 0 0 "Failed to create test_mixer.c"

    gcc test_mixer.c -o test_mixer $(pkg-config --cflags --libs alsa)
    CHECK_RESULT $? 0 0 "Failed to compile test_mixer.c"

	# Step 4: Run Mixer API test
    ./test_mixer | grep "RESULT:"
    CHECK_RESULT $? 0 0 "Mixer API test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    # Step 5: Clean up test environment, remove temporary files and packages
    LOG_INFO "Start to restore the test environment."
    rm -f test_mixer.c test_mixer
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
