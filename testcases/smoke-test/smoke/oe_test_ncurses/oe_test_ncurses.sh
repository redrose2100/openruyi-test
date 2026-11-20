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
# @Date      :   2022/06/14
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of infocmp
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL openssh-clients
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    # 本用例原本 spawn "ssh 127.0.0.1" 用 root 密码登录后再验证 TERM。openRuyi
    # 的 sshd 不开放 root 密码登录（日志里是连续三次 "Permission denied, please
    # try again." + "Permission denied (publickey,password)."），导致 expect
    # 拿不到登录后的 shell。用例真正要验的是 ncurses 提供的 terminfo 在
    # 交互式终端下能正确生效，不依赖具体登录方式，所以改为直接 spawn 一个
    # 交互式 bash（同样有 pty，同样能看到 $TERM）。
    cat >run-term <<'EXPECT_EOF'
#!/usr/bin/expect
log_file -a testlog
spawn bash --noprofile --norc
expect "#"
send "export TERM=vt100\r"
expect "export TERM"
send "echo \$TERM\r"
expect "echo \$TERM"
send "exit\r"
expect eof
EXPECT_EOF
    chmod 777 run-term
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    export TERM=vt100
    [ "$TERM" ]
    CHECK_RESULT $? 0 0 "Failed to execute xterm"
    infocmp | grep terminfo
    CHECK_RESULT $? 0 0 "Failed to execute infocmp"
    infocmp > testlog2
    infotocap testlog2 | grep Reconstructed
    CHECK_RESULT $? 0 0 "Failed to execute infotocap"
    ./run-term
    CHECK_RESULT $? 0 0 "Failed to execute run-term"
    grep "\$TERM" testlog
    CHECK_RESULT $? 0 0 "Failed to display term"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf testlog* run-term
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
