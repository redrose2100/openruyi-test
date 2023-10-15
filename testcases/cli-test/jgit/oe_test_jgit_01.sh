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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pojpath=$(
    cd "$(dirname "$0")" || exit 1
        pwd
    )   
    jgit -h 2>&1 | grep "jgit --git-dir GIT_DIR"
    CHECK_RESULT $? 0 0 "Check jgit -h failed"
    jgit --help 2>&1 | grep "jgit --git-dir GIT_DIR"
    CHECK_RESULT $? 0 0 "Check jgit --help failed"
    jgit --version | grep "jgit version "
    CHECK_RESULT $? 0 0 "Check jgit --version failed"
    mkdir /tmp/jgitdemo
    pushd /tmp/jgitdemo
    jgit clone https://gitee.com/gittyee/demo.git
    test -d ./demo/.git
    CHECK_RESULT $? 0 0 "Check jgit clone failed"
    pushd /tmp/jgitdemo/demo
    touch demo.txt    
    jgit add demo.txt
    jgit status | grep "new file:   demo.txt"
    CHECK_RESULT $? 0 0 "Check jgit add failed"
    jgit archive -o ../latest.zip HEAD
    test -f ../latest.zip
    CHECK_RESULT $? 0 0 "Check jgit archive failed"
    jgit branch -v | grep master
    CHECK_RESULT $? 0 0 "Check jgit branch failed"
    jgit checkout origin/dev
    jgit branch -v | grep "no branch"
    CHECK_RESULT $? 0 0 "Check jgit checkout failed"
    jgit checkout master
    touch unuse.txt
    jgit clean -f
    test -f unuse.txt
    CHECK_RESULT $? 1 0 "Check jgit clean failed"
    java -verbose > tmp.txt
    jrepath=$(cat tmp.txt | sed -n '1p' | awk -F " " '{print $2}' | awk -F "jre" '{print $1}')
    jrelib=${jrepath}jre/lib/ext
    cp ${pojpath}/lib/* ${jrelib}
    rm -f tmp.txt
    jgit commit -m "test demo"
    jgit log -n 1 | grep "test demo"
    CHECK_RESULT $? 0 0 "Check jgit commit failed"
    jgit config --list | grep "remote.origin.url=https://gitee.com/gittyee/demo.git"
    CHECK_RESULT $? 0 0 "Check jgit config failed"
    jgit daemon . &
    SLEEP_WAIT 5
    pgrep -f "java org.eclipse.jgit.pgm.Main daemon"
    CHECK_RESULT $? 0 0 "Check jgit daemon failed"
    kill -9 $(pgrep -f "java org.eclipse.jgit.pgm.Main daemon")
    jgit describe --always
    CHECK_RESULT $? 0 0 "Check jgit describe failed"
    jgit diff origin/master HEAD | grep "+++ b/demo.txt"
    CHECK_RESULT $? 0 0 "Check jgit diff failed"
    jgit fetch https://gitee.com/gittyee/demo.git HEAD
    CHECK_RESULT $? 0 0 "Check jgit fetch failed"
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
