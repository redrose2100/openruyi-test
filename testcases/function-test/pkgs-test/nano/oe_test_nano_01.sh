#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Test nano command: installation, version and display options
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/nano/common/nano_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nano"
    mkdir -p /tmp/nano_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/nano_test || exit 1

    # Verify nano is installed
    rpm -q nano
    CHECK_RESULT $? 0 0 "nano package is not installed"

    # Verify binary exists
    test -f /usr/bin/nano
    CHECK_RESULT $? 0 0 "nano binary does not exist"

    # Verify version matches rpm metadata
    pkg_version=$(rpm -q nano --qf '%{VERSION}')
    nano --version | grep "${pkg_version}"
    CHECK_RESULT $? 0 0 "nano --version does not match rpm version"

    # Verify --help output
    nano --help | grep "Usage: nano"
    CHECK_RESULT $? 0 0 "nano --help does not show usage"

    # Test -H: enable history log — search operation triggers history file
    expect <<EOF
        log_file /tmp/nano_test/log_historylog
        set timeout 15
        spawn nano -H historylog.txt
        sleep 1
        send "history test\r"
        sleep 1
        send "\027"
        sleep 1
        send "history\r"
        sleep 1
        send "\r"
        sleep 1
        send "\017"
        sleep 1
        send "\r"
        sleep 1
        send "\030"
        sleep 1
        expect eof
EOF
    test -f ~/.local/share/nano/search_history
    CHECK_RESULT $? 0 0 "nano -H did not create search history file"

    # Test -l: display line numbers, file content unchanged
    echo "line number test" > linenumbers.txt
    nano_open_exit "-l" linenumbers.txt
    grep "line number test" linenumbers.txt
    CHECK_RESULT $? 0 0 "nano -l altered file content"

    # Test -m: enable mouse support, file content unchanged
    echo "mouse test" > mouse.txt
    nano_open_exit "-m" mouse.txt
    grep "mouse test" mouse.txt
    CHECK_RESULT $? 0 0 "nano -m altered file content"

    # Test -x: hide help lines, file content unchanged
    echo "no help test" > nohelp.txt
    nano_open_exit "-x" nohelp.txt
    grep "no help test" nohelp.txt
    CHECK_RESULT $? 0 0 "nano -x altered file content"

    # Test -Y: specify syntax highlighting, verify nano starts and exits
    echo "syntax test" > syntax.txt
    nano_open_exit "-Y c" syntax.txt
    grep "syntax test" syntax.txt
    CHECK_RESULT $? 0 0 "nano -Y altered file content"

    # Test -q: display scrollbar indicator, verify nano starts and exits
    echo "indicator test" > indicator.txt
    nano_open_exit "-q" indicator.txt
    grep "indicator test" indicator.txt
    CHECK_RESULT $? 0 0 "nano -q altered file content"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/nano_test
    rm -rf ~/.local/share/nano
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
