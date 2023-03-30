#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/03/29
# @License   :   Mulan PSL v2
# @Desc      :   c-ares Asynchronous DNS resolution
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "c-ares curl curl-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    gcc /home/mugen/testcases/cli-test/c-ares/test_libcurl.c -lcurl
    CHECK_RESULT $? 0 0 "Compilation failure"
    DNS_ip=`cat /etc/resolv.conf |grep nameserver |awk 'NR==1' |awk '{print $2}'`
    ./a.out ${DNS_ip} www.baidu.com
    CHECK_RESULT $? 0 0 "Parsing failure"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./a.out
    LOG_INFO "Finish environment cleanup!"
}

main "$@"