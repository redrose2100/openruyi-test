#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   shang jiwei
# @Contact   :   1065099936@qq.com
# @Date      :   2023/08/27
# @License   :   Mulan PSL v2
# @Desc      :   Test "dscreate" command
# ##################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "389-ds-base"
    DNF_INSTALL "expect"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    cat <<EOF > dscreate_interactive_shell.sh
interactive_command="dscreate interactive"

expect <<EOD
spawn \$interactive_command
expect "SELinux labels will not be applied, continue?"
send "yes\n"

expect "Enter system's hostname"
send "localhost\n"

expect "Enter the instance name"
send "localhost\n"

expect "Enter port number"
send "389\n"

expect "Create self-signed certificate database"
send "yes\n"

expect "Enter secure port number"
send "636\n"

expect "Enter Directory Manager DN"
send "cn=Directory Manager\n"

expect "Enter the Directory Manager password"
send "test_password\n"

expect "Confirm the Directory Manager Password"
send "test_password\n"

expect "Choose whether mdb or bdb is used"
send "mdb\n"

expect "Enter the lmdb database size"
send "20Gb\n"

expect "Enter the database suffix"
send "none\n"

expect "Do you want to start the instance after the installation"
send "no\n"

expect "Are you ready to install"
send "yes\n"

# 等待命令完成
expect eof
EOD
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dscreate -h | grep "usage: dscreate"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    dscreate create-template 389_ds_test.inf
    test -f 389_ds_test.inf 
    CHECK_RESULT $? 0 0 "L$LINENO: create-template No Pass"
    dscreate from-file 389_ds_test.inf | grep "Completed installation for"
    CHECK_RESULT $? 0 0 "L$LINENO: from-file No Pass"
    dsctl localhost remove --do-it
    dscreate -j from-file 389_ds_test.inf
    CHECK_RESULT $? 0 0 "L$LINENO: -j No Pass"
    dsctl localhost remove --do-it
    dscreate -v from-file 389_ds_test.inf | grep "DEBUG: FINISH: Completed installation for"
    CHECK_RESULT $? 0 0 "L$LINENO: from-file No Pass"
    dsctl localhost remove --do-it
    bash dscreate_interactive_shell.sh | grep "Starting installation"
    CHECK_RESULT $? 0 0 "L$LINENO: interactive No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf dscreate_interactive_shell.sh /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"