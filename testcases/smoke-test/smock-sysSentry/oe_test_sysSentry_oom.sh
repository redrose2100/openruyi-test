#!/usr/bin/bash

# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   yangna 
# @Date      :   2025/12/12
# ##################################
# shellcheck disable=SC2002,SC2119

source "comm/lib.sh"
set -x

function pre_test(){
    pre_oom_env
}
function run_test(){
    start_RA oom
    CHECK_RESULT $? 0 0
    echo 50000 | sudo tee /proc/sys/vm/nr_hugepages

    check_oom_dmesg 0 0
    CHECK_RESULT $? 0 0

    check_RA_oom 1 1
    CHECK_RESULT $? 0 0

    check_alarmd 1005 71 " " 3
    CHECK_RESULT $? 0 0

    check_oom_sentry_msg_monitor 1 1 true
    CHECK_RESULT $? 0 0
 
}
function post_test(){
    clean_sysSentry_message
    echo 0 | sudo tee /proc/sys/vm/nr_hugepages
}

main "$@"