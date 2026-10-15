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
    local start_port=5000  
    local free_port=""  
  
    # 循环检查端口，直到找到空闲端口  
    while [ -z "$free_port" ]; do  
        # 检查端口是否被占用  
        if ! ss -tuln | grep -q ":$start_port "; then  
            free_port=$start_port  
        else  
            ((start_port++))  
        fi  
  
        # 可选：添加超时或限制最大端口号以防止无限循环  
         if [ "$start_port" -gt 65535 ]; then  
             echo "Error: No free port found within the range."  
             exit 1  
         fi  
  
        # 为了避免过于频繁的端口检查（尤其是在端口密集占用的情况下），可以添加一个小的休眠时间  
        # sleep 0.1  
    done 

    cat >test.py<<EOF
#!/usr/bin/python
from werkzeug.wrappers import Request, Response

@Request.application
def application(request):
    return Response('Hello, World!')

if __name__ == '__main__':
    from werkzeug.serving import run_simple
    run_simple('localhost', $free_port, application)
EOF
    test -f test.py
    CHECK_RESULT $? 0 0 "Create test.py file fail"
    python3 test.py &
    CHECK_RESULT $? 0 0 "Execution fail"
    sleep 5
    CHECK_RESULT $? 0 0 "Execution fail"
    curl http://localhost:"$free_port"       
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


