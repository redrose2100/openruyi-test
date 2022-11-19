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
		if [[ ! -d data ]]; then
        tar -xvf data.tar.gz
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    pushd data
    # test -r
    sdoc -r > tmp.txt 2>&1
    cat tmp.txt | grep "Generating RI format into"
    CHECK_RESULT $? 0 0 "Check sdoc -r failed"
    rm -rf tmp.txt doc

    # test --ri
    sdoc --ri > tmp.txt 2>&1
    cat tmp.txt | grep "Generating RI format into"
    CHECK_RESULT $? 0 0 "Check sdoc --ri failed"
    rm -rf tmp.txt doc

    # test -R
    sdoc -R > tmp.txt 2>&1
    cat tmp.txt | grep "Generating RI format into /usr/share/ri/site"
    CHECK_RESULT $? 0 0 "Check sdoc -R failed"
    rm -rf tmp.txt doc

    # test --ri-site
    sdoc --ri-site > tmp.txt 2>&1
    cat tmp.txt | grep "Generating RI format into /usr/share/ri/site"
    CHECK_RESULT $? 0 0 "Check sdoc --ri-site failed"
    rm -rf tmp.txt doc

    # test --webcvs
    sdoc --webcvs='testdemocsv'
    CHECK_RESULT $? 0 0 "Check sdoc --webcvs failed"
    rm -rf doc

    # test -W
    sdoc -W='testdemocsv'
    CHECK_RESULT $? 0 0 "Check sdoc -W failed"
    rm -rf doc

    # test --copy-files
    sdoc --copy-files="../common/hello.rb"
    CHECK_RESULT $? 0 0 "Check sdoc --copy-files failed"
    rm -rf doc

    # test -t
    sdoc -t="testdemo"
    cat doc/index.html | grep "testdemo"
    CHECK_RESULT $? 0 0 "Check sdoc -t failed"
    rm -rf doc

    # test --title
    sdoc --title="testdemo"
    cat doc/index.html | grep "testdemo"
    CHECK_RESULT $? 0 0 "Check sdoc --title failed"
    rm -rf doc

    # test --template-stylesheets
    sdoc --template-stylesheets=../common/testdemo.css
    CHECK_RESULT $? 0 0 "Check sdoc --template-stylesheets failed"
    rm -rf doc

    # test -T
    sdoc -T rails
    CHECK_RESULT $? 0 0 "Check sdoc -T failed"
    rm -rf doc

    # test --template
    sdoc --template=rails
    CHECK_RESULT $? 0 0 "Check sdoc --template failed"
    rm -rf doc

    # test -H
    sdoc -H
    CHECK_RESULT $? 0 0 "Check sdoc -H failed"
    rm -rf doc

    # test --show-hash
    sdoc --show-hash
    CHECK_RESULT $? 0 0 "Check sdoc --show-hash failed"
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
