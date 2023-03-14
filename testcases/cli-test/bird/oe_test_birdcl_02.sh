#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Desc      	:   verification birdcl command
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
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "disable ospf1\n"}
    expect "bird>" {send "enable ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: enabled" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl enable failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "restart ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: restarted" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl restart failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "reload ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: reloading" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl reload failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "restrict\n"}
    send "quit\n"
    expect eof
EOF
    grep "Access restricted" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl restrict failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "configure\n"}
    send "quit\n"
    expect eof
EOF
    grep "Reconfigured" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl configure failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "down\n"}
    send "quit\n"
    expect eof
EOF
    grep "Shutdown requested" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl down failed"
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
