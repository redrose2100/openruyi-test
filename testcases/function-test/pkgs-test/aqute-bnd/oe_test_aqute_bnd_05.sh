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
    bnd view ./data/jar/bnd-libg-3.5.0.jar Manifest
    CHECK_RESULT $? 0 0 "check bnd view failed"
    bnd wrap ./data/jar/org.osgi.core-6.0.0.jar
    test -f org.osgi.core-6.0.0.jar
    CHECK_RESULT $? 0 0 "check bnd wrap failed"
    rm -f org.osgi.core-6.0.0.jar
    bnd xref ./data/osgi-vertx-demo | grep "chat.vertx.bootstrap"
    CHECK_RESULT $? 0 0 "check bnd xref failed"
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd run
    test -d target
    CHECK_RESULT $? 0 0 "check bnd run failed"
    rm -rf target
    popd
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd runtests
    test -d generated
    CHECK_RESULT $? 0 0 "check bnd runtests failed"
    rm -rf generated reports bin
    popd
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd "test" -f
    test -d target
    CHECK_RESULT $? 0 0 "check bnd test failed"
    rm -rf target
    popd
    pushd ./data/osgi-vertx-demo
    bnd  bsn2url -p chat.vertx.mongo
    CHECK_RESULT $? 0 0 "check bnd bsn2url failed"
    popd
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
