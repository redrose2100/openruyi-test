#!/bin/bash

#######################################################################
# - glibc basic function test
# - Verify core glibc utilities work correctly on openEuler
#######################################################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glibc glibc-common"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: ldd command returns valid version info
    ldd --version | grep -i "GNU libc"
    CHECK_RESULT $? 0 0 "Check ldd version failed"

    # Test 2: getconf returns glibc version string
    getconf GNU_LIBC_VERSION | grep -E "^glibc [0-9]"
    CHECK_RESULT $? 0 0 "Check getconf GNU_LIBC_VERSION failed"

    # Test 3: iconv UTF-8 to GBK conversion works correctly
    echo "hello" | iconv -f UTF-8 -t GBK | iconv -f GBK -t UTF-8 | grep "hello"
    CHECK_RESULT $? 0 0 "Check iconv UTF-8 to GBK conversion failed"

    # Test 4: iconv UTF-8 to UTF-16 conversion works correctly
    echo "test" | iconv -f UTF-8 -t UTF-16 | iconv -f UTF-16 -t UTF-8 | grep "test"
    CHECK_RESULT $? 0 0 "Check iconv UTF-8 to UTF-16 conversion failed"

    # Test 5: locale -a returns at least one locale
    locale -a | wc -l | awk '{if($1 > 0) exit 0; else exit 1}'
    CHECK_RESULT $? 0 0 "Check locale -a output is empty"

    # Test 6: en_US locale is available
    locale -a | grep -i "en_US"
    CHECK_RESULT $? 0 0 "Check en_US locale is not available"

    # Test 7: dynamic linker auxv output is non-empty
    LD_SHOW_AUXV=1 /bin/true | grep -i "AT_PAGESZ"
    CHECK_RESULT $? 0 0 "Check LD_SHOW_AUXV output failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"