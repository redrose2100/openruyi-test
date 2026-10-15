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
# @Date      :   2024/01/15
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-flask function
# #############################################
# shellcheck disable=SC1090

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "python3-flask"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >main.py<<EOF
#main.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'jianhua_helloworld2020'

if __name__ == '__main__':
    app.run(port=2021,host='0.0.0.0')
EOF
    test -f main.py
    CHECK_RESULT $? 0 0 "Create main.py file fail"
    python3 main.py &
    CHECK_RESULT $? 0 0 "Execution fail"
    sleep 20
    CHECK_RESULT $? 0 0 "Execution fail"
    curl http://"${NODE1_IPV4}":2021 | grep "jianhua_helloworld2020"
    CHECK_RESULT $? 0 0 "Execution fail"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    kill -9 "$(pgrep -f 'python3 main.py')"
    rm -rf main.py
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
