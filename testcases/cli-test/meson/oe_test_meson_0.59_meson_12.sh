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
#@Contact       :   1048074322@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-setup
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.59/test_2.tgz&&cd test_2/builddir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson setup --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-setup --help failed"
    meson setup -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-setup  -h failed"
    meson setup --reconfigure --prefix /usr/local 2>&1 | grep "system"
    CHECK_RESULT $? 0 0 "meson-setup --prefix PREFIX failed"
    meson setup --reconfigure --bindir bin 2>&1 | grep "system"
    CHECK_RESULT $? 0 0 "meson-setup --bindir BINDIR failed"
    meson setup  --reconfigure --datadir share 2>&1 | grep "The Meson"
    CHECK_RESULT $? 0 0 "meson-setup  --prefix PREFIX failed"
    meson setup --reconfigure --includedir include 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-setup  --includedir INCLUDEDIR failed"
    meson setup --reconfigure --infodir share/info 2>&1 | grep "The Meson"
    CHECK_RESULT $? 0 0 "meson-setup --infodir INFODIR failed"
    meson setup --reconfigure --libdir lib64 2>&1 | grep "system"
    CHECK_RESULT $? 0 0 "meson-setup --libdir LIBDIR failed"
    meson setup --reconfigure --libexecdir libexec 2>&1 | grep "build system"
    CHECK_RESULT $? 0 0 "meson-setup --libexecdir LIBEXECDIR failed"
    meson setup --reconfigure --localedir share/locale 2>&1 | grep "system"
    CHECK_RESULT $? 0 0 "meson-setup --localedir LOCALDIR failed"
    meson setup --reconfigure --localstatedir  var 2>&1 | grep "system"
    CHECK_RESULT $? 0 0 "meson-setup --localstatedir LOCALSTATDIR failed"
    meson setup --reconfigure --mandir share/man 2>&1 | grep "The Meson"
    CHECK_RESULT $? 0 0 "meson-setup --mandir MANDIR failed"
    LOG_INFO "Finish test!"

}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../../test_2
    LOG_INFO "End to restore the test environment."
}

main "$@"