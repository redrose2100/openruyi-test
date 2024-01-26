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
# @Desc      :   Test python3-werkzeug function
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "python3-werkzeug"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat >test.py<<EOF
#!/usr/bin/python
from werkzeug.wrappers import Request, Response

@Request.application
def application(request):
    return Response('Hello, World!')

if __name__ == '__main__':
    from werkzeug.serving import run_simple
    run_simple('localhost', 5000, application)
EOF
    test -f test.py
    CHECK_RESULT $? 0 0 "Create test.py file fail"
    python3 test.py &
    CHECK_RESULT $? 0 0 "Execution fail"
    sleep 5
    CHECK_RESULT $? 0 0 "Execution fail"
    curl http://localhost:5000 | grep "Hello, World!"                        
    CHECK_RESULT $? 0 0 "Execution fail"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    pgrep -n python3 | xargs kill -9
    rm -rf test.py
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

