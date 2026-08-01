#!/usr/bin/bash
# shellcheck disable=SC1091,SC2154
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


source "comm/lib.sh"
set -x

function pre_test(){
    pre_env
}
function run_test(){
    # uvb单通道
    sentryctl set sentry_remote_reporter --urma_comm=off
    SSH_CMD "set sentry_remote_reporter --urma_comm=off" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    
    sentryctl set sentry_uvb_comm --server_cna="${node2_cna}"
    SSH_CMD "sentryctl set sentry_uvb_comm --server_cna='${node1_cna}'"  "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    start_RA panic 0 0
    SSH_CMD "echo c > /proc/sysrq-trigger" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sleep 60

    check_log 0 RA 1007 1008
    check_log 0 alarmd 1007 1008
    check_log 0 monitor 1007 1008
}
function post_test(){
    clean_sysSentry_message
}

main "$@"