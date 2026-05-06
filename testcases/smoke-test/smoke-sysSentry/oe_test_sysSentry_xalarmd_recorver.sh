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
function check_RA_xalarmd_log() {
    SLEEP_WAIT 30 "systemctl is-active xalarmd.service" 2
    CHECK_RESULT $? 0 0
    sleep 6 #等服务重启
    start_RA xalarmd
    CHECK_RESULT $? 0 0

    start_RA plugin 
    CHECK_RESULT $? 0 0

    check_RA_xalarmd
    check_RA_plugin
}

function pre_test(){
    pre_xalarm_env
}
function run_test(){
    if [ -n "$version" ] && [ "$version" -gt 28 ]; then
        check_RA_xalarmd_log
        rm -rf "${run_alarm}"
        rm -rf "${run_report}"
        [ ! -e "${run_alarm}" ] && [ ! -e "${run_report}" ]
        CHECK_RESULT $? 0 0

        systemctl restart  xalarmd.socket
        [  -e "${run_alarm}" ] && [  -e "${run_report}" ]
        CHECK_RESULT $? 0 0

        SLEEP_WAIT 10 "systemctl status sysSentry" 1
        CHECK_RESULT $? 0 0

        SLEEP_WAIT 10 " sentryctl list | grep sentry_msg_monitor | grep RUNNING" 1 
        CHECK_RESULT $? 0 0


        for i in {1..1}; do
            SLEEP_WAIT 10 "systemctl start xalarmd" 1 
            systemctl status xalarmd
            CHECK_RESULT $? 0 0

            systemctl status xalarmd.socket
            CHECK_RESULT $? 0 0

            echo > "${task_log_path}"/sentry_msg_monitor.log

            kill -9 "$(pgrep -f /usr/bin/xalarmd)"
            SLEEP_WAIT 10 " grep 'Xalarmd service exception, try to re-register' ${task_log_path}/sentry_msg_monitor.log" 1 
            CHECK_RESULT $? 0 0

            cat "${task_log_path}"/sentry_msg_monitor.log
            SLEEP_WAIT 10 " grep 'sentry_msg_monitor start' ${task_log_path}/sentry_msg_monitor.log" 1 
            CHECK_RESULT $? 0 0

            SLEEP_WAIT 10 "systemctl is-active xalarmd" 1
            CHECK_RESULT $? 0 0

        done
    else
        check_RA_xalarmd_log
        clean_sysSentry_message

        rm -rf "${run_alarm}"
        rm -rf "${run_report}"
        check_RA_xalarmd_log
    
        clean_sysSentry_message
        rm -rf "${run_alarm}" && touch "${run_alarm}"
        rm -rf "${run_report}" && touch "${run_alarm}"
        check_RA_xalarmd_log

        chmod 700 "${run_alarm}"
        chmod 700 "${run_report}"
        check_RA_xalarmd_log

        grep "socket file ${run_alarm} permission .* set not properly, recover as default permission" "${task_log_path}"/xalarm.log
        CHECK_RESULT $? 0 0
        grep "socket file ${run_report} permission .* set not properly, recover as default permission" "${task_log_path}"/xalarm.log
        CHECK_RESULT $? 0 0

        chmod 700 "${xalarm_run_dir}"
        check_RA_xalarmd_log
        grep "${xalarm_run_dir} permission set not properly, recover as default permission" "${task_log_path}"/xalarm.log
        CHECK_RESULT $? 0 0

        rm -rf "${xalarm_run_dir}"
        check_RA_xalarmd_log
        grep "xalarmd run dir not exists, create ${xalarm_run_dir}" "${task_log_path}"/xalarm.log
        CHECK_RESULT $? 0 0

        kill -9 "$(pgrep -f /usr/bin/xalarmd)"
        check_RA_xalarmd_log
        grep "xalarm daemon init success" "${task_log_path}"/xalarm.log 
        CHECK_RESULT $? 0 0
    fi

   

}
function post_test(){
    clean_sysSentry_message
    systemctl stop xalarmd
}

main "$@"