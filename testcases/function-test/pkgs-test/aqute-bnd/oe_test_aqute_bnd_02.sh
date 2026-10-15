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
    pushd data/jar
    bnd convert -m mainfest.xml tmp.txt
    test -f tmp.txt
    CHECK_RESULT $? 0 0 "check bnd convert failed"
    rm -f tmp.txt
    popd
    bnd copy --strip https://repo.maven.apache.org/maven2/com/sun/mail/javax.mail/1.5.2/javax.mail-1.5.2.jar > javax.mail-1.5.2.jar
    test -f javax.mail-1.5.2.jar
    CHECK_RESULT $? 0 0 "check bnd copy failed"
    rm -f javax.mail-1.5.2.jar
    pushd data/creatCommand
    bnd create -f tmp.jar -m MANIFEST.MF
    test -f tmp.jar
    CHECK_RESULT $? 0 0 "check bnd create failed"
    rm -f tmp.jar
    popd
    pushd data/com.acme.prime
    bnd debug -p com.acme.prime.hello | grep "Sub-Builder com.acme.prime.hello"
    CHECK_RESULT $? 0 0 "check bnd debug failed"
    popd
    bnd defaults | grep "javac=javac"
    CHECK_RESULT $? 0 0 "check bnd defaults failed"
    pushd data/com.acme.prime
    bnd deliverables -p com.acme.prime.hello > tmp.txt 2>&1
    grep "com.acme.prime.hello" tmp.txt
    CHECK_RESULT $? 0 0 "check bnd deliverables failed"
    rm -f tmp.txt
    popd
    pushd data/jar
    bnd diff bnd-libg-3.5.0.jar org.osgi.core-6.0.0.jar | grep "org/osgi/util/tracker/BundleTracker.class"
    CHECK_RESULT $? 0 0 "check bnd diff failed"
    popd
    pushd data/jar
    bnd digest bnd-libg-3.5.0.jar
    CHECK_RESULT $? 0 0 "check bnd digest failed"
    popd
    pushd data/jar
    bnd "do" bnd-libg-3.5.0.jar  | grep "A library to be statically linked"
    CHECK_RESULT $? 0 0 "check bnd do failed"
    popd
    pushd data/osgi-vertx-demo/chat.vertx.mongo
    bnd eclipse > tmp.txt 2>&1
    grep "Sourcepath" tmp.txt
    CHECK_RESULT $? 0 0 "check bnd eclipse failed"
    rm -f tmp.txt
    popd
    pushd data/jar
    bnd ees bnd-libg-3.5.0.jar  | grep "OpenJDK8"
    CHECK_RESULT $? 0 0 "check bnd ees failed"
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
