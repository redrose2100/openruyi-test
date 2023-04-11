#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/03/18
# @License   :   Mulan PSL v2
# @Desc      :   Test aqute-bnd
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "aqute-bnd tar"
    extract_data
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    pushd data/com.acme.prime/cnf
    bnd action | grep "Rebuild Resource Index"
    CHECK_RESULT $? 0 0 "check bnd action failed"
    popd
    bnd add workspace tmp
    test -d tmp
    CHECK_RESULT $? 0 0 "check bnd add failed"
    rm -rf tmp
    pushd data/jar
    bnd baseline --diff bnd-libg-3.5.0.jar org.osgi.core-6.0.0.jar  | grep "org.osgi.framework.wiring"
    CHECK_RESULT $? 0 0 "check bnd baseline failed"
    popd
    bnd bash | grep "_bnd_completion_"
    CHECK_RESULT $? 0 0 "check bnd bash failed"
    bnd bnd
    CHECK_RESULT $? 0 0 "check bnd bnd failed"
    pushd data/com.acme.prime
    bnd plugins | grep "Workspace"
    CHECK_RESULT $? 0 0 "check bnd plugin failed"
    popd
    pushd data/com.acme.prime
    bnd build
    CHECK_RESULT $? 0 0 "check bnd build failed"
    popd
    pushd data/com.acme.prime
    bnd buildx
    CHECK_RESULT $? 0 0 "check bnd buildx failed"
    popd
    pushd data/osgi-vertx-demo
    bnd bump -p chat.vertx.bootstrap major
    CHECK_RESULT $? 0 0 "check bnd bump failed"
    rm -f tmp.txt
    popd
    bnd changes | grep "Release"
    CHECK_RESULT $? 0 0 "check bnd changes failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
