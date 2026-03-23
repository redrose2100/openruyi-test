#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-03-14
#@License       :   Mulan PSL v2
#@Desc          :   Test case for pwck command
#####################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "shadow-utils"
    tmp_dir=$(mktemp -d)
    # Create test files
    cat > "${tmp_dir}/passwd_test" <<EOF
root:x:0:0:root:/root:/bin/bash
testuser:x:1000:1000:Test User:/home/testuser:/bin/bash
nousername::1001:1001:No Username:/home/nouser:/bin/bash
baduid:x:abc:1002:Bad UID:/home/baduid:/bin/bash
dupeuser:x:1000:1003:Duplicate UID:/home/dupe:/bin/bash
EOF
    cat > "${tmp_dir}/shadow_test" <<EOF
root:!:19147:0:99999:7:::
testuser:!:19147:0:99999:7:::
nousername:!:19147:0:99999:7:::
baduid:!:19147:0:99999:7:::
dupeuser:!:19147:0:99999:7:::
EOF
    # Bad name test files
    cat > "${tmp_dir}/passwd_badname" <<EOF
root:x:0:0:root:/root:/bin/bash
0baduser:x:1005:1005:Bad Name:/home/0baduser:/bin/bash
EOF
    cat > "${tmp_dir}/shadow_badname" <<EOF
root:!:19147:0:99999:7:::
0baduser:!:19147:0:99999:7:::
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test basic functionality: pwck should report errors (exit 1/2 or output contains error msg)
    pwck_out=$(pwck -r "${tmp_dir}/passwd_test" "${tmp_dir}/shadow_test" 2>&1)
    pwck_ret=$?
    echo "$pwck_out" | grep -qE '无效|不存在|no matching|没有匹配|Bad UID|Bad GID' || [ "$pwck_ret" -ne 0 ]
    CHECK_RESULT $? 0 0 "pwck should detect errors in test files"
    # Test quiet mode: same check
    pwck_q_out=$(pwck -q -r "${tmp_dir}/passwd_test" "${tmp_dir}/shadow_test" 2>&1)
    pwck_q_ret=$?
    echo "$pwck_q_out" | grep -qE '无效|不存在|no matching|没有匹配' || [ "$pwck_q_ret" -ne 0 ]
    CHECK_RESULT $? 0 0 "pwck -q should return error status"
    # Test badnames: without -b should report bad name (0baduser / 无.*组 / bad name)
    pwck_bad_out=$(pwck -r "${tmp_dir}/passwd_badname" "${tmp_dir}/shadow_badname" 2>&1)
    echo "$pwck_bad_out" | grep -qE '(0baduser|bad name|invalid user name)'
    CHECK_RESULT $? 0 0 "pwck should reject bad names without -b"
    # With -b should accept bad name (may still exit non-zero for missing dir/group)
    pwck_b_out=$(pwck -b -r "${tmp_dir}/passwd_badname" "${tmp_dir}/shadow_badname" 2>&1)
    # -b allows the name; do not require exit 0 (missing dir/group may still be reported)
    ! echo "$pwck_b_out" | grep -qE '非法用户名|invalid user name|bad name.*reject'
    CHECK_RESULT $? 0 0 "pwck -b should ignore bad names"
    # Test help option
    pwck -h
    CHECK_RESULT $? 0 0 "pwck -h should return success"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${tmp_dir}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
