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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-12
# @License   :   Mulan PSL v2
# @Desc      :   gobject-introspection basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gobject-introspection gobject-introspection-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.c << EOF
#include <glib-object.h>

int main() {
  GType type = G_TYPE_OBJECT;
  const gchar* type_name = g_type_name(type);
  g_print("Type name: %s\n", type_name);

  return 0;
}
EOF
    CHECK_RESULT $? 0 0 "File creation failed"
    pkg-config --cflags --libs gobject-introspection-1.0 | xargs gcc -o test test.c
    CHECK_RESULT $? 0 0 "Compilation failed"
    test -f test
    CHECK_RESULT $? 0 0 "File generation failed"
    chmod +x test
    ./test >> testfile
    grep "Type name: GObject" testfile
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.c test testfile
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
