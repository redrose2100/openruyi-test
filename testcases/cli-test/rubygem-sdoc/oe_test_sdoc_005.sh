#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   朱文硕
# @Contact   :   1003254035@qq.com
# @Date      :   2022/08/29
# @License   :   Mulan PSL v2
# @Desc      :   Test sdoc
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rubygem-sdoc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    pushd data
    # test --visibility
    sdoc --visibility=private
    CHECK_RESULT $? 0 0 "Check sdoc --visibility failed"
    rm -rf doc

    # test -w
    sdoc -w 10
    CHECK_RESULT $? 0 0 "Check sdoc -w failed"
    rm -rf doc

    # test --tab-width
    sdoc --tab-width=15
    CHECK_RESULT $? 0 0 "Check sdoc --tab-width failed"
    rm -rf doc

    # test -U
    sdoc -U
    CHECK_RESULT $? 0 0 "Check sdoc -U failed"
    rm -rf doc

    # test --no-force-update
    sdoc --no-force-update
    CHECK_RESULT $? 0 0 "Check sdoc --no-force-update failed"
    rm -rf doc

    # test -E
    sdoc -E cgi=rb
    CHECK_RESULT $? 0 0 "Check sdoc -E failed"
    rm -rf doc

    # test --extension
    sdoc --extension cgi=rb
    CHECK_RESULT $? 0 0 "Check sdoc --extension failed"
    rm -rf doc

    # test -x
    sdoc -x sdoc | grep "Files:      18"
    CHECK_RESULT $? 0 0 "Check sdoc -x failed"
    rm -rf doc

    # test --exclude
    sdoc --exclude=sdoc | grep "Files:      18"
    CHECK_RESULT $? 0 0 "Check sdoc --exclude failed"
    rm -rf doc

    # test -a
    sdoc -a
    CHECK_RESULT $? 0 0 "Check sdoc -a failed"
    rm -rf doc

    # test --all
    sdoc --all
    CHECK_RESULT $? 0 0 "Check sdoc --all failed"
    rm -rf doc

    # test --locale-data-dir 
    sdoc --locale-data-dir=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --locale-data-dir failed"
    rm -rf doc

    # test --locale
    sdoc --locale=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --locale failed"
    rm -rf doc

    # test -e
    sdoc -e UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc -e failed"
    rm -rf doc

    # test --encoding
    sdoc --encoding UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc --encoding failed"
    rm -rf doc

    popd
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
