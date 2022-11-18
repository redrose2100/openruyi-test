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
    # test -N
    sdoc -N
    CHECK_RESULT $? 0 0 "Check sdoc -N failed"
    rm -rf doc

    # test --line-numbers
    sdoc --line-numbers
    CHECK_RESULT $? 0 0 "Check sdoc --line-numbers failed"
    rm -rf doc

    # test --no-line-numbers
    sdoc --no-line-numbers
    CHECK_RESULT $? 0 0 "Check sdoc --no-line-numbers failed"
    rm -rf doc

    # test --main
    sdoc --main=README.rdoc
    CHECK_RESULT $? 0 0 "Check sdoc --main failed"
    rm -rf doc

    # test -m 
    sdoc -m README.rdoc
    CHECK_RESULT $? 0 0 "Check sdoc -m failed"
    rm -rf doc

    # test --hyperlink-all
    sdoc --hyperlink-all
    CHECK_RESULT $? 0 0 "Check sdoc --hyperlink-all failed"
    rm -rf doc

    # test -A
    sdoc -A
    CHECK_RESULT $? 0 0 "Check sdoc -A failed"
    rm -rf doc

    # test --charset
    sdoc --charset=UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc --charset failed"
    rm -rf doc

    # test -c
    sdoc -c UTF-8
    CHECK_RESULT $? 0 0 "Check sdoc -c failed"
    rm -rf doc

    # test -d
    sdoc -d
    CHECK_RESULT $? 0 0 "Check sdoc -d failed"
    rm -rf doc

    # tets -o
    sdoc -o tmpdir
    if [[ -d tmpdir ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc -o failed"
    rm -rf tmpdir

    # test --output
    sdoc --output tmpdir
    if [[ -d tmpdir ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc --output failed"
    rm -rf tmpdir
    
    # tets --op
    sdoc --op=tmpd
    if [[ -d tmpd ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc --op failed"
    rm -rf tmpd

    popd
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
