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

    appstream-util -v --profile --nonet check-component dejavu | grep "Checking source: \/usr/share/metainfo/dejavu"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet check-component failed"

    appstream-util -v --profile --nonet check-root | grep "AsStore:load-installed"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet check-root failed"

    appstream-util -v --profile --nonet compare glibtest/example.xml glibtest/example_new.xml | grep "dejavu1"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet compare failed"

    appstream-util -v --profile --nonet convert glibtest/example.xml glibtest/example.xml 2.0 | grep "New API version"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet convert failed"

    appstream-util -v --profile --nonet dump glibtest/dejavu.metainfo.xml | grep "A set of sans-serif font faces"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet dump failed"

    appstream-util -v --profile --nonet generate-guid test | grep "4be0643f-1d98"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet generate-guid failed"

    appstream-util -v --profile --nonet incorporate glibtest/example.xml glibtest/help.xml glibtest/example_new.xml | grep "dejavu"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet incorporate failed"

    appstream-util -v --profile --nonet install glibtest/dejavu.metainfo.xml | grep "appstream-util: install"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet install failed"

    appstream-util -v --profile --nonet install-origin glibtest/example.xml glibtest/example_new.xml | grep "appstream-util: install-origin"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet install-origin failed"

    appstream-util -v --profile --nonet markup-import simple glibtest/example.xml | grep "xml version=&quot"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet markup-import simple failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
