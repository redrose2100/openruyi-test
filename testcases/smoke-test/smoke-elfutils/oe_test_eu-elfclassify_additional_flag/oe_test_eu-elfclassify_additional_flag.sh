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
# @Desc      :   eu-elfclassify 附加选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
test_log=tmp_test.log

function pre_test() {
    yum -y install elfutils eu-elfclassify
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-elfclassify --core not_exist &> $test_log
    CHECK_RESULT $? 2 0
    test "$(cat $test_log)" = "eu-elfclassify: opening 'not_exist': No such file or directory"
    CHECK_RESULT $? 0 0

    eu-elfclassify --core -q not_exist &> $test_log
    CHECK_RESULT $? 2 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --executable /usr/bin/vi -v &> $test_log
    CHECK_RESULT $? 0 0
    grep 'info: /usr/bin/vi: has sections' $test_log
    CHECK_RESULT $? 0 0
    grep 'debug: /usr/bin/vi: executable' $test_log
    CHECK_RESULT $? 1 0
    grep 'debug: section header .text (type 1) found' $test_log
    CHECK_RESULT $? 1 0

    eu-elfclassify --executable /usr/bin/vi -vv &> $test_log
    CHECK_RESULT $? 0 0
    grep 'info: /usr/bin/vi: has sections' $test_log
    CHECK_RESULT $? 0 0
    grep 'debug: /usr/bin/vi: executable' $test_log
    CHECK_RESULT $? 0 0
    grep 'debug: section header .text (type 1) found' $test_log
    CHECK_RESULT $? 1 0

    eu-elfclassify --executable /usr/bin/vi -vvv &> $test_log
    CHECK_RESULT $? 0 0
    grep 'info: /usr/bin/vi: has sections' $test_log
    CHECK_RESULT $? 0 0
    grep 'debug: /usr/bin/vi: executable' $test_log
    CHECK_RESULT $? 0 0
    grep 'debug: section header .text (type 1) found' $test_log
    CHECK_RESULT $? 0 0
    LOG_INFO "End to run test."
}

function post_test() {
    rm -rf $test_log
    yum -y remove elfutils eu-elfclassify
}

main "$@"
