#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test grunt
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nodejs-grunt-cli tar"
    tar -xvf common/data.tar.gz > /dev/null
    mkdir workspace
    cp ./data/Gruntfile.js workspace 
    cp ./data/package.json workspace
    pushd workspace
        npm install  > /dev/null 2>&1
    popd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grunt --version | grep "grunt-cli v$(rpm -q nodejs-grunt-cli | awk -F '-' '{print $4}')"
    CHECK_RESULT $? 0 0 "Check grunt --version failed"
    grunt -h | grep "grunt-cli: The grunt command line interface"
    CHECK_RESULT $? 0 0 "Check grunt -h failed"
    grunt --help | grep "grunt-cli: The grunt command line interface"
    CHECK_RESULT $? 0 0 "Check grunt --help failed"
    grunt -b ./workspace/ --gruntfile ./workspace/Gruntfile.js | grep "Done, without errors."
    CHECK_RESULT $? 0 0 "Check grunt -b failed"
    grunt --base ./workspace/ --gruntfile ./workspace/Gruntfile.js | grep "Done, without errors."
    CHECK_RESULT $? 0 0 "Check grunt --base failed"
    grunt --no-color --gruntfile ./workspace/Gruntfile.js | grep 'Running "uglify:build" (uglify) task'
    CHECK_RESULT $? 0 0 "Check grunt --no-color failed"
    grunt --gruntfile ./workspace/Gruntfile.js | grep "Done, without errors."
    CHECK_RESULT $? 0 0 "Check grunt --gruntfile failed"
    pushd workspace
        grunt -d | grep "Task source: "
        CHECK_RESULT $? 0 0 "Check grunt -d failed"
    popd
    pushd workspace
        grunt --debug | grep "Task source: "
        CHECK_RESULT $? 0 0 "Check grunt --debug failed"
    popd
    cp -r workspace workspaceErr
    cp ./data/packageErr.json workspaceErr/package.json
    pushd workspaceErr
        grunt --stack | grep 'Error: Task "default" not found.'
        CHECK_RESULT $? 0 0 "Check grunt --stack failed"    
    popd
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf workspace workspaceErr task-npm data
    LOG_INFO "End to restore the test environment."
}

main "$@"
