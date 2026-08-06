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
    pre_env 3
}
function run_test(){
    # urma单通道 （多节点只有urma）
    start_RA kernel_reboot 0 0
    SSH_CMD "reboot" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "reboot" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    sleep 60

    check_log 0 RA 1009 1010
    check_log 0 alarmd 1009 1010
    check_log 0 monitor 1009 1010
    
}
function post_test(){
    clean_sysSentry_message
}

main "$@"