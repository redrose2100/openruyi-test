#!/usr/bin/bash

# Copyright (c) 2024  INSPUR Co., Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   koulq
# @Contact   :   koulq@inspur.com
# @Date      :   2024.3.23
# @License   :   Mulan PSL v2
# @Desc      :   Test libxpm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."

    cat > /tmp/example.xpm  <<EOF
/* XPM */
static char * example_xpm[] = {
/* width height num_colors chars_per_pixel */
"16 16 3 1",
/* colors */
"   c None",
".  c #000000",
"+  c #FFFFFF",
/* pixels */
"                ",
"   ..........   ",
"  .          .  ",
" .            . ",
" .   ......   . ",
" .   .    .   . ",
" .   .    .   . ",
" .   ......   . ",
" .            . ",
" .            . ",
" .   ......   . ",
" .   .    .   . ",
" .   .    .   . ",
" .   ......   . ",
"  .          .  ",
"   ..........   "
};

EOF
    cat > /tmp/test-libxpm.c  <<EOF
#include <stdio.h>
#include <stdlib.h>
#include <X11/xpm.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <xpm_file>\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];

    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error: Unable to open file %s\n", filename);
        return 1;
    }

    XpmImage xpm_image;
    int result = XpmReadFileToXpmImage(filename, &xpm_image, NULL);
    if (result != XpmSuccess) {
        printf("Error: Unable to read XPM file %s\n", filename);
        return 1;
    }

    printf("XPM Image width: %d\n", xpm_image.width);
    printf("XPM Image height: %d\n", xpm_image.height);
    printf("Number of colors: %d\n", xpm_image.ncolors);

    printf("XPM Image data:\n");
    for (int i = 0; i < xpm_image.height; i++) {
        printf("%s\n", xpm_image.data[i]);
    }

    XpmFree(xpm_image.data);

    return 0;
}
EOF
    DNF_INSTALL "gcc libXpm-devel libX11-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp && gcc -o test-libxpm test-libxpm.c -lXpm
    CHECK_RESULT $? 0 0 "The compilation failed"
    test -e /tmp/test-libxpm
    CHECK_RESULT $? 0 0 "test-libxpm not exit"
    cd /tmp && ./test-libxpm example.xpm
    CHECK_RESULT $? 0 0 "Return value error"
    LOG_INFO "End to run test."  
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test-libxpm.c /tmp/test-libxpm /tmp/example.xpm
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

