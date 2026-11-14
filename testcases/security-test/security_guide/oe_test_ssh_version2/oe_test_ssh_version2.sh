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
# @Date      :   2020/5/28
# @License   :   Mulan PSL v2
# @Desc      :   Test whether SSH protocol version is 2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    ls testlog && rm -rf testlog
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # OpenSSH 7.6 起已删除 sshd_config 的 "Protocol" 指令（只支持 v2），
    # 配置文件里根本不存在 "Protocol 2" 这一行，原断言必然失败。
    # 改为直接验证协议行为：读服务端 banner，v2 是 SSH-2.0-xxx，
    # v1 是 SSH-1.99/SSH-1.5。
    local banner
    banner=$(timeout 10 bash -c "exec 3<>/dev/tcp/${NODE1_IPV4}/22; head -c 8 <&3" 2>/dev/null)
    printf '%s\n' "${banner}" | grep -q "SSH-2.0"
    CHECK_RESULT $? 0 0 "SSH protocol version is not 2"
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh -2 ${NODE1_USER}@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE1_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    # "System information as of time" 是 Ubuntu 专属 banner，
    # 其他发行版登录后只有 "Last login: ..." 和 shell 提示符。
    grep -E "Last login:|${NODE1_USER}@" testlog
    CHECK_RESULT $? 0 0 "login failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -rf testlog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
