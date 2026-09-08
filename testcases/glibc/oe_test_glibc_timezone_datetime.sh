#!/bin/bash

#######################################################################
# - glibc timezone and datetime function test
# - Verify timezone handling and date/time functions work correctly
#######################################################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glibc glibc-common tzdata"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: timedatectl list-timezones returns non-empty output
    timedatectl list-timezones | wc -l | awk '{if($1 > 100) exit 0; else exit 1}'
    CHECK_RESULT $? 0 0 "Check timedatectl list-timezones output too short"

    # Test 2: Asia/Shanghai timezone exists in timezone data
    timedatectl list-timezones | grep "Asia/Shanghai"
    CHECK_RESULT $? 0 0 "Check Asia/Shanghai timezone not found"

    # Test 3: date command with format string outputs correctly
    date "+%Y-%m-%d" | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
    CHECK_RESULT $? 0 0 "Check date format output failed"

    # Test 4: TZ environment variable correctly changes timezone
    TZ="America/New_York" date "+%Z" | grep -E "EST|EDT"
    CHECK_RESULT $? 0 0 "Check TZ America/New_York failed"

    # Test 5: TZ Asia/Tokyo outputs correct timezone abbreviation
    TZ="Asia/Tokyo" date "+%Z" | grep "JST"
    CHECK_RESULT $? 0 0 "Check TZ Asia/Tokyo failed"

    # Test 6: date -d can parse date string correctly
    date -d "2025-01-01" "+%Y" | grep "2025"
    CHECK_RESULT $? 0 0 "Check date -d parsing failed"

    # Test 7: strftime via date supports epoch conversion
    date -d "@0" -u "+%Y-%m-%d" | grep "1970-01-01"
    CHECK_RESULT $? 0 0 "Check epoch 0 conversion failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"