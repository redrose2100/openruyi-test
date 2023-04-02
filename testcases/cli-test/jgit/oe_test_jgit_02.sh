#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test jgit
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "jgit tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    pojpath=$(
    cd "$(dirname "$0")" || exit 1
        pwd
    )
    mkdir /tmp/jgitdemo
    pushd /tmp/jgitdemo
    jgit clone https://gitee.com/gittyee/demo.git
    pushd /tmp/jgitdemo/demo
    touch demo.txt
    jgit add demo.txt
    jgit commit -m "test demo"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pushd /tmp/jgitdemo/demo
    jgit gc 2>&1 | grep "Prune loose, unreferenced objects"
    CHECK_RESULT $? 0 0 "Check jgit gc failed"
    pushd /tmp/jgitdemo
    mkdir demoinit
    pushd /tmp/jgitdemo/demoinit
    jgit init
    test -d .git
    CHECK_RESULT $? 0 0 "Check jgit init failed"
    pushd /tmp/jgitdemo/demo
    jgit log -n 1 | grep "test demo"
    CHECK_RESULT $? 0 0 "Check jgit log failed"
    num=$(jgit ls-files | wc -l)
    test ${num} -gt 0
    CHECK_RESULT $? 0 0 "Check jgit ls-files failed"
    jgit ls-remote https://gitee.com/gittyee/demo.git | grep "refs/heads/dev"
    CHECK_RESULT $? 0 0 "Check jgit ls-remote failed"
    jgit ls-tree master | grep "README.md"
    CHECK_RESULT $? 0 0 "Check jgit ls-tree failed"
    jgit branch testdemo
    jgit merge testdemo | grep "Already up-to-date"
    CHECK_RESULT $? 0 0 "Check jgit merge failed"
    expect << EOF > tmp.txt
    spawn jgit push
    expect "Username:"
    send "aaa\n"
    expect "Password:"
    send "aaaa\n"
    expect "Username:"
    send "aaa\n"
    expect "Password:"
    send "aaaa\n"
    expect "Username:"
    send "aaa\n"
    expect "Password:"
    send "aaaa\n"
    expect "Username:"
    send "aaa\n"
    expect "Password:"
    send "aaaa\n"
    expect eof
EOF
    grep "not authorized" tmp.txt
    CHECK_RESULT $? 0 0 "Check jgit push failed"
    jgit reflog | grep "commit: test demo"
    CHECK_RESULT $? 0 0 "Check jgit reflog failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/jgitdemo ${pojpath}/data/ ${pojpath}/lib/
    LOG_INFO "End to restore the test environment."
}

main "$@"
