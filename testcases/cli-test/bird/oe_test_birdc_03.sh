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
# shellcheck disable=SC1091,SC2003,SC2020
source "${OET_PATH}"/libs/locallibs/common_lib.sh
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
    # test graceful restart
    expect <<EOF >tmp.txt
    spawn birdc
    expect "bird>" {send "graceful restart\n"}
    send "quit\n"
    expect eof
EOF
    grep "Graceful restart requested" tmp.txt
    CHECK_RESULT $? 0 0 "check birdc graceful restart failed"
    rm -f tmp.txt
    bird -c ./data/bird.conf
    # test echo
    expect <<EOF >tmp.txt
    spawn birdc
    expect "bird>" {send "echo all\n"}
    send "quit\n"
    expect eof
EOF
    num=$(wc -l tmp.txt | tr -d ' tmp.txt')
    if [[ $(expr "${num}") -gt 0 ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check birdc echo failed"
    rm -f tmp.txt
    # test debug
    expect <<EOF >tmp.txt
    spawn birdc
    expect "bird>" {send "debug all{ states}\n"}
    send "quit\n"
    expect eof
EOF
    num=$(wc -l tmp.txt | tr -d ' tmp.txt')
    if [[ $(expr "${num}") -gt 0 ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check birdc debug failed"
    rm -f tmp.txt
    # test mrtdump
    expect <<EOF >tmp.txt
    spawn birdc
    expect "bird>" {send "mrtdump all{ states}\n"}
    send "quit\n"
    expect eof
EOF
    num=$(wc -l tmp.txt | tr -d ' tmp.txt')
    if [[ $(expr "${num}") -gt 0 ]]; then
        echo "aa" | grep "aa"
    else
        echo "aa" | grep "bb"
    fi
    CHECK_RESULT $? 0 0 "check birdc mrtdump failed"
    rm -f tmp.txt
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    pgrep bird | xargs kill -9
    clean_dir
    LOG_INFO "End to restore the test environment."
}
main "$@"
