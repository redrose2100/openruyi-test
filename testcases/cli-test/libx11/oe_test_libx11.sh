#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/04/03
# @License   :   Mulan PSL v2
# @Desc      :   test libx11
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "libX11 libX11-devel"
  mkdir /tmp/test
  cat > /tmp/test/test.c <<EOF
#include <stdio.h>
#include <X11/Xutil.h>
#include <X11/XKBlib.h>
int main(int argc, char **argv)
{
        XEvent e;
        Display *d;
        if (!(d = XOpenDisplay(NULL))) {
                fprintf(stderr, "cannot open display\n");
                return 1;
        }
        XKeysymToKeycode(d, XK_F1);
    int xkbEventType;
    XkbQueryExtension(d, 0, &xkbEventType, 0, 0, 0);
    XkbSelectEvents(d, XkbUseCoreKbd, XkbAllEventsMask, XkbAllEventsMask);
    XSync(d, False);
    while (1) {
        XNextEvent(d, &e);
        if (e.type == xkbEventType) {
            XkbEvent* xkbEvent = (XkbEvent*) &e;
            if (xkbEvent->any.xkb_type == XkbStateNotify) {
                int lang = xkbEvent->state.group;
                if (lang == 1) {
                    fprintf(stdout, "1\n");
                    fflush(stdout);
                } else {
                    fprintf(stdout, "0\n");
                    fflush(stdout);
                }
            }
        }
    }
    return(0);
}
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cd /tmp/test && gcc -Wall -O2 test.c -o test -lX11
  CHECK_RESULT $? 0 0 "lx11 failure"
  test -e /tmp/test/test
  CHECK_RESULT $? 0 0 "test not exit"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf /tmp/test
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
