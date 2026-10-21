#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-08-24
#@License       :   Mulan PSL v2
#@Desc          :   Manually create and apply a LibcarePlus hot patch
#####################################
# shellcheck disable=SC1091

source common/common_libcareplus.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_env
    DNF_INSTALL gcc
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Manually create LibcarePlus hot patches
    gcc -S foo.c
    CHECK_RESULT $? 0 0 "Failed to compile file: foo.c"
    gcc -S bar.c
    CHECK_RESULT $? 0 0 "Failed to compile file: bar.c"
    sed -i 's/bar.c/foo.c/' bar.s
    CHECK_RESULT $? 0 0 "Failed to rename the patch assembly file"
    kpatch_gensrc --os=rhel6 -i foo.s -i bar.s -o foobar.s --force-global
    CHECK_RESULT $? 0 0 "Failed to compare using kpatch_gensrc"
    test -f foobar.s
    CHECK_RESULT $? 0 0 "Failed to generate the file: foobar.s"
    gcc -o foo foo.s
    CHECK_RESULT $? 0 0 "Failed to generate the executable file: foo"
    gcc -o foobar foobar.s -Wl,-q
    CHECK_RESULT $? 0 0 "Failed to generate the executable file: foobar"
    kpatch_strip --strip foobar foobar.stripped
    CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --strip"
    kpatch_strip --rel-fixup foo foobar.stripped
    CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --rel-fixup"
    strip --strip-unneeded foobar.stripped
    CHECK_RESULT $? 0 0 "Failed to execute strip --strip-unneeded"
    kpatch_strip --undo-link foo foobar.stripped
    CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --undo-link"
    test -f foobar.stripped
    CHECK_RESULT $? 0 0 "Failed to generate output file: foobar.stripped"
    str=$(readelf -n foo | grep 'Build ID')
    substr=${str##* }
    kpatch_make -b "$substr" -i 0001 foobar.stripped -o foo.kpatch
    CHECK_RESULT $? 0 0 "Failed to execute kpatch_make"
    test -f foo.kpatch
    CHECK_RESULT $? 0 0 "Failed to generate hot patches file: foo.kpatch"
    ./foo &
    CHECK_RESULT $? 0 0 "Failed to run ./foo"
    libcare-ctl -v patch -p "$(pidof foo)" ./foo.kpatch | grep "patch hunk(s) have been successfully applied"
    CHECK_RESULT $? 0 0 "Failed to apply the hot patch"
    # Query hot patch
    libcare-ctl info -p "$(pidof foo)" | grep "Applied patch number"
    CHECK_RESULT $? 0 0 "Failed to query the LibcarePlus hot patches"
    # Uninstall hot patch
    libcare-ctl unpatch -p "$(pidof foo)" -i 0001 | grep "patch hunk(s) were successfully cancelled"
    CHECK_RESULT $? 0 0 "Failed to uninstall the LibcarePlus hot patches"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
