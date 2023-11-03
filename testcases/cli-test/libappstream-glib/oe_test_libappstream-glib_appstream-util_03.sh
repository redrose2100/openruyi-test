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

    appstream-util -v --profile --nonet matrix-html glibtest/example.xml.gz glibtest/matrix.html && test -f glibtest/matrix.html
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet matrix-html failed"

    appstream-util -v --profile --nonet merge-appstream glibtest/output.xml glibtest/example.xml glibtest/example_new.xml | grep "appstream-util: merge-appstream"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet merge-appstream failed"

    appstream-util -v --profile --nonet mirror-screenshots glibtest/example.xml.gz glibtest/ glibtest/test | grep "appstream-util: mirror-screenshots"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet mirror-screenshots failed"

    appstream-util -v --profile --nonet modify glibtest/new.appdata.xml type test | grep "appstream-util: modify"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet modify failed"

    nohup appstream-util -v --profile --nonet news-to-appdata glibtest/new.appdata.xml >glibtest/info1.log 2>&1 &
    SLEEP_WAIT  2
    grep "Configuración del cortafuegos"  glibtest/info1.log
    CHECK_RESULT $? 0 0 "Check nohup appstream-util -v --profile --nonet news-to-appdata failed"

    appstream-util -v --profile --nonet non-package-yaml glibtest/example.xml.gz glibtest/applications-to-import.yaml | grep "appstream-util: non-package-yaml"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet non-package-yaml failed"

    appstream-util -v --profile --nonet query-installed 2>&1 | grep "http://www.ezix.org/project/wiki/HardwareLiSter"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet query-installed failed"

    appstream-util -v --profile --nonet regex [0-4] 3
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet regex failed"

    appstream-util -v --profile --nonet replace-screenshots glibtest/gcr-prompter.desktop test | grep "appstream-util: replace-screenshots"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet replace-screenshots failed"

    appstream-util -v --profile --nonet search dejavu-sans 2>&1 | grep "appstream-util: search"
    CHECK_RESULT $? 0 0 "Check appstream-util -v --profile --nonet search failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest screenshots
    LOG_INFO "Finish restore the test environment."
}

main "$@"
