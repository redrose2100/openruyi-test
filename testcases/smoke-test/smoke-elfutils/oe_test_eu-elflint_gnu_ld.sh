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
# @Desc      :   eu-elflint 选项 --gnu-ld,-q
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    yum -y install elfutils eu-elflint
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-elflint $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    grep "'.symtab': _DYNAMIC symbol size 0 does not match dynamic segment size 464" $test_log
    CHECK_RESULT $? 0 0

    eu-elflint --gnu-ld $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test "$(cat $test_log)" = "No errors"
    CHECK_RESULT $? 0 0

    eu-elflint --gnu-ld -q $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    LOG_INFO "End to run test."
}

function post_test() {
    rm -rf $test_log
    yum -y remove eu-elfint
}

main "$@"

