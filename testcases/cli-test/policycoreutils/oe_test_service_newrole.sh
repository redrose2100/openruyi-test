#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test newrole
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cat>1.sh<<-END
    #!/usr/bin/expect
    spawn newrole -r unconfined_r
    set timeout 30
    expect "Password:"
    send "${NODE1_PASSWORD}\r"
END
    cat>2.sh<<-END
    #!/usr/bin/expect
    spawn newrole -r system_r -t unconfined_t
    set timeout 30
    expect "Password:"
    send "${NODE1_PASSWORD}\r"
END
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    # 切换用户 
    expect 1.sh
    CHECK_RESULT $? 0 0 "failed to change role"
    exit
    expect 2
    CHECK_RESULT $? 0 0 "failed to change to system_r "
    exit
    #检查newrole版本
    newrole -V 
    CHECK_RESULT $?
    newrole -l Secret
    CHECK_RESULT $? 0 0 "Error: you are not allowed to change levels on a non secure terminal"
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Nothing to do."
    LOG_INFO "End to restore the test environment."
}

main "$@"
