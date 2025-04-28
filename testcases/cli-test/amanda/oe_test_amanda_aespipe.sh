#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/07/07
# @License   :   Mulan PSL v2
# @Desc      :   Test amaespipe
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "amanda openssl wget gcc"
    wget https://loop-aes.sourceforge.net/aespipe-latest.tar.bz2
    tar -xvf aespipe-latest.tar.bz2
    cd aespipe-v* || exit
    ./configure
    make && make install
    cd - || exit
    rm -rf aespipe*
    mkdir -p /var/lib/amanda/.gnupg
    touch /var/lib/amanda/.gnupg/am_key.gpg
    mkdir -p ~/.gnupg/
    touch ~/.gnupg/gpg.conf
    echo "use-agent" >> ~/.gnupg/gpg.conf && echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
    echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
    expect <<-END
    	spawn sh -c {head -c 2925 /dev/random | uuencode -m - | head -n 66 | tail -n 65 | gpg --symmetric -a > /var/lib/amanda/.gnupg/am_key.gpg}
    	expect "Enter passphrase:"
    	send "abc\r"
    	expect eof
END
    echo "abc" >> /var/lib/amanda/.am_passphrase
    chown amandabackup:disk /var/lib/amanda/.am_passphrase
    chmod 700 /var/lib/amanda/.am_passphrase
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    amaespipe
    CHECK_RESULT $? 0 0 "Check amaespipe failed"
    nohup amcrypt &
    pgrep -fa "amcrypt"
    CHECK_RESULT $? 0 0 "Check amcrypt failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 "$(pgrep -f "amcrypt")"
    DNF_REMOVE "$@"
    rm -rf /amanda /etc/amanda tmp.txt ~/.gnupg/ /var/lib/amanda/*
    LOG_INFO "End to restore the test environment."
}

main "$@"
