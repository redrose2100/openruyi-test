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
# @Date      :   2024/06/06
# @License   :   Mulan PSL v2
# @Desc      :   eu-elfclassify 输入选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log

function pre_test() {
    yum -y install elfutils eu-elfclassify
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-elfclassify --executable -f /usr/bin/zip &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    eu-elfclassify --executable --file /usr/bin/zip &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0

    eu-elfclassify --executable -f /usr/bin/sh &> $test_log
    CHECK_RESULT $? 1 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0
    eu-elfclassify --executable --file /usr/bin/sh &> $test_log
    CHECK_RESULT $? 1 0
    test "$(cat $test_log)" = ""
    CHECK_RESULT $? 0 0

    echo /usr/bin/zip | eu-elfclassify --executable --print --no-stdin /usr/bin/vi &> $test_log
    CHECK_RESULT $? 0 0

    if version_compare "${ETS_VERSION}" ">=" "V200R011"; then

        test "$(cat $test_log)" = "/usr/bin/vi"
        CHECK_RESULT $? 0 0
    fi
    echo /usr/bin/zip | eu-elfclassify --executable --print --stdin /usr/bin/vi &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "$(echo -e '/usr/bin/vi\n/usr/bin/zip')"
    CHECK_RESULT $? 0 0

    printf '%s\n%s\n' /usr/bin/zip /usr/bin/vi | eu-elfclassify --executable -f --print --stdin &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "$(echo -e '/usr/bin/zip\n/usr/bin/vi')"
    CHECK_RESULT $? 0 0
    printf '%s\0%s\0' /usr/bin/zip /usr/bin/vi | eu-elfclassify --executable -f --print --stdin0 &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "$(echo -e '/usr/bin/zip\n/usr/bin/vi')"
    CHECK_RESULT $? 0 0

    gzip -c /usr/bin/vi > tmp_test.gz
    CHECK_RESULT $? 0 0
    eu-elfclassify --compressed --executable --print tmp_test.gz &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "tmp_test.gz"
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    yum -y remove elfutils eu-elfclassify
}

main "$@"
