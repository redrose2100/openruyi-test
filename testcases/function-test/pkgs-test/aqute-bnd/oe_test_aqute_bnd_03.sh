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
    bnd enroute workspace tmp
    test -d tmp
    CHECK_RESULT $? 0 0 "check bnd enroute failed"
    rm -rf tmp
    pushd ./data/osgi-vertx-demo
    bnd "export" -p chat.vertx.mongo
    CHECK_RESULT $? 0 0 "check bnd export failed"
    popd
    pushd ./data/jar
    bnd extract -f org.osgi.core-6.0.0.jar
    test -d org
    CHECK_RESULT $? 0 0 "check bnd extract failed"
    rm -rf META-INF org
    popd
    pushd data/jar
    bnd flatten bnd-libg-3.5.0.jar tmp
    CHECK_RESULT $? 0 0 "check bnd flatten failed"
    popd
    bnd "grep" -h "*" "settings" ./data/jar/bnd-libg-3.5.0.jar  | grep "ute.lib.\[settings]"
    CHECK_RESULT $? 0 0 "check bnd grep failed"
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd info -b | grep "Run path"
    CHECK_RESULT $? 0 0 "check bnd info failed"
    popd
    pushd data/junittest
    bnd junit .
    CHECK_RESULT $? 0 0 "check bnd junit failed"
    popd
    pushd data/com.acme.prime/com.acme.prime.hello
    bnd macro p  > tmp.txt 2>&1
    grep "com.acme.prime.hello" tmp.txt
    CHECK_RESULT $? 0 0 "check bnd macro failed"
    rm -f tmp.txt
    popd
    if [[ ! -d ~/.m2/ ]]; then
        mkdir -p ~/.m2/
    fi
    cp data/settings.xml ~/.m2/
    bnd maven settings > tmp.txt 2>&1
    grep "URL wird nicht verwendet" tmp.txt
    CHECK_RESULT $? 0 0 "check bnd maven failed"
    rm -f tmp.txt
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    rm -rf maven-bundle
    LOG_INFO "End to restore the test environment."
}
main "$@"
