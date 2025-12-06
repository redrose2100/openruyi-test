source "./comm/lib.sh"
set -x

function pre_test(){
    pre_env
}
function run_test(){
    sentryctl set sentry_remote_reporter --cna "${node1_cna}" --eid "${node1_eid1}" --panic=on --kernel_reboot=on
    SSH_CMD "sentryctl set sentry_remote_reporter --cna=${node2_cna} --eid=${node2_eid1} --panic=on --kernel_reboot=on " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    sentryctl set sentry_urma_comm --server_eid="${node1_eid1},${node2_eid1}" --client_jetty_id="${test_jetty_id}"
    SSH_CMD "sentryctl set sentry_urma_comm --server_eid='${node2_eid1},${node1_eid1}' --client_jetty_id=${test_jetty_id}" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    sentryctl set sentry_uvb_comm --server_cna="${node2_cna}"
    SSH_CMD "sentryctl set sentry_uvb_comm --server_cna='${node1_cna}'"  "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    start_RA panic 0 0
    SSH_CMD "echo c > /proc/sysrq-trigger" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"

    check_log 0 RA 1007 1008
    check_log 0 alarmd 1007 1008
    check_log 0 monitor 1007 1008
 
}
function post_test(){
    clean_sysSentry_message
    DNF_REMOVE "sysSentry" 1
    DNF_REMOVE "sysSentry" 2
}

main "$@"