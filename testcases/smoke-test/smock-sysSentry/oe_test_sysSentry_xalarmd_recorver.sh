#!/bin/bash
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

function check_xalarmd_log() {
    grep "${run_alarm} not found or socket file been replaced, recovering" "${task_log_path}"/xalarm.log
    CHECK_RESULT $? 0 0
    grep "${run_report} not found or socket file been replaced, recovering" "${task_log_path}"/xalarm.log
    CHECK_RESULT $? 0 0
    grep "${run_alarm} has been created" "${task_log_path}"/xalarm.log
    CHECK_RESULT $? 0 0
    grep "${run_report} has been created" "${task_log_path}"/xalarm.log
    CHECK_RESULT $? 0 0

}
function pre_test(){
    pre_xalarm_env
}
function run_test(){
   check_RA_xalarmd_log
   clean_sysSentry_message

   rm -rf "${run_alarm}"
   rm -rf "${run_report}"
   check_RA_xalarmd_log
   check_xalarmd_log

   clean_sysSentry_message
    rm -rf "${run_alarm}" && touch "${run_alarm}"
    rm -rf "${run_report}" && touch "${run_alarm}"
    check_RA_xalarmd_log
    check_xalarmd_log

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

}
function post_test(){
    clean_sysSentry_message
    systemctl stop xalarmd
    # return 0
}

main "$@"