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
    DNF_INSTALL "meson tar gcc g++"
    cd common/0.63/ && tar -xf forcefallback.tgz && tar -xf kwargs.tgz && cd kwargs/
    meson rewrite default-options set cpp_std c++14 buildtype release debug true
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson rewrite kwargs remove_regex project // default_options buildtype=.* && cat meson.build | grep "'buildtype=release'"
    CHECK_RESULT $? 1 0 "meson rewrite kwargs remove_regex failed"
    meson rewrite default-options delete debug null && cat meson.build | grep "'debug=True'"
    CHECK_RESULT $? 1 0 "meson rewrite default-option delete failed"
    meson rewrite default-options set cpp_std c++11 && cat meson.build | grep "'cpp_std=c++11'"
    CHECK_RESULT $? 0 0 "meson rewrite default-options set failed"
    meson rewrite command set.json && cat meson.build | grep "method : 'cmake'"
    CHECK_RESULT $? 0 0 "meson rewrite command failed"
    cd ../forcefallback
    meson setup --force-fallback-for=zlib,foo subprojects/ | grep "Looking for a fallback subproject for the dependency zlib"
    CHECK_RESULT $? 0 0 "meson setup --force-fallback-for failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd ../ && rm -rf kwargs forcefallback
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
