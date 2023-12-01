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
    bnd plugins | grep "aQute.bnd.osgi.Processor"
    CHECK_RESULT $? 0 0 "check bnd plugins failed"
    bnd print ./data/jar/org.osgi.core-6.0.0.jar  | grep "Oracle Corporation"
    CHECK_RESULT $? 0 0 "check bnd print failed"
    bnd profile create
    test -f Untitled
    CHECK_RESULT $? 0 0 "check bnd profile failed"
    rm -f Untitled
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd project > tmp.txt 2>&1
    grep "com.acme.prime.hello" tmp.txt
    CHECK_RESULT $? 0 0 "check bnd project failed"
    rm -f tmp.txt
    popd
    pushd data/com.acme.prime
    bnd remove com.acme.prime.test
    CHECK_RESULT $? 0 0 "check bnd remove failed"
    popd
    bnd repo list
    CHECK_RESULT $? 0 0 "check bnd repo failed"
    bnd schema
    test -f schema.xml
    CHECK_RESULT $? 0 0 "check bnd schema failed"
    rm -f schema.xml
    bnd "select" ./data/jar/bnd-libg-3.5.0.jar  | grep "3.5.0.201812200511"
    CHECK_RESULT $? 0 0 "check bnd select failed"
    bnd settings | grep "= root"
    CHECK_RESULT $? 0 0 "check bnd settings failed"
    bnd source ./data/jar/bnd-libg-3.5.0.jar ./data/jar/bnd-libg-3.5.0.jar
    CHECK_RESULT $? 0 0 "check bnd source failed"
    bnd syntax header
    CHECK_RESULT $? 0 0 "check bnd syntax failed"
    bnd type -f ./data/jar/bnd-libg-3.5.0.jar
    CHECK_RESULT $? 0 0 "check bnd type failed"
    rm -f tmp.txt
    bnd verify ./data/jar/bnd-libg-3.5.0.jar 2>&1 | grep "OSGI-OPT/src/aQute/lib"
    CHECK_RESULT $? 0 0 "check bnd verify failed"
    bnd version
    CHECK_RESULT $? 0 0 "check bnd version failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
