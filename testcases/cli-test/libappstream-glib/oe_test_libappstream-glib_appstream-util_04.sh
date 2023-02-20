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

    appstream-util -v --profile --nonet search-category dejavu | grep "appstream-util: search-category"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search-category failed"

    appstream-util -v --profile --nonet search-pkgname dejavu | grep "appstream-util: search-pkgname"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search-pkgname failed"

    appstream-util -v --profile --nonet show-search-tokens dejavu | grep "exampl \[1]"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet show-search-tokens failed"

    appstream-util -v --profile --nonet split-appstream glibtest/example.xml.gz | grep "appstream-util: split-appstream"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet split-appstream failed"

    appstream-util -v --profile --nonet status-csv glibtest/example.xml glibtest/tatus.csv | grep "appstream-util: status-csv"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet status-csv failed"

    appstream-util -v status-html glibtest/example-v06.yml.gz glibtest/status.html | grep "appstream-util: status-html"
    CHECK_RESULT $? 0 0 "Check appstream-util -v status-html failed"

    appstream-util -v --profile --nonet uninstall glibtest/dejavu.metainfo.xml | grep "appstream-util: uninstall"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet uninstall failed"

    appstream-util -v --profile --nonet upgrade glibtest/example.xml | grep "New API version"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet upgrade failed"

    appstream-util -v --profile --nonet validate glibtest/dejavu.metainfo.xml 2>&1  | grep "appstream-util: validate"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate failed"

    appstream-util -v --profile --nonet validate-relax glibtest/dejavu.metainfo.xml | grep "appstream-util: validate-relax"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet validate-relax failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
