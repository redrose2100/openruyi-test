#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2022-04-22
# @License   :   Mulan PSL v2
# @Desc      :   package rocksdb test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir -p "/tmp/test_rocksdb_java" && cd "/tmp/test_rocksdb_java" || exit
    DNF_INSTALL "rocksdb rocksdbjni java-1.8.0-openjdk-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cp "$OET_PATH"/testcases/function-test/pkgs-test/rocksdb/RocksJavaTest.java /tmp/test_rocksdb_java/
    javac -cp .:/usr/share/java/rocksdbjni/rocksdbjni.jar -Xlint:deprecation RocksJavaTest.java
    CHECK_RESULT $? 0 0 "Compilation failed" 
    java -cp .:/usr/share/java/rocksdbjni/rocksdbjni.jar RocksJavaTest
    CHECK_RESULT $? 0 0 "Test failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_rocksdb_java
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
