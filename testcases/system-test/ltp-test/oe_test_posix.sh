#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY or FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023.06.30
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite
# ############################################

#shellcheck disable=SC2034,SC2120
source "$OET_PATH/libs/locallibs/common_lib.sh"

select_ltp_tag() {
    local k
    k=$(uname -r | awk -F. '{printf "%d%02d",$1,$2}')
    local default_tag="20260130"
    local mirror="https://ghproxy.com/https://github.com/linux-test-project/ltp.git"

    case $k in
        419|510)    echo 20220121 ;;
        606)        echo 20260130 ;;
        *)
            local tag=""
            for url in "https://github.com/linux-test-project/ltp.git" "$mirror"; do
                tag=$(GIT_SSL_NO_VERIFY=true git ls-remote --tags --sort=-v:refname \
                      "$url" 2>/dev/null \
                      | awk -F/ '{print $3}' | grep -E '^[0-9]{8}$' | head -1)
                [[ -n "$tag" ]] && break
            done
            echo "${tag:-$default_tag}"
            ;;
    esac
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    EXECUTE_T="240m"
    DNF_INSTALL "zlib gcc-c++ bc m4 flex byacc bison keyutils-libs-devel lksctp-tools-devel xfsprogs-devel libacl-devel openssl-devel numactl-devel libaio-devel glibc-devel libcap-devel findutils libtirpc libtirpc-devel kernel-headers glibc-headers hwloc-devel patch numactl tar make automake cmake time psmisc git"
    OLD_LANG=$LANG
    LANG=en_US.UTF-8
    export LANG
    current_path=$(cd "$(dirname "$0")" || exit 1
        pwd
    )
    tmp_dir=$(mktemp -d /tmp/posix_test_XXXXXX)
    ltp_tag=$(select_ltp_tag)
    # Retry git clone up to 3 times with 5s delay
    local retry=0
    while [ ! -d "ltp" ] && [ $retry -lt 3 ]; do
        git clone -b "$ltp_tag" https://github.com/linux-test-project/ltp.git
        retry=$((retry + 1))
        [ ! -d "ltp" ] && SLEEP_WAIT 5
    done
    [ -d "ltp" ] || { LOG_ERROR "git clone failed after $retry retries"; exit 1; }
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd ltp/testcases/open_posix_testsuite || exit 1
    autoreconf -fvi || { LOG_ERROR "autoreconf failed"; exit 1; }
    ./configure || { LOG_ERROR "configure failed"; exit 1; }
    # Build all POSIX test cases
    make all >> /dev/null 2>&1
    CHECK_RESULT $? 0 0 "make all failed"
    # Run conformance tests
    make conformance-test > "$tmp_dir/posix_conformance_result.txt"
    CHECK_RESULT $? 0 0 "make conformance-test failed"
    # Parse conformance results: PASS count and TOTAL count
    local pcnt tcnt rate ret
    pcnt=$(awk '/PASS/{sum+=$2} END{print sum+0}' "$tmp_dir/posix_conformance_result.txt")
    tcnt=$(awk '/TOTAL/{sum+=$2} END{print sum+0}' "$tmp_dir/posix_conformance_result.txt")
    rate=$(awk -v p="$pcnt" -v t="$tcnt" 'BEGIN{if(t>0) printf "%.5f\n", p/t; else print 0}')
    ret=$(awk -v rate="$rate" 'BEGIN{print(rate>0.97)?"0":"1"}')
    LOG_INFO "conformance: pass=$pcnt total=$tcnt rate=$rate"
    CHECK_RESULT $ret 0 0 "conformance test pass rate lower than 97%"
    # Run AIO option group tests
    cd bin || exit 1
    ./run-all-posix-option-group-tests.sh AIO > "$tmp_dir/AIO.txt"
    CHECK_RESULT $? 0 0 "AIO option group tests failed"
    local file="$tmp_dir/AIO.txt"
    local pass fail untested unsupported skipped total
    pass=$(grep -cE 'Test PASSED|TEST PASSED|Test passed' "$file" 2>/dev/null) || pass=0
    fail=$(grep -E 'FAIL' "$file" 2>/dev/null | grep -cvE 'PASSED|passed') || fail=0
    untested=$(grep -c 'UNTESTED' "$file" 2>/dev/null) || untested=0
    unsupported=$(grep -c 'UNSUPPORTED' "$file" 2>/dev/null) || unsupported=0
    skipped=$(grep -c 'Test skipped' "$file" 2>/dev/null) || skipped=0
    total=$((pass + fail + untested + unsupported + skipped))
    rate=$(awk -v p="$pass" -v t="$total" 'BEGIN{if(t>0) printf "%.5f\n", p/t; else print 0}')
    ret=$(awk -v rate="$rate" 'BEGIN{print(rate>0.97)?"0":"1"}')
    LOG_INFO "AIO: pass=$pass fail=$fail untested=$untested unsupported=$unsupported skipped=$skipped total=$total rate=$rate"
    CHECK_RESULT $ret 0 0 "AIO test pass rate lower than 97%"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LANG=${OLD_LANG}
    export LANG
    cd "${current_path}" || exit 1
    rm -rf "${current_path}"/ltp "$tmp_dir"
    LOG_INFO "End to restore the test environment."
}

main "$@"
