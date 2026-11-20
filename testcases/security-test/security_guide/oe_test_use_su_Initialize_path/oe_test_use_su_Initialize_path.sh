#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/05/29
# @License   :   Mulan PSL v2
# @Desc      :   Initialize path when switching users with Su
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^test:" /etc/passwd && userdel -rf test
    ls testlog && rm -rf testlog
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd test
    passwd test <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    echo "echo \$PATH > /tmp/path_result.txt" >/tmp/path.sh
    chmod 755 /tmp/path.sh
    rm -f /tmp/path_result.txt
    su - test -c "bash /tmp/path.sh"
    local user_path
    user_path=$(cat /tmp/path_result.txt 2>/dev/null)
    LOG_INFO "PATH of test user: ${user_path}"
    test -n "${user_path}"
    CHECK_RESULT $? 0 0 "get PATH of test user failed"
    # 不同发行版的 login.defs 里 ENV_PATH/ENV_SUPATH 取值不同（openEuler 带
    # /usr/local/sbin:/usr/sbin，openRuyi 未定义这两个变量，使用 shadow 内置
    # 默认值 /usr/local/bin:/bin:/usr/bin）。不要写死目录列表，而是从
    # login.defs 读期望值；未定义时只要求 PATH 包含标准可执行目录。
    local env_path
    env_path=$(awk '$1=="ENV_PATH"||$1=="ENV_SUPATH"{print $2; exit}' /etc/login.defs 2>/dev/null)
    local dir miss=0
    if [ -n "${env_path}" ]; then
        for dir in $(echo "${env_path}" | tr ':' ' '); do
            echo ":${user_path}:" | grep -q ":${dir}:" || {
                LOG_ERROR "${dir} is missing from PATH of test user"
                miss=1
            }
        done
    else
        LOG_INFO "login.defs does not define ENV_PATH/ENV_SUPATH, check the standard bin directories instead."
        for dir in /bin /usr/bin; do
            echo ":${user_path}:" | grep -q ":${dir}:" || {
                LOG_ERROR "${dir} is missing from PATH of test user"
                miss=1
            }
        done
    fi
    CHECK_RESULT ${miss} 0 0 "check PATH failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    rm -rf testlog /tmp/path.sh /tmp/path_result.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
