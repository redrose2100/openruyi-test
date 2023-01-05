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
    cd common/0.63/ && tar -xf kwargs.tgz && cd kwargs/
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson rewrite kwargs --help | grep "usage: meson rewrite kwargs"
    CHECK_RESULT $? 0 0 "meson rewrite kwargs --help failed"
    meson rewrite kwargs -h | grep "usage: meson rewrite kwargs"
    CHECK_RESULT $? 0 0 "meson rewrite kwargs -h failed"
    meson rewrite kwargs info project / 2>&1 | grep '"version": "0.0.1"'
    CHECK_RESULT $? 0 0 "meson rewrite kwargs info project failed"
    meson rewrite kwargs info target tgt1 2>&1 | grep '"build_by_default": true'
    CHECK_RESULT $? 0 0 "meson rewrite kwargs info target failed"
    meson rewrite kwargs info dependency dep1 2>&1 | grep '"required": false'
    CHECK_RESULT $? 0 0 "meson rewrite kwargs info dependency failed"
    meson rewrite kwargs set project / "license" "GPL" && cat meson.build | grep "license : 'GPL'"
    CHECK_RESULT $? 0 0 "meson rewrite kwargs set project failed"
    meson rewrite kwargs add project / "license" "MIT" && cat meson.build | grep "license : \['GPL', 'MIT']"
    CHECK_RESULT $? 0 0 "meson rewrite kwargs add project failed"
    meson rewrite kwargs remove project / "license" "MIT" && cat meson.build | grep "license : 'GPL')"
    CHECK_RESULT $? 0 0 "meson rewrite kwargs remove project failed"
    meson rewrite kwargs delete project / "version" null && cat meson.build | grep "version : '0.0.1'"
    CHECK_RESULT $? 1 0 "meson rewrite kwargs delete project failed"
    meson rewrite default-options set cpp_std c++14 buildtype release debug true && cat meson.build | grep "'debug=True'"
    CHECK_RESULT $? 0 0 "meson rewrite default-options set failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd ../ && rm -rf kwargs
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
