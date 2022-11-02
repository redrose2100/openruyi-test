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
#@Desc          :   Test meson  devenv
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson"
    cd ./common/0.54/
    tar -xvf test_5.tgz
    cd ./../../    
    cp -rf ./common/0.54/test_5/test_1/ ./
    cd ./'test_1'OG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    cd ./builddir
    meson devenv --help 2>&1 | grep "usage: meson" 
    CHECK_RESULT $? 0 0 "meson devenv --help failed"
    meson devenv -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson devenv -h failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd ../../
    rm -rf ./'test_1'
    rm -rf ./commom/0.54/test_5
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
