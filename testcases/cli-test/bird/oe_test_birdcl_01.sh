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
    expect "bird>" {send "quit\n"}
    expect eof
EOF
    grep "bird> quit" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl exit failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "exit\n"}
    expect eof
EOF
    grep "bird> exit" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl exit failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "help\n"}
    send "quit\n"
    expect eof
EOF
    grep "for context sensitive help" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl help failed"
    rm -f tmp.txt
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "show pro\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1      OSPF" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl show failed"
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "dump pro\n"}
    send "quit\n"
    expect eof
EOF
    num=$(wc -l tmp.txt)
    if [[ $num == 4 ]]; then
	echo "aa" | grep "aa"
    else
	echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check birdcl dump failed"
    rm -f tmp.txt
    # test eval
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "eval 15+20\n"}
    send "quit\n"
    expect eof
EOF
    grep "35" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl eval failed"
    rm -f tmp.txt
    # test disable
    expect <<EOF > tmp.txt
    spawn birdcl
    expect "bird>" {send "disable ospf1\n"}
    send "quit\n"
    expect eof
EOF
    grep "ospf1: disabled" tmp.txt
    CHECK_RESULT $? 0 0 "check birdcl disable failed"
    rm -f tmp.txt
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    clean_dir
    kill -9 $(pgrep "bird -c")
    rm -rf ./sim_*
    LOG_INFO "End to restore the test environment."
}
main "$@"
