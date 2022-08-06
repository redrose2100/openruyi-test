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
# @Desc      :   Test "autoreconf-2.13" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL autoconf213

    dir=$(pwd)
    # test_macro
    cd common || exit
    cp -r /usr/share/autoconf-2.13 test-macro
    # init configure files
    cp configure_autoreconf.in configure.in
    autoconf-2.13 2>&1
    CHECK_RESULT $? 0 0 "Error: autoconf-2.13 run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
    cp configure configure.bak

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    autoreconf-2.13 --help  2>&1 | grep "Usage: autoreconf"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --help run failed"
    autoreconf-2.13 --h  2>&1 | grep "Usage: autoreconf"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 -h run failed"
    autoreconf-2.13 --version  2>&1 | grep "Autoconf version"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 --version run failed"

    # run test command
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 2>&1
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: configure file failed to generate."
    # check the result
    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # with Library directories [-l dir] [--localdir=dir]
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --localdir="$dir"/common/test-macro/acconfig.h 2>&1
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--localdir] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--localdir] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--localdir] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 -l "$dir"/common/test-macro/acconfig.h 2>&1
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-l] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [-l] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [-l] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # with custom MACRO [--macrodir=dir]
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --macrodir="$dir"/common/test-macro 2>&1
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--macrodir] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--macrodir] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--macrodir] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [--verbose]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--verbose] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--verbose] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--verbose] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [--force]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --force --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--force] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--force] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--force] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [--cygnus]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --cygnus --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--cygnus] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--cygnus] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--cygnus] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [--foreign]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --foreign --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--foreign] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--foreign] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--foreign] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    #  [--gnits]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --gnits --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnits] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--gnits] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--gnits] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [--gnu]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --gnu --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--gnu] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--gnu] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--gnu] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    # [-i] [--include-deps]
    rm -f "$dir"/common/configure
    sed -i 's/Makefile/Makefilere/g' "$dir"/common/configure.in
    autoreconf-2.13 -i --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [-i] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [-i] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [-i] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    rm -f configure
    sed -i 's/Makefile/Makefilere/g' configure.in
    autoreconf-2.13 --include-deps --verbose 2>&1 | grep "running"
    CHECK_RESULT $? 0 0 "Error: autoreconf-2.13 [--include-deps] run failed."
    test -f configure
    CHECK_RESULT $? 0 0 "Error: [--include-deps] configure file failed to generate."

    diff configure configure.bak | grep "Makefilere"
    CHECK_RESULT $? 0 0 "Error: autoreconf [--include-deps] failed to re-config."
    sed -i 's/Makefilere/Makefile/g' configure.in
    cp -f configure.bak configure

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf configure.in configure configure.bak test-macro
    cd "$dir" || exit
    LOG_INFO "End to restore the test environment."
}

main "$@"
