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
# @Desc      :   Test sdoc-merge
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL rubygem-sdoc
    sdoc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # test -h
    sdoc-merge -h | grep "Usage: sdoc-merge"
    CHECK_RESULT $? 0 0 "Check sdoc-merge -h failed"

    # test --title
    pushd ./mergedata
        sdoc-merge --title "Ruby v1.9, Rails v2.3.2.1"  rubydemo rails
        cat ./doc/index.html | grep -risn "Ruby v1.9, Rails v2.3.2.1"
        CHECK_RESULT $? 0 0 "Check sdoc-merge --title failed"
        rm -rf ./doc
    popd

    # test -t
    pushd ./mergedata
        sdoc-merge -t "Ruby v1.9, Rails v2.3.2.1"  rubydemo rails
        cat ./doc/index.html | grep -risn "Ruby v1.9, Rails v2.3.2.1"
        CHECK_RESULT $? 0 0 "Check sdoc-merge -t failed"
        rm -rf ./doc
    popd

    # test -u
    pushd ./mergedata
        sdoc-merge -u "testurldemo xxxx" rails rubydemo
        cat ./doc/index.html | grep "testurldemo/files"
        CHECK_RESULT $? 0 0 "Check sdoc-merge -u failed"
        rm -rf ./doc
    popd

    # test --urls
    pushd ./mergedata
        sdoc-merge --urls "testurldemo xxxx" rails rubydemo
        cat ./doc/index.html | grep "testurldemo/files"
        CHECK_RESULT $? 0 0 "Check sdoc-merge --urls failed"
        rm -rf ./doc
    popd

    # test --op
    pushd ./mergedata
        sdoc-merge --op tmpdemo  rubydemo rails
        if [[ -d tmpdemo ]]; then
            echo "aa" | grep "aa"
        else
            echo "aa" | grep "bb"
        fi
        CHECK_RESULT $? 0 0 "Check sdoc-merge --op failed"
        rm -rf tmpdemo
    popd

    # test -o
    pushd ./mergedata
        sdoc-merge -o tmpdemo  rubydemo rails
        if [[ -d tmpdemo ]]; then
            echo "aa" | grep "aa"
        else
            echo "aa" | grep "bb"
        fi
        CHECK_RESULT $? 0 0 "Check sdoc-merge -o failed"
        rm -rf tmpdemo
    popd

    # test --names
    pushd ./mergedata
        sdoc-merge --names "Rubyxxx,Railsxxx"  rubydemo rails
        if [[ -d ./doc/Rubyxxx ]] && [[ -d ./doc/Railsxxx ]]; then
            echo "aa" | grep "aa"
        else
            echo "aa" | grep "bb"
        fi
        CHECK_RESULT $? 0 0 "Check sdoc-merge --names failed"
        rm -rf doc
    popd

    # test -n
    pushd ./mergedata
        sdoc-merge -n "Rubyxxx,Railsxxx"  rubydemo rails
        if [[ -d ./doc/Rubyxxx ]] && [[ -d ./doc/Railsxxx ]]; then
            echo "aa" | grep "aa"
        else
            echo "aa" | grep "bb"
        fi
        CHECK_RESULT $? 0 0 "Check sdoc-merge -n failed"
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
