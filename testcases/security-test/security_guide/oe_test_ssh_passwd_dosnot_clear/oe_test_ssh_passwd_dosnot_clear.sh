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
# @Desc      :   Password does not echo in clear text when SSH executes command remotely
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^testuser:" /etc/passwd && userdel -rf testuser
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # Use a dedicated password that does not appear in any environment text
    # (hostname/prompt/banner), otherwise the grep below matches the shell
    # prompt instead of real password echo.
    local test_passwd="Oetest1@Sec23"
    useradd testuser
    grep "^testuser" /etc/passwd
    CHECK_RESULT $?
    passwd testuser <<EOF
${test_passwd}
${test_passwd}
EOF
    CHECK_RESULT $? 0 0 "set testuser password failed"
    expect <<EOF
    set timeout 15    
    log_file testlog
    spawn ssh testuser@${NODE1_IPV4}
    expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password:" {
                send "${test_passwd}\\r"
            }
        }
        expect eof
EOF
    SLEEP_WAIT 10
    grep "${test_passwd}" testlog
    CHECK_RESULT $? 0 1 "The login password is echoed in plain text"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    userdel -rf testuser
    rm -rf testlog /run/faillock/testuser
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
