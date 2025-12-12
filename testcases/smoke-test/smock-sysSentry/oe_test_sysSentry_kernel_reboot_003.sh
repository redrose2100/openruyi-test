#!/usr/bin/bash
# shellcheck disable=SC1091
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
    sentryctl set sentry_remote_reporter --cna "${node1_cna}" --eid "${node1_eid1};${node1_eid2}" --panic=on --kernel_reboot=on
    SSH_CMD "sentryctl set sentry_remote_reporter --cna=${node2_cna} --eid='${node2_eid1};${node2_eid2}' --panic=on --kernel_reboot=on " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    sentryctl set sentry_urma_comm --server_eid="${node1_eid1},${node2_eid1};${node1_eid2},${node2_eid2}" --client_jetty_id="${test_jetty_id}"
    SSH_CMD "sentryctl set sentry_urma_comm --server_eid='${node2_eid1},${node1_eid1};${node2_eid2},${node1_eid2}' --client_jetty_id=${test_jetty_id}" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    sentryctl set sentry_uvb_comm --server_cna="${node2_cna}"
    SSH_CMD "sentryctl set sentry_uvb_comm --server_cna='${node1_cna}'"  "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    start_RA kernel_reboot 0 20
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    check_log 0 RA 1009 1010
    check_log 0 alarmd 1009 1010
    check_log 0 monitor 1009 1010
    
}
function post_test(){
    clean_sysSentry_message
}

main "$@"