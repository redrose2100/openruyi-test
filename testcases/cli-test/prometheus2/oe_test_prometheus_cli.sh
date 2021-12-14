#!/usr/bin/bash

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL prometheus2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Start to check flag: --version"
    prometheus --version
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    LOG_INFO "Finish to check flag: --version"

    LOG_INFO "Start to check flag: --help"
    prometheus --help
    CHECK_RESULT $? 0 0 'Failed to output version info.'
    LOG_INFO "Finish to check flag: --help"

    LOG_INFO "Start to check flag: --config.file"
    LOG_INFO "Using config file $(pwd)/test.yml"
    current_testcase_folder=$(pwd)
    cd "${current_testcase_folder}" || LOG_WARN "cd failed!!!"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
