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
    cp -r ./data/task-files .
    pushd task-files
        npm install > /dev/null 2>&1
    popd
    cp -r ./data/task-npm task-npm
    pushd task-npm
        npm install  > /dev/null 2>&1
    popd
    cp -r ./data/task-waring task-waring
    pushd task-waring
        npm install  > /dev/null 2>&1
    popd
    cp -r ./data/grunt-complete grunt-complete
    pushd grunt-complete
        npm install  > /dev/null 2>&1
    popd
    cp -r ./data/grunt-no-write grunt-no-write
    pushd grunt-no-write
        npm install  > /dev/null 2>&1
    popd
    unalias cp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pushd task-files
        grunt --tasks ./tasks/ | grep 'Running "showTargetFiles:target1"'
        CHECK_RESULT $? 0 0 "Check grunt --tasks failed"        
    popd
    pushd task-npm
        grunt --npm grunt-contrib-stylus | grep 'Running "stylus:target1" (stylus) task'
        CHECK_RESULT $? 0 0 "Check grunt --npm failed"        
    popd
    pushd task-files
        grunt -v | grep "Verifying property"
        CHECK_RESULT $? 0 0 "Check grunt -v failed"        
    popd
    pushd task-files
        grunt --verbose | grep "Verifying property"
        CHECK_RESULT $? 0 0 "Check grunt --verbose failed"        
    popd
    pushd task-waring
        grunt -f | grep "Done, but with warnings."
        CHECK_RESULT $? 0 0 "Check grunt -f failed"        
    popd
    pushd task-waring
        grunt --force | grep "Done, but with warnings."
        CHECK_RESULT $? 0 0 "Check grunt --force failed"        
    popd
    node_modules=$(find / -name "grunt-cli" | grep "grunt-cli$")
    for node_module in ${node_modules[@]}; do
        if [[ ! -d ${node_module}/completion ]]; then
            cp -r ./data/completion ${node_module}
        fi
    done
    pushd grunt-complete
        grunt --completion bash | grep "complete -o default -F _grunt_completions grunt"
        CHECK_RESULT $? 0 0 "Check grunt --completion failed"
    popd
    pushd grunt-no-write
        grunt webget --no-write  | grep "Done, without errors"
        CHECK_RESULT $? 0 0 "Check grunt --no-write failed"
    popd
    grunt -V | grep "grunt-cli v$(rpm -q nodejs-grunt-cli | awk -F '-' '{print $4}')"
    CHECK_RESULT $? 0 0 "Check grunt -V failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf task-npm data grunt-complete task-waring task-files grunt-no-write
    LOG_INFO "End to restore the test environment."
}

main "$@"
