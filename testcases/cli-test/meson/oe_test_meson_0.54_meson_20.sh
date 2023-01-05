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
#@Contact       :   1140934993@qq.com
#@Date          :   2022-09-06
#@License       :   Mulan PSL v2
#@Desc          :   Test meson  devenv
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    cd common/0.54/
    tar -xvf test_5.tgz&&cd test_5/
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson wrap list | grep "zlib"
    CHECK_RESULT $? 0 0 " meson wrap list failed"
    meson wrap search jpeg  
    CHECK_RESULT $? 0 0 "meson wrap search failed"
    meson wrap install wren | grep -E "wren|exists"
    CHECK_RESULT $? 0 0 "meson wrap install failed"
    meson wrap info zstd | grep "Available versions of zstd"
    CHECK_RESULT $? 0 0 "meson wrap info failed"
    meson wrap status  | grep "status"
    CHECK_RESULT $? 0 0 "meson wrap status failed"
    meson wrap promote subprojects/s1/subprojects/scommon 
    CHECK_RESULT $? 0 0 "meson wrap promote failed"
    meson wrap update zstd  | grep "zstd"
    CHECK_RESULT $? 0 0 "meson wrap update failed"
    meson wrap --help | grep "wrap"
    CHECK_RESULT $? 0 0 "meson wrap --help failed"
    meson wrap -h | grep "wrap"
    CHECK_RESULT $? 0 0 "meson wrap -h failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd subprojects/
    rm -rf scommon/
    rm -f  wren.wrap
    cd ../..
    rm -rf test_5/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
