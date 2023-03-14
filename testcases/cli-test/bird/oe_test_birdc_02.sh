#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhuwenshuo
#@Contact       :   1003254035@qq.com
#@Date          :   2023/02/21
#@License   	:   Mulan PSL v2
#@Desc      	:   verification birdc command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source "./common/lib/util.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bird tar"
    extract_data
    bird -c ./data/bird.conf
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test enable
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "disable ospf1\n"}
    expect "bird>" {send "enable ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: enabled" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc enable failed"
    rm -f tmp.txt
    # test restart
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "restart ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: restarted" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc restart failed"
    rm -f tmp.txt
    # test reload
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "reload ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: reloading" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc reload failed"
    rm -f tmp.txt
    # test restrict
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "restrict\n"}
    send "quit\n"
    expect eof
EOF
    grep "Access restricted" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc restrict failed"
    rm -f tmp.txt
    # test configure
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "configure\n"}
    send "quit\n"
    expect eof
EOF
    grep "Reconfigured" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc configure failed"
    rm -f tmp.txt
    # test down
    expect <<EOF > tmp.txt
    spawn birdc
    expect "bird>" {send "down\n"}
    send "quit\n"
    expect eof
EOF
    grep "Shutdown requested" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc down failed"
    rm -f tmp.txt
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    kill -9 $(pgrep "bird -c")
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
