#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   liuzhaoda
#@Contact       :   1048074322@@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-configure
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson"
    cd ./common/0.54/
    tar -xvf test_1.tgz
    cd ./../../
    cp -rf ./common/0.54/test_1 ./
    cd ./test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson configure --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-configure--help failed"
    meson configure -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-configure -h failed"
    meson configure --prefix /usr/local 2>&1 | grep "prefix"
    CHECK_RESULT $? 0 0 "meson-configure -prefix failed"
    meson configure --bindir bin 2>&1 | grep "bindir"
    CHECK_RESULT $? 0 0 "meson-configure --bindir BINDIR failed"
    meson configure --datadir share 2>&1 | grep "datadir"
    CHECK_RESULT $? 0 0 "meson-configure --datadir DATADIR failed"
    meson configure --includedir include 2>&1 | grep "includedir"
    CHECK_RESULT $? 0 0 "meson-configure --includedir INCLUDEDIR failed"
    meson configure --infodir share/info 2>&1 | grep "infodir"
    CHECK_RESULT $? 0 0 "meson-configure --infodir INFODIR failed"
    meson configure --libdir lib64 2>&1 | grep "libdir"
    CHECK_RESULT $? 0 0 "meson-configure --libdir LIBDIR failed"
    meson configure --libexecdir libexec 2>&1 | grep "libexecdir"
    CHECK_RESULT $? 0 0 "meson-configure --libexecdir LIBEXECDIR failed"
    meson configure --localedir share/locale 2>&1 | grep "localedir"
    CHECK_RESULT $? 0 0 "meson-configure --localedir LOCALDIR failed"
    meson configure --localstatedir var 2>&1 | grep "localstatedir"
    CHECK_RESULT $? 0 0 "meson-configure --localstatedir LOCALSTATDIR failed"
    meson configure --mandir share/man 2>&1 | grep "mandir"
    CHECK_RESULT $? 0 0 "meson-configure --mandir MANDIR failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./../test_1
    rm -rf ./../common/0.54/test_1
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"