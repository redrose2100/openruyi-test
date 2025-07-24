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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of perl-libwww-perl command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl-libwww-perl perl-CPAN tar"
    tar -zxvf common/HTML-Tree-5.07.tar.gz
    cd HTML-Tree-5.07 || exit 1
    perl Build.PL
    ./Build
    ./Build test
    ./Build install
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    POST -m GET http://www.baidu.com 2>&1 | grep 'STATUS OK'
    CHECK_RESULT $? 0 0 "Check POST -m failed"
    POST -m GET http://www.baidu.com -f 2>&1 | grep 'STATUS OK'
    CHECK_RESULT $? 0 0 "Check POST -f failed"
    POST -m GET http://www.baidu.com -b http://cn.bing.com/ 2>&1 | grep 'http-equiv'
    CHECK_RESULT $? 0 0 "Check POST -b failed"
    POST -m GET http://www.baidu.com -a -t 10 2>&1 | grep 'content'
    CHECK_RESULT $? 0 0 "Check POST -a -t failed"
    POST -m GET http://www.baidu.com -p http://cn.bing.com/
    CHECK_RESULT $? 0 0 "Check POST -p failed"
    POST -m GET http://www.baidu.com -P -H 'token:11111' 2>&1 | grep 'meta'
    CHECK_RESULT $? 0 0 "Check POST -P failed"
    POST -m GET http://www.baidu.com -H 'token:11111' 2>&1 | grep 'head'
    CHECK_RESULT $? 0 0 "Check POST -H failed"
    POST -m GET http://www.baidu.com -C root:123456 http://www.baidu.com 2>&1 | grep 'meta'
    CHECK_RESULT $? 0 0 "Check POST -C failed"
    POST -m GET -i "$(date +"%F %T")" http://www.baidu.com | grep 'meta'
    CHECK_RESULT $? 0 0 "Check POST -i failed"
    echo name=admin | POST -f -c application/x-www-form-urlencoded www.baidu.com | grep -F "<hr><center>nginx</center>"
    CHECK_RESULT $? 0 0 "Check POST -i failed"
    POST -m GET -o html www.baidu.com | grep 'content'
    CHECK_RESULT $? 0 0 "Check POST -o failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd .. || exit 1
    rm -rf HTML-Tree-5.07
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
