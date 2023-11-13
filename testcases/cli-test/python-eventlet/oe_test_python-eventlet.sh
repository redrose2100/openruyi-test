#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.11.10
# @License   :   Mulan PSL v2
# @Desc      :   python-eventlet formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /home/test.py << EOF
import eventlet
from urllib.request import urlopen

# 定义协程函数
def coroutine_func(url):
    with eventlet.Timeout(5, False):
        # 发送网络请求
        resp = urlopen(url)
        # 输出响应内容
        print(resp.read().decode('utf-8'))

# 创建协程池
pool = eventlet.GreenPool()

# 遍历URL列表，启动协程
for url in ['http://www.baidu.com']:
    pool.spawn(coroutine_func, url)

# 等待所有协程执行完成
pool.waitall()

EOF

    DNF_INSTALL "python-eventlet-help python3-eventlet"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep python3-eventlet
    CHECK_RESULT $? 0 0 "Return value error"
    cd /home && python3 test.py > /home/eventlet.txt
    test -f /home/eventlet.txt
    CHECK_RESULT $? 0 0 "compile test.py fail"
    grep "meta http-equiv" /home/eventlet.txt
    CHECK_RESULT $? 0 0 "execute eventlet.txt fail"    
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /home/test.py  /home/eventlet.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
