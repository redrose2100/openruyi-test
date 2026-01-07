#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
#####################################
#@Author    	:   wulei
#@Contact   	:   wulei@uniontech.com
#@Date      	:   2023-05-17
#@License   	:   Mulan PSL v2
#@Desc      	:   Use of Mod-Wsgi
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'mod_wsgi'
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > wsgi.py << EOF
from wsgiref.simple_server import make_server, demo_app
ws = make_server('127.0.0.1', 9999, demo_app)
ws.serve_forever()
EOF
    nohup python3 wsgi.py &
    CHECK_RESULT $? 0 0 'Wsgi.py execution failed'
    sleep 10
    curl 127.0.0.1:9999 | grep 'Hello world!'
    CHECK_RESULT $? 0 0 'Could not match to hello word'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -f wsgi.py
    rm -rf wsgi.py
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
