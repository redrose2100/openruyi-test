#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   LiuZiyi
# @Contact   :   lavandejoey@outlook.com
# @Date      :   2022/6/23
# @Desc      :   Test "autoheader-2.13" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
DIR="${OET_PATH}/testcases/cli-test/autoconf213"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # [-m dir] [--macrodir=dir] [-l dir] [--localdir=dir] [template-file]
    DNF_INSTALL autoconf213

    # init test files
    cd "$DIR"/common || exit
    cp configure_autoconf.in configure.in

    # test_macro
    cp -r /usr/share/autoconf-2.13 ./test-macro
    LOG_INFO "Test environment is ready."
}

function run_test() {
  LOG_INFO "Start to run test."

    autoheader-2.13 --help  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --help run failed"
    autoheader-2.13 -h  2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 -h run failed"
    autoheader-2.13 --version  2>&1 | grep "Autoconf"
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 --version run failed"

    cd "$DIR"/common/ || exit
    autoheader-2.13 2>&1
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 run failed."
    test -f config.h.in
    CHECK_RESULT $? 0 0 "Error: config.h.in file failed to generate."

    rm -f config.h.in

    # with Library directories [-l dir] [--localdir=dir]
    autoheader-2.13 --localdir="$DIR"/common/test-macro/acconfig.h 2>&1
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--localdir] run failed."
    test -f config.h.in
    CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

    rm -f config.h.in
    autoheader-2.13 -l "$DIR"/common/test-macro/acconfig.h 2>&1
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-l] run failed."
    test -f config.h.in
    CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

    # with custom MACRO [--macrodir=dir] [-m dir]
    rm -f config.h.in
    autoheader-2.13 --macrodir="$DIR"/common/test-macro 2>&1
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [--macrodir] run failed."
    test -f config.h.in
    CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

    rm -f config.h.in
    autoheader-2.13 -m "$DIR"/common/test-macro 2>&1
    CHECK_RESULT $? 0 0 "Error: autoheader-2.13 [-m] run failed."
    test -f config.h.in
    CHECK_RESULT $? 0 0 "Error: [-m] configure file failed to generate."

    LOG_INFO "End to run test."
}

function post_test() {
    DNF_REMOVE
    cd "$DIR"/common || exit
    rm -rf config.h.in configure.in test-macro
    LOG_INFO "Test environment restored."
}

main "$@"
