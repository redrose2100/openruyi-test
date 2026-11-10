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
    # Do not depend on one exact ordering; require every standard directory.
    local dir miss=0
    for dir in /usr/local/bin /usr/bin /usr/local/sbin /usr/sbin; do
        echo ":${user_path}:" | grep -q ":${dir}:"
        if [ $? -ne 0 ]; then
            LOG_ERROR "${dir} is missing from PATH of test user"
            miss=1
        fi
    done
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
