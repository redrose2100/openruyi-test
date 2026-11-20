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
# @Date      :   2022/06/09
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of wget
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL wget
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    cp /etc/resolv.conf /etc/resolv.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 用例要验证的是 DNS 不可用时 getaddrinfo 失败。原实现靠 grep wget 的报错
    # 文案（unable to resolve / Couldn't resolve ...），这些是 wget1 的措辞；
    # openRuyi 的 wget 实际是 wget2（输出形如 "[0] Downloading ..."），
    # 文案不一致导致 grep 落空。这里改用确定不存在的 .invalid 域名 + 退出码断言，
    # 既覆盖真实失败路径，也不依赖具体版本的报错文本。
    echo "" >/etc/resolv.conf
    wget -q -O /dev/null http://glibc-getaddrinfo-test.invalid >/tmp/wget_dns_fail.log 2>&1
    CHECK_RESULT $? 1 0 "wget should fail when the host cannot be resolved"
    cp -f /etc/resolv.conf.bak /etc/resolv.conf
    rm -rf /etc/resolv.conf.bak
    wget -q -O index.html www.baidu.com
    CHECK_RESULT $? 0 0 "Failed to execute wget"
    test -f index.html
    CHECK_RESULT $? 0 0 "Failed to check wget"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf index.html /tmp/wget_dns_fail.log
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
