#!/bin/bash
# Copyright (c), 2024-2024, HUAWEI tech. Co., Ltd.
# Description: secDetector basic test
# Author: lijiaming <lijiaming30@huawei.com>
# Create: 2024-07-29
# shellcheck disable=SC1017,SC1091

source ./common/common.sh
set +e

function pre_test() {
    secD_deploy
    secD_start
    useradd tester
}

function run_test() {
    python client.py > res.txt
    grep 'event_name:sched_process_fork' res.txt
    CHECK_RESULT $?
    grep 'event_name:readfile' res.txt
    CHECK_RESULT $?
    grep 'event_name:execve_cmd' res.txt
    CHECK_RESULT $?
    grep 'event_name:createfile' res.txt
    CHECK_RESULT $?
    grep 'event_name:delfile' res.txt
    CHECK_RESULT $?
    grep 'event_name:commit_creds' res.txt
    CHECK_RESULT $?
    grep 'event_type=createpipe' res.txt
    CHECK_RESULT $?

}

function post_test() {
    rm -rf res.txt
    userdel -r tester
    secD_stop
    secD_remove
}

main "$@"
