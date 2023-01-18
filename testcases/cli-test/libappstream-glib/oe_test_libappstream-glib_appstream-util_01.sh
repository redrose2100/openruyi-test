#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libappstream-glib command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libappstream-glib
    cp -r ./common ./glibtest
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    appstream-util -h | grep -Pz "Usage:[\S\s]*appstream-util \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-util -h failed"

    appstream-util --help | grep -Pz "Usage:[\S\s]*appstream-util \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-util --help failed"

    appstream-util --nonet search dejavu 2>&1 | grep "system\/\*/example/font/dejavu/\* (installed)"
    CHECK_RESULT $? 0 0 "Check appstream-util --nonet failed"

    appstream-util --verbose --nonet search dejavu 2>&1 | grep "A set of sans-serif font faces"
    CHECK_RESULT $? 0 0 "Check appstream-util --verbose --nonet failed"

    appstream-util --version | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check appstream-util --version failed"

    appstream-util -v --profile --nonet add-language glibtest/org.gnome.Nautilus.desktop zh_CN | grep "appstream-util: add-language"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet add-language failed"

    appstream-util -v --profile --nonet add-provide glibtest/org.example.fonttest.metainfo.xml id 1 | grep "appstream-util: add-provide"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet add-provide failed"

    appstream-util -v agreement-export glibtest/example-eula.metainfo.xml eula | grep "appstream-util: agreement-export"
    CHECK_RESULT $? 0 0 "Check appstream-util -v agreement-export failed"

    appstream-util -v --profile --nonet appdata-from-desktop glibtest/firewall-config.desktop glibtest/new.appdata.xml | grep "appstream-util: appdata-from-desktop"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet appdata-from-desktop failed"

    appstream-util -v --profile --nonet appdata-to-news glibtest/new.appdata.xml | grep "appstream-util: appdata-to-news"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet appdata-to-news failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
