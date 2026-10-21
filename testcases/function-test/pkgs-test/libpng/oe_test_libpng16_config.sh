#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/08/06
# @License   :   Mulan PSL v2
# @Desc      :   Verify libpng16-config tool
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libpng-tools libpng-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q libpng-tools | grep "libpng-tools"
    CHECK_RESULT $? 0 0 "libpng-tools package not installed"
    test -f /usr/bin/libpng16-config
    CHECK_RESULT $? 0 0 "libpng16-config binary missing"
    libpng16-config --help | grep -i "usage\|libpng16-config"
    CHECK_RESULT $? 0 0 "libpng16-config --help failed"
    libpng16-config --version | grep -E "[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "libpng16-config --version failed"
    libpng16-config --prefix | grep "^/usr"
    CHECK_RESULT $? 0 0 "libpng16-config --prefix failed"
    libpng16-config --libdir | grep "^/usr/lib64"
    CHECK_RESULT $? 0 0 "libpng16-config --libdir failed"
    libpng16-config --cflags | grep "\-I"
    CHECK_RESULT $? 0 0 "libpng16-config --cflags failed"
    libpng16-config --I_opts | grep "\-I"
    CHECK_RESULT $? 0 0 "libpng16-config --I_opts failed"
    libpng16-config --L_opts | grep "\-L"
    CHECK_RESULT $? 0 0 "libpng16-config --L_opts failed"
    libpng16-config --ldflags | grep "\-lpng"
    CHECK_RESULT $? 0 0 "libpng16-config --ldflags failed"
    libpng16-config --libs | grep "\-lpng"
    CHECK_RESULT $? 0 0 "libpng16-config --libs failed"
    libpng16-config --static --libs | grep "\-lpng"
    CHECK_RESULT $? 0 0 "libpng16-config --static failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

