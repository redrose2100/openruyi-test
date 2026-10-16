#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.7.29
# @License   :   Mulan PSL v2
# @Desc      :   xml2-config formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	LOG_INFO "Start environmental preparation."
	DNF_INSTALL "libxml2-devel"
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    res1=$(xml2-config --cflags)
    [ "$res1" == "-I/usr/include/libxml2" ]
    CHECK_RESULT $? 0 0 "xml2-config error"
    LOG_INFO "End to run test."
    res2=$(xml2-config --libs)
    [ "$res2" == "-lxml2 -lz -llzma -lm" ]
    CHECK_RESULT $? 0 0 "xml2-config error"
    xml2-config --modules | grep -E "^[01]$"
    CHECK_RESULT $? 0 0 "xml2-config modules returned invalid value"
    xml2-config --prefix  | grep usr
    CHECK_RESULT $? 0 0 "xml2-config prefix failed"
    xml2-config --exec-prefix | grep usr
    CHECK_RESULT $? 0 0 "xml2-config exec-prefix failed"
    xml2-config --version | grep -E "^[0-9]+\.[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "xml2-config version format error"
    xml2-config --help | grep -qi "Usage:"
    CHECK_RESULT $? 0 0 "xml2-config help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
