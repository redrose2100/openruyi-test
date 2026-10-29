#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/04/19
# @License   :   Mulan PSL v2
# @Desc      :   Test SSH link
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

sshcmd() {
    cmd=${1}

    [ -z "${cmd}" ] && {
        echo "[X] CMD is null"
        return 1
    }

    # 登录目标固定为 NODE2：本用例被测的是“从 NODE1 真实登录到远端”的 SSH 链路，
    # 用 127.0.0.1 回环既测不到真实网络通道，也会在 NODE1 自身 sshd 异常时给出误导性结论。
    # expect 结构对齐 libs/locallibs/sshcmd.sh：yes/no 与 password 都用 exp_continue 兜住，
    # 避免第二次登录因没有 yes/no 提示而白等一个 timeout。
    expect <<EOF1
        set timeout 30
        set pw_tries 0
        spawn ssh ${NODE2_USER}@${NODE2_IPV4} "${cmd}"
        expect {
                "*(yes/no*" {
                        send "yes\r"
                        exp_continue
                }
                "*assword:" {
                        incr pw_tries
                        if {\$pw_tries > 2} {
                                send_user "authentication failed for ${NODE2_USER}@${NODE2_IPV4}\n"
                                exit 5
                        }
                        send "${NODE2_PASSWORD}\r"
                        exp_continue
                }
                eof {
                        catch wait result
                        exit [lindex \$result 3]
                }
                timeout {
                        send_user "connection to ${NODE2_IPV4} timed out\n"
                        exit 91
                }
        }
EOF1
    retcode=$?
    echo "retcode of sshcmd is ${retcode}"
    return ${retcode}
}

function run_test() {
    LOG_INFO "Start to run test."
    # sshd 的重启动作必须落在 NODE2：若仍在 NODE1 本地重启 sshd，一旦配置被改坏导致
    # sshd 起不来，NODE1 会直接失联，本用例和后续 suite 全部无法执行。
    rm -f /root/.ssh/known_hosts
    # 部分发行版的 sshd 重启会顺带断掉当前这条 SSH 会话，导致本次 SSH_CMD 返回非 0。
    # 因此这里不直接断言 restart 的返回码，真正的断言由后面的存活检查给出。
    SSH_CMD "systemctl restart sshd" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    if [ $? -ne 0 ]; then
        LOG_WARN "The SSH session used to restart sshd may have been dropped by the restart."
    fi
    SSH_CMD "systemctl status sshd | grep running" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to start sshd service on NODE2"
    sshcmd "uname -a"
    CHECK_RESULT $? 0 0 "uanme -a execution failed"
    sshcmd "ip a"
    CHECK_RESULT $? 0 0 "ip a execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /root/.ssh/known_hosts
    LOG_INFO "End to restore the test environment."
}

main "$@"
