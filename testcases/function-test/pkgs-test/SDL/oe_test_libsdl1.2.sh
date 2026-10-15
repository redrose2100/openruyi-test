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
# @Date      :   2023.9.1
# @License   :   Mulan PSL v2
# @Desc      :   libsdl1.2 formatting test
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/test_sdl.c << EOF
#include <stdio.h>
#include <SDL/SDL.h>

int main(void)
{
    if (SDL_Init(SDL_INIT_VIDEO))
    {   
        printf("Couldn't initialize SDL - %s\n", SDL_GetError());
    }   
    else
    {   
         printf("Success init SDL\n");
    }   

    return 0;
}
EOF

    DNF_INSTALL "SDL SDL-devel gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep SDL
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc test_sdl.c -o test_sdl -lSDL -lSDLmain
    test -f /tmp/test_sdl
    CHECK_RESULT $? 0 0 "compile test_sdl.c fail"
    ./test_sdl > /tmp/test
    grep "Success init SDL" /tmp/test
    CHECK_RESULT $? 0 0 "execute test_sdl fail"    
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test /tmp/test_sdl.c /tmp/test_sdl
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
