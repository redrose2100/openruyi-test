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
    mkdir -p glibtest/pkg
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    appstream-builder -h | grep -Pz "Usage:[\S\s]*appstream-builder \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-builder -h failed"

    appstream-builder --help | grep -Pz "Usage:[\S\s]*appstream-builder \[OPTION…\]"
    CHECK_RESULT $? 0 0 "Check appstream-builder --help failed"

    appstream-builder -v --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder --verbose --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder --verbose --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --add-cache-id id --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --add-cache-id id --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --include-failed --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --include-failed --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --enable-hidpi --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --enable-hidpi --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --enable-embed --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --enable-embed --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --uncompressed-icons --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --uncompressed-icons --packages-dir --origin failed"

    rm -rf cache example-ignore.xml.gz  example.xml.gz tepmtest
    appstream-builder -v --log-dir glibtest/logs --packages-dir glibtest/pkg --origin metadata && test -f example.xml.gz
    CHECK_RESULT $? 0 0 "Check appstream-builder -v --log-dir --packages-dir --origin metadata failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf glibtest cache tmp *.gz
    LOG_INFO "Finish restore the test environment."
}

main "$@"
