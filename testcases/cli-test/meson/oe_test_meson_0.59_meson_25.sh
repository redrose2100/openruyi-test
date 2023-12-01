#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   yuyi
#@Contact       :   1140934993@@qq.com
#@Date          :   2022-09-06
#@License       :   Mulan PSL v2
#@Desc          :   Test meson test
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar"
    tar -xvf common/0.59/test_3.tgz&&cd test_3
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson rewrite target --help | grep "rewrite target"
    CHECK_RESULT $? 0 0 "meson-rewrite target --help failed"
    meson rewrite target -h | grep "rewrite target"
    CHECK_RESULT $? 0 0 "meson-rewrite target -h failed"
    meson rewrite target testExe add fileB.cpp&&cat meson.build | grep "fileA.cpp"
    CHECK_RESULT $? 0 0 "meson rewrite target add failed"
    meson rewrite target testExe1 add_target fileB.cpp&&cat meson.build | grep "fileB.cpp"
    CHECK_RESULT $? 0 0 "meson rewrite target  add_target failed"
    meson rewrite target testExe1 rm fileB.cpp&&cat meson.build | grep "fileA.cpp"
    CHECK_RESULT $? 0 0 "meson rewrite target  rm failed"
    meson rewrite target testExe rm_target fileB.cpp&&cat meson.build | grep "exe8"
    CHECK_RESULT $? 0 0 "meson rewrite target  rm_target failed"
    meson rewrite target testExe1 info fileB.cpp &&cat meson.build | grep "fileB.cpp"
    CHECK_RESULT $? 0 0 "meson rewrite target  info failed"
    meson rewrite target testExe add_target fileB.cpp -s 2
    CHECK_RESULT $? 0 0 "meson rewrite target  -s failed"
    meson rewrite target testExe3 add_target fileB.cpp --subdir 2
    CHECK_RESULT $? 0 0 "meson rewrite target  --subdir failed"
    meson rewrite target testExe add_target fileB.cpp --type jar
    CHECK_RESULT $? 0 0 "meson rewrite target  --type failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../test_3
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
