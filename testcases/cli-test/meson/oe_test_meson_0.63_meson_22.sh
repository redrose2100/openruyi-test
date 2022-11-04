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
    cd ./common/0.63/
    tar -xvf '12 promote.tgz' 
    cd ./../../
    cp -rf ./common/0.63/'12 promote.tgz'    ./   
    cd ./'12 promote' 
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson wrap list
    CHECK_RESULT $? 0 0 " meson wrap list failed"
    meson wrap search jpeg
    CHECK_RESULT $? 0 0 "meson wrap search failed"
    meson wrap install zlib 2>&1 | grep "exists"
    CHECK_RESULT $? 0 0 "meson wrap install failed"
    meson wrap info zlib
    CHECK_RESULT $? 0 0 "meson wrap info failed"
    meson wrap status
    CHECK_RESULT $? 0 0 "meson wrap status failed"
    meson wrap promote subprojects/s1/subprojects/scommon 2>&1 | grep "Output"
    CHECK_RESULT $? 0 0 "meson wrap promote failed"
    meson wrap update zlib
    CHECK_RESULT $? 0 0 "meson wrap update failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd ..
    rm -rf ./'12 promote'
    rm -rf ./common/0.63/'12 promote'
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
