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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023-04-17
# @License   :   Mulan PSL v2
# @Desc      :   automake package test
# ############################################
# shellcheck disable=SC2028

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "gcc automake make"
    mkdir /tmp/main
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    cd /tmp/main || exit
    echo '#include <stdio.h>
int main(int argc, char** argv)
{
	printf("Hello, Auto Makefile!\n");
	return 0;
}' > main.c
    autoscan
    test -e autoscan.log
    CHECK_RESULT $? 0 0 "autoscan.log fails to run"
    test -e configure.scan
    CHECK_RESULT $? 0 0 "autoscan.scan fails to run"
    mv configure.scan configure.in
    sed -i "s/^AC_INIT.*/AC_INIT(main,1.0, pgpxc@163.com)/g" configure.in
    sed -i "s/^AC_OUTPUT.*/AC_OUTPUT([Makefile])/g" configure.in
    sed -i "6i AM_INIT_AUTOMAKE(main,1.0)" configure.in
    aclocal
    test -e aclocal.m4
    CHECK_RESULT $? 0 0 "aclocal.m4 is not generated"
    autoconf
    test -e configure
    CHECK_RESULT $? 0 0 "configure is not generated"
    autoheader
    test -e config.h.in
    CHECK_RESULT $? 0 0 "config.h.in is not generated"
    echo  'AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=main
main_SOURCES=main.c' > Makefile.am
    automake --add-missing
    CHECK_RESULT $? 0 0 "Failed to add script files using automake --add-missing"
    ./configure
    CHECK_RESULT $? 0 0 "./configure fails to run"
    make
    CHECK_RESULT $? 0 0 "Makefile test fails"
    ./main | grep "Hello, Auto Makefile!"
    CHECK_RESULT $? 0 0 "main fails to run"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf /tmp/main
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
