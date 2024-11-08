#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-4
# @License   :   Mulan PSL v2
# @Desc      :   Use librhsm case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson glib json-glib-debuginfo json-glib-debugsource json-glib-devel json-glib-help glib-help ninja-build"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir /tmp/librhsm_build
    CHECK_RESULT $? 0 0 "Error,Fail to create directory"
    cat > /tmp/librhsm_build/meson.build << EOF
project('librhsm', 'c',
        version : '0.0.3',
        license : 'LGPL-2.1+',
        default_options : [
          'b_asneeded=True',
          'b_lundef=True',
          'c_std=gnu11',
          'warning_level=2',
        ],
        meson_version : '>=0.37.0')

glib = dependency('glib-2.0', version : '>=2.44')
gobject = dependency('gobject-2.0', version : '>=2.44')
gio = dependency('gio-2.0', version : '>=2.44')
json_glib = dependency('json-glib-1.0', version : '>=1.2')

EOF
    CHECK_RESULT $? 0 0 "Error, save the file permission denied"
    cd /tmp/librhsm_build && meson librhsm_build | grep 'The Meson build system'
    CHECK_RESULT $? 0 0 "Error, Check if the command is correct "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/librhsm_build
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
