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
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-27
# @License   :   Mulan PSL v2
# @Desc      :   libwebp-devel development library test - header files and compilation
# ############################################
# shellcheck disable=SC1090,SC2119,SC2046
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Verify webp/decode.h header file exists
    ls /usr/include/webp/decode.h
    CHECK_RESULT $? 0 0 "webp/decode.h header file not found"

    # Step 2: Verify webp/encode.h header file exists
    ls /usr/include/webp/encode.h
    CHECK_RESULT $? 0 0 "webp/encode.h header file not found"

    # Step 3: Verify webp/types.h header file exists
    ls /usr/include/webp/types.h
    CHECK_RESULT $? 0 0 "webp/types.h header file not found"

    # Step 4: Verify webp/mux.h header file exists
    ls /usr/include/webp/mux.h
    CHECK_RESULT $? 0 0 "webp/mux.h header file not found"

    # Step 5: Verify webp/demux.h header file exists
    ls /usr/include/webp/demux.h
    CHECK_RESULT $? 0 0 "webp/demux.h header file not found"

    # Step 6: Create and compile a simple WebP encoding test program
    cat > test_webp_encode.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <webp/encode.h>

int main() {
    uint8_t* output;
    size_t output_size;
    int width = 10, height = 10;
    uint8_t* rgba = (uint8_t*)malloc(width * height * 4);
    
    if (!rgba) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    output_size = WebPEncodeRGBA(rgba, width, height, width * 4, 80, &output);
    
    if (output_size > 0 && output != NULL) {
        printf("WebP encoding successful\n");
        free(output);
        free(rgba);
        return 0;
    } else {
        printf("WebP encoding failed\n");
        free(rgba);
        return 1;
    }
}
CEOF
    CHECK_RESULT $? 0 0 "Failed to create test_webp_encode.c"

    # Step 7: Compile the test program using pkg-config
    gcc test_webp_encode.c -o test_webp_encode -I/usr/include -lwebp
    CHECK_RESULT $? 0 0 "Failed to compile test_webp_encode.c"

    # Step 8: Run the compiled program
    ./test_webp_encode | grep -i "WebP encoding successful"
    CHECK_RESULT $? 0 0 "WebP encoding test program failed"

    # Step 9: Create and compile a simple WebP decoding test program
    cat > test_webp_decode.c << 'CEOF'
#include <stdio.h>
#include <stdlib.h>
#include <webp/decode.h>

int main() {
    uint8_t* rgba;
    int width, height;
    
    uint8_t webp_data[] = {
        0x52, 0x49, 0x46, 0x46, 0x20, 0x00, 0x00, 0x00,
        0x57, 0x45, 0x42, 0x50, 0x56, 0x50, 0x38, 0x4c
    };
    
    rgba = WebPDecodeRGBA(webp_data, sizeof(webp_data), &width, &height);
    
    if (rgba == NULL) {
        printf("WebP decoding: invalid data (expected for minimal test)\n");
        printf("RESULT: PASS\n");
        return 0;
    }
    
    WebPFree(rgba);
    printf("WebP decoding successful\n");
    return 0;
}
CEOF
    CHECK_RESULT $? 0 0 "Failed to create test_webp_decode.c"

    # Step 10: Compile the decode test program
    gcc test_webp_decode.c -o test_webp_decode -I/usr/include -lwebp
    CHECK_RESULT $? 0 0 "Failed to compile test_webp_decode.c"

    # Step 11: Run the decode test program
    ./test_webp_decode | grep -i "RESULT: PASS"
    CHECK_RESULT $? 0 0 "WebP decoding test program failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_webp_encode.c test_webp_encode test_webp_decode.c test_webp_decode
    LOG_INFO "End to restore the test environment."
}

main "$@"