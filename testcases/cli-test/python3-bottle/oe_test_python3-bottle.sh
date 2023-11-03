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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/05.23
# @License   :   Mulan PSL v2
# @Desc      :   Python3 bottle functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-bottle"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > bottle_test.py << EOF
from bottle import template,Bottle
root = Bottle()
@root.route('/hello')
def index():
    return "Hello World"
    #return template('<b>Hello {{ name }}</b>!',name="user")
root.run(host='localhost',port=8081)
EOF
    CHECK_RESULT $? 0 0 "Bottle test file creation failed"
    nohup python3 bottle_test.py &
    sleep 2
    curl http://localhost:8081/hello | grep 'Hello World'
    CHECK_RESULT $? 0 0 "Bottle test failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -f bottle_test.py
    rm -rf bottle_test.py
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


