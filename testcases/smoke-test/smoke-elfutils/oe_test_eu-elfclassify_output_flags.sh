#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/06/05
# @License   :   Mulan PSL v2
# @Desc      :   eu-elfclassify 输出选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
source ./package_lib.sh
set +e
test_log=tmp_test.log

function pre_test() {
    yum -y install elfutils eu-elfclassify
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-elfclassify --executable --matching --print /usr/bin/vi &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "/usr/bin/vi"
    CHECK_RESULT $? 0 0

    eu-elfclassify --executable --matching --no-print /usr/bin/vi &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --core --not-matching --print /usr/bin/vi &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "/usr/bin/vi"
    CHECK_RESULT $? 0 0

    printf '%s\n%s\n' /usr/bin/zip /usr/bin/vi | eu-elfclassify --executable -f --print --stdin --     print0 &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "/usr/bin/zip/usr/bin/vi"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    rm -rf $test_log
    yum -y remove elfutils eu-elfclassify
}

main "$@"
~
~
~

