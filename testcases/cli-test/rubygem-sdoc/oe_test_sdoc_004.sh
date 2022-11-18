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
    # test -C
    sdoc -C
    CHECK_RESULT $? 0 0 "Check sdoc -C failed"

    # test --coverage-report
    sdoc --coverage-report
    CHECK_RESULT $? 0 0 "Check sdoc --coverage-report failed"

    # test --no-coverage-report
    sdoc --no-coverage-report
    CHECK_RESULT $? 0 0 "Check sdoc --no-coverage-report failed"
    rm -rf doc

    # test --dcov
    sdoc --dcov
    CHECK_RESULT $? 0 0 "Check sdoc --dcov failed"

    # test --no-dcov
    sdoc --no-dcov
    CHECK_RESULT $? 0 0 "Check sdoc --no-dcov failed"
    rm -rf doc

    # test -i
    sdoc -i ../common
    CHECK_RESULT $? 0 0 "Check sdoc -i failed"
    rm -rf doc

    # test --include
    sdoc --include=../common
    CHECK_RESULT $? 0 0 "Check sdoc --include failed"
    rm -rf doc

    # test -f
    sdoc -f sdoc
    CHECK_RESULT $? 0 0 "Check sdoc -f failed"
    rm -rf doc

    # test --fmt
    sdoc --fmt sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --fmt failed"
    rm -rf doc

    # test --format
    sdoc --format=sdoc
    CHECK_RESULT $? 0 0 "Check sdoc --format failed"
    rm -rf doc

    # test -O
    sdoc -O
    CHECK_RESULT $? 0 0 "Check sdoc -O failed"
    rm -rf doc

    # test --force-output
    sdoc --force-output
    CHECK_RESULT $? 0 0 "Check sdoc --force-output failed"
    rm -rf doc

    # test --page-dir
    sdoc --page-dir=../common
    CHECK_RESULT $? 0 0 "Check sdoc --page-dir failed"
    rm -rf doc

    # test --root
    rootdir=$(pwd)
    sdoc --root=${rootdir}
    CHECK_RESULT $? 0 0 "Check sdoc --root failed"
    rm -rf doc

    # test --markup
    sdoc --markup=tomdoc
    CHECK_RESULT $? 0 0 "Check sdoc --markup failed"
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
