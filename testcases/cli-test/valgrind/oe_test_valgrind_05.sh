#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   jiangchenyang
# @Contact   :   jiangcy1129@163.com
# @Date      :   2023-08-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -o valgrind_test ./common/valgrind_test_05.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --xml=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "\-\-xml=yes has been specified" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xml error"
    valgrind --xml=yes --xml-fd=1 ./valgrind_test > valgrind_test.log 2>&1
    grep "xml version" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --xml-fd error"
    valgrind --xml=yes --xml-file=valgrind_test_xml.txt ./valgrind_test
    grep "xml version" valgrind_test_xml.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xml-file error"
    valgrind --xml=yes --xml-socket=127.0.0.1 ./valgrind_test > valgrind_test.log 2>&1
    grep "XML logging server '127.0.0.1'" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --log-socket error"
    valgrind --xml=yes --xml-user-comment=huawei --xml-file=valgrind_test_xml.txt ./valgrind_test
    grep "<usercomment>huawei<\/usercomment>" valgrind_test_xml.txt
    CHECK_RESULT $? 0 0 "execute valgrind --xml-user-comment error"
    valgrind --demangle=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --demangle error"
    valgrind --num-callers=2 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --num-callers error"
    valgrind --error-limit=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --error-limit error"
    valgrind --error-exitcode=1 ./valgrind_test
    CHECK_RESULT $? 1 0 "execute valgrind --error-exitcode error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
