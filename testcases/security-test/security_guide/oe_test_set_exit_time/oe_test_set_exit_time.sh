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
# @Modify    :   yang_lijin@qq.com
# @Date      :   2020/05/27
# @License   :   Mulan PSL v2
# @Desc      :   The terminal stops running for 30 seconds and exits automatically
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "openssh-clients"
    cp /etc/profile /etc/profile.bak
    # 原来直接 `echo \\'TMOUT=30\\' >/etc/profile`：既覆盖了整个 /etc/profile
    # （丢掉系统默认 PATH 等），又留下了字面反斜杠，导出只能得到
    # "-bash: TMOUT=30\\: command not found"。这里只在末尾追加并 export。
    if ! grep -qE '^[[:space:]]*(export[[:space:]]+)?TMOUT=' /etc/profile; then
        printf '\nTMOUT=30\nexport TMOUT\n' >>/etc/profile
        grep -qE '^[[:space:]]*(export[[:space:]]+)?TMOUT=' /etc/profile
        CHECK_RESULT $? 0 0 "failed to append TMOUT to /etc/profile"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    echo "expect<<EOF1
        set timeout 15
        spawn ssh ${NODE1_USER}@${NODE1_IPV4} 
        expect {
            \"*yes/no*\" {
                send \"yes\\r\"
            }
        }
        expect {
            \"assword:\" {
                send \"${NODE1_PASSWORD}\\r\"
            }
        }
        expect eof
EOF1" >/tmp/ssh_remote.sh
    rm -rf /root/.ssh/known_hosts
    bash -x /tmp/ssh_remote.sh >/tmp/ssh_remote.log 2>&1 &
    # openRuyi 镜像不带 procps，ps/pgrep 都不存在（procps-ng 与 coreutils 的
    # /usr/bin/uptime 硬冲突无法安装）。改用框架提供的 /proc 查询函数，
    # 语义与原 ps | grep 一致，且不依赖任何软件包。
    local i pid count
    count=0
    for i in $(seq 1 20); do
        pid=$(proc_pids_by_name ssh | head -n 1)
        [ -n "${pid}" ] && { count=1; break; }
        SLEEP_WAIT 1
    done
    test "${count}" -eq 1
    CHECK_RESULT $? 0 0 "terminal not running"
    SLEEP_WAIT 35
    pid=$(proc_pids_by_name ssh | head -n 1)
    test -z "${pid}"
    CHECK_RESULT $? 0 0 "terminal running"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    proc_kill_pids $(proc_pids_by_cmdline ssh_remote.sh)
    mv /etc/profile.bak /etc/profile -f
    source /etc/profile
    rm -rf /tmp/ssh_remote.sh /tmp/ssh_remote.log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
