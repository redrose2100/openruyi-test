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
    # test -h
    sdoc -h | grep "Usage: sdoc"
    CHECK_RESULT $? 0 0 "Check sdoc -h failed"

    # test --help
    sdoc --help | grep "Usage: sdoc"
    CHECK_RESULT $? 0 0 "Check sdoc --help failed"

    # test -v
    sdoc -v | grep -e "sdoc [0-9].[0-9].[0-9]"
    CHECK_RESULT $? 0 0 "Check sdoc -v failed"

    # test --version
    sdoc --version | grep -e "sdoc [0-9].[0-9].[0-9]"
    CHECK_RESULT $? 0 0 "Check sdoc --version failed"

    # test -V
    sdoc -V | grep "template/rails/index.rhtml"
    CHECK_RESULT $? 0 0 "Check sdoc -V failed"
    rm -rf doc

    # test --verbose
    sdoc --verbose | grep "template/rails/index.rhtml"
    CHECK_RESULT $? 0 0 "Check sdoc --verbose failed"
    rm -rf doc

    # test -q
    sdoc -q
    if [[ -d doc ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc -q failed"
    rm -rf doc

    # test --quiet
    sdoc --quiet
    if [[ -d doc ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc --quiet failed"
    rm -rf doc

    # test --ignore-invalid
    sdoc --dwasda --ignore-invalid > tmp.txt 2>&1
    cat tmp.txt  | grep "invalid options: --dwasda"
    CHECK_RESULT $? 0 0 "Check sdoc --ignore-invalid failed"
    rm -rf doc tmp.txt

    # test --no-ignore-invalid
    sdoc --no-ignore-invalid --asdawd
    CHECK_RESULT $? 1 0 "Check sdoc --ignore-invalid failed"

    # test -D
    sdoc -D | grep "install -c -p -m 644"
    CHECK_RESULT $? 0 0 "Check sdoc -D failed"
    rm -rf doc

    # test --debug
    sdoc --debug | grep "install -c -p -m 644"
    CHECK_RESULT $? 0 0 "Check sdoc --debug failed"
    rm -rf doc

    # test --no-debug
    sdoc --no-debug | grep "Constants:"
    CHECK_RESULT $? 0 0 "Check sdoc --no-debug failed"
    rm -rf doc

    # test --dry-run
    sdoc --dry-run  > tmp.txt 2>&1
    cat tmp.txt  | grep "Generating SDoc format into"
    CHECK_RESULT $? 1 0 "Check sdoc --dry-run failed"
    rm -f tmp.txt

    # test --no-dry-run
    sdoc --no-dry-run  > tmp.txt 2>&1
    cat tmp.txt  | grep "Generating SDoc format into"
    result=$?
    if [[ -d doc ]] && [[ ${result} == 0 ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "Check sdoc --no-dry-run failed"
    rm -rf doc

    # test --write-options
    sdoc --markup rdoc --write-options
    cat .rdoc_options  | grep "markup: rdoc"
    CHECK_RESULT $? 0 0 "Check sdoc --write-options failed"
    rm -f .rdoc_options 

    popd
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
