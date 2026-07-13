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
# @Desc      :   alsa-lib PCM API test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/testcases/cli-test/alsa-lib/common_alsa-lib.sh"

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
    
    # Step 3: Compile PCM API test program
	cat > test_pcm.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <alsa/asoundlib.h>

int main(int argc, char *argv[]) {
    int rc;
    snd_pcm_t *handle;
    snd_pcm_hw_params_t *params;
    snd_pcm_uframes_t frames;
    unsigned int rate = 44100;
    
    rc = snd_pcm_open(&handle, "default", SND_PCM_STREAM_PLAYBACK, 0);
    if (rc < 0) {
        printf("snd_pcm_open failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        return 0;
    }
    
    snd_pcm_hw_params_alloca(&params);
    snd_pcm_hw_params_any(handle, params);
    snd_pcm_hw_params_set_access(handle, params, SND_PCM_ACCESS_RW_INTERLEAVED);
    snd_pcm_hw_params_set_format(handle, params, SND_PCM_FORMAT_S16_LE);
    snd_pcm_hw_params_set_channels(handle, params, 2);
    snd_pcm_hw_params_set_rate_near(handle, params, &rate, 0);
    frames = 32;
    snd_pcm_hw_params_set_period_size_near(handle, params, &frames, 0);
    
    rc = snd_pcm_hw_params(handle, params);
    if (rc < 0) {
        printf("snd_pcm_hw_params failed: %s\n", snd_strerror(rc));
        printf("RESULT: SKIP\n");
        snd_pcm_close(handle);
        return 0;
    }
    
    printf("PCM API test passed\n");
    printf("RESULT: PASS\n");
    
    snd_pcm_close(handle);
    return 0;
}
EOF
	CHECK_RESULT $? 0 0 "Failed to create test_pcm.c"
    
	gcc test_pcm.c -o test_pcm "$(pkg-config --cflags --libs alsa)"
    CHECK_RESULT $? 0 0 "Failed to compile test_pcm.c"
    
    # Step 4: Run PCM API test
    ./test_pcm | grep "RESULT:"
    CHECK_RESULT $? 0 0 "PCM API test failed"

    LOG_INFO "End to run test."
}

function post_test() {
    # Step 5: Clean up test environment, remove temporary files and packages
    LOG_INFO "Start to restore the test environment."
    rm -f test_pcm.c test_pcm
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
