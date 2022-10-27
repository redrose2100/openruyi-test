#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST csslint
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    mkdir -p ./tmp
    echo "body > div p.process { color: aqua; }" > ./tmp/test.css
    echo "<test>
 <body>
  <div>
   <div>
    <p class=\"process\">This should be aqua</p>
   </div>
  </div>
 </body>
</test>
" > ./tmp/test.xml
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libcroco"
    VERSION="$(rpm -qa libcroco | grep "[0-9]+.[0-9]+.[0-9]+")"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    csslint-0.6 | grep "Usage: csslint <path to a css file>"
    CHECK_RESULT $? 0 0 "option: help error"
    csslint-0.6 -v | grep "${VERSION}"
    CHECK_RESULT $? 0 0 "option: -v error"
    csslint-0.6 -version | grep "${VERSION}"
    CHECK_RESULT $? 0 0 "option: -version error"
    csslint-0.6 ./tmp/test.css | grep "color : aqua"
    CHECK_RESULT $? 0 0 "csslint-0.6 output error"
    csslint-0.6 --dump-location ./tmp/test.css | grep "Parsing location information"
    CHECK_RESULT $? 0 0 "option: --dump-location error"
    csslint-0.6 --evaluate --author-sheet ./tmp/test.css --xml ./tmp/test.xml --xpath //p | grep "Properties of xml element"
    CHECK_RESULT $? 0 0 "option: --evaluate --author-sheet --xml --xpath error"
    csslint-0.6 -e --author-sheet ./tmp/test.css --xml ./tmp/test.xml --xpath //p | grep "Properties of xml element"
    CHECK_RESULT $? 0 0 "option: -e --author-sheet --xml --xpath error"
    csslint-0.6 -e --user-sheet ./tmp/test.css --xml ./tmp/test.xml --xpath //p | grep "Properties of xml element"
    CHECK_RESULT $? 0 0 "option: -e --user-sheet --xml --xpath error"
    csslint-0.6 -e --ua-sheet ./tmp/test.css --xml ./tmp/test.xml --xpath //p | grep "Properties of xml element"
    CHECK_RESULT $? 0 0 "option: -e --ua-sheet --xml --xpath error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"