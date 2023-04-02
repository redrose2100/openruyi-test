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
    commitid=$(git log -n 2 | grep "commit" | sed -n "2p" | awk -F " " '{print $2}')
    jgit reset ${commitid} --soft
    jgit log -n 1 | grep "add README.md"
    CHECK_RESULT $? 0 0 "Check jgit reset failed"
    jgit rm demo.txt
    test -f demo.txt
    CHECK_RESULT $? 1 0 "Check jgit rm failed"
    jgit show | grep "add README.md"
    CHECK_RESULT $? 0 0 "Check jgit show failed"
    touch aaa.txt
    jgit status | grep -e "Untracked files:"
    CHECK_RESULT $? 0 0 "Check jgit status failed" 
    jgit tag testtag -m "test tag"
    jgit tag | grep testtag
    CHECK_RESULT $? 0 0 "Check jgit tag failed"
    jgit version | grep "jgit version"
    CHECK_RESULT $? 0 0 "Check jgit version failed"
    pushd ${pojpath}
    cp ./data/manifest.xml .
    jgit repo manifest.xml
    CHECK_RESULT $? 0 0 "Check jgit repo failed"
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /tmp/jgitdemo ${pojpath}/data/ ${pojpath}/lib/ ${pojpath}/manifest.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
