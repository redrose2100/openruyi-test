#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.11.13
# @License   :   Mulan PSL v2
# @Desc      :   zziplib formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    touch /tmp/11.txt && zip /tmp/test.zip /tmp/11.txt    
    cat > /tmp/example.c << EOF
#include <zzip/zzip.h>
#include <stdio.h>
#include <stdlib.h>
int main()
{
    ZZIP_DIR* dir = zzip_dir_open("/tmp/test.zip", 0);
    if (!dir)
    {
        printf("Failed to open the directory\n");
        return -1;
    }

    ZZIP_DIRENT dirent;
    while(zzip_dir_read(dir, &dirent))
    {
        printf("%s\n", dirent.d_name);
    }

    zzip_dir_close(dir);
    return 0;
}
EOF

    DNF_INSTALL "zziplib zziplib-devel zziplib-help gcc unzip"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep zziplib
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc example.c -lzzip -o example
    test -f /tmp/example
    CHECK_RESULT $? 0 0 "compile example.c fail"
    ./example > example.txt
    grep "11.txt" /tmp/example.txt    
    CHECK_RESULT $? 0 0 "execute example.txt fail"
    unzip -l test.zip > example1.txt
    grep "11.txt" /tmp/example1.txt
    CHECK_RESULT $? 0 0 "execute example1.txt fail"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/example /tmp/example.c  /tmp/example.txt /tmp/example1.txt /tmp/11.txt /tmp/test.zip
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
