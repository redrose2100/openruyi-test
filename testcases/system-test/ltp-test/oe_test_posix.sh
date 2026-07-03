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
# @Author    :   hanson_fang
# @Contact   :   490538494@qq.com
# @Date      :   2023.06.30
# @License   :   Mulan PSL v2
# @Desc      :   ltp testsuite
# ############################################

#shellcheck disable=SC2034
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
                tag=$(git ls-remote --tags --sort=-v:refname \
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
    export LANG=en_US.UTF-8
    current_path=$(cd "$(dirname "$0")" || exit 1
        pwd
    )
    ltp_tag=$(select_ltp_tag)
    until [ -e "ltp" ]
    do
        git clone -b "$ltp_tag" https://github.com/linux-test-project/ltp.git
    done
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd ltp/testcases/open_posix_testsuite || exit 1
    autoreconf -fvi || { LOG_ERROR "autoreconf failed"; exit 1; }
    ./configure || { LOG_ERROR "configure failed"; exit 1; }
    make all >> /dev/null 2>&1
    make conformance-test > /opt/posix_conformance_result.txt
    pcnt=$(grep PASS /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    tcnt=$(grep TOTAL /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
    rate=$(awk 'BEGIN{printf "%.5f\n", ('"$pcnt"'/'"$tcnt"')}')
    awk -v rate="$rate" 'BEGIN{print(rate>0.97)?"0":"1"}'
    CHECK_RESULT $? 0 0 "bin case pass rate lower than 97%"
    cd bin || exit 1
    ./run-all-posix-option-group-tests.sh AIO >/opt/AIO.txt
    file="/opt/AIO.txt"
    pass=$(grep -cE 'Test PASSED|TEST PASSED|Test passed' "$file" 2>/dev/null) || pass=0
    fail=$(grep -E 'FAIL' "$file" 2>/dev/null | grep -cvE 'PASSED|passed') || fail=0
    untested=$(grep -c 'UNTESTED' "$file" 2>/dev/null) || untested=0
    unsupported=$(grep -c 'UNSUPPORTED' "$file" 2>/dev/null) || unsupported=0
    skipped=$(grep -c 'Test skipped' "$file" 2>/dev/null) || skipped=0
    total=$((pass + fail + untested + unsupported + skipped))
    rate=$(awk -v p="$pass" -v t="$total" 'BEGIN{printf "%.5f\n", p/t}')
    awk -v rate="$rate" 'BEGIN{print(rate>0.97)?"0":"1"}'
    CHECK_RESULT $? 0 0 "bin case pass rate lower than 97%"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    export LANG=${OLD_LANG}
    cd "${current_path}" || exit 1
    rm -rf "${current_path}"/ltp /opt/ltp /opt/posix_conformance_result.txt /opt/AIO.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
