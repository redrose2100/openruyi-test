#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2024/01/16
# @License   :   Mulan PSL v2
# @Desc      :   Test rubygem-puma function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "rubygem-puma rubygem-puma-doc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >config.ru<<EOF
run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['Hello, Puma!']] }
EOF
    test -f config.ru
    CHECK_RESULT $? 0 0 "Create config.ru file fail"
    puma -b tcp://0.0.0.0:3000 &
    CHECK_RESULT $? 0 0 "Execution fail"
    sleep 10
    CHECK_RESULT $? 0 0 "Execution fail"
    curl http://127.0.0.1:3000 | grep "Hello, Puma!"                        
    CHECK_RESULT $? 0 0 "Execution fail"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    pgrep -n puma | xargs kill -9
    rm -rf config.ru
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

