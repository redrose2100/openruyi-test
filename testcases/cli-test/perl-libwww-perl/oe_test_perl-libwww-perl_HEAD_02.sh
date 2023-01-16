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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL perl-libwww-perl
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    HEAD -u http://www.baidu.com 2>&1 | grep 'HEAD http://www.baidu.com'
    CHECK_RESULT $? 0 0 "Check HEAD -u  failed"
    HEAD -U http://www.baidu.com 2>&1 | grep 'User-Agent: lwp-request'
    CHECK_RESULT $? 0 0 "Check HEAD -U  failed"
    HEAD -s http://www.baidu.com 2>&1 | grep '200 OK'
    CHECK_RESULT $? 0 0 "Check HEAD -s  failed"
    HEAD -S http://www.baidu.com 2>&1 | grep '-Peer'
    CHECK_RESULT $? 0 0 "Check HEAD -S  failed"
    HEAD -e http://www.baidu.com 2>&1 | grep '200 OK'
    CHECK_RESULT $? 0 0 "Check HEAD -e  failed"
    HEAD -E http://www.baidu.com 2>&1 | grep 'User-Agent: lwp-request'
    CHECK_RESULT $? 0 0 "Check HEAD -E  failed"
    HEAD -d http://www.baidu.com 2>&1 | grep 'OK'
    CHECK_RESULT $? 0 0 "Check HEAD -d  failed"
    HEAD -o HTML http://www.baidu.com 2>&1 | grep 'Cache-Control'
    CHECK_RESULT $? 0 0 "Check HEAD -o  failed"
    HEAD -v 2>&1 | grep 'This is lwp-request version'
    CHECK_RESULT $? 0 0 "Check HEAD -v failed"
    HEAD -h 2>&1 | grep 'Usage: HEAD '
    CHECK_RESULT $? 0 0 "Check HEAD  -h failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Eed to restore the test environment."
}

main $@
