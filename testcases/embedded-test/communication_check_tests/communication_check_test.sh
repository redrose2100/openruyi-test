source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    chmod 777 dsoftbus_hello
    SSH_SCP dsoftbus_hello root@${NODE2_IPV4}:/ "${NODE2_PASSWORD}"

    echo 123456 > /etc/SN
    SSH_CMD "echo 456789 > /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22

    nohup /usr/bin/softbus_server_main >/log.file 2>&1 &
    SSH_CMD "nohup /usr/bin/softbus_server_main > /log.file 2>&1 &"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
     
    SSH_CMD "nohup /dsoftbus_hello >/dev/null 2>&1 & "  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22

    expect << EOF
    set timeout 10
    spawn ./dsoftbus_hello
    expect "HichainIsDeviceInGroup"
    send "c\r"
    expect "Input Node num to commnunication"
    send "1\r"
    expect "CloseSession ok"
    send "s\r"
EOF
    CHECK_RESULT $? 0 0 "communication failure"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf /etc/SN
    SSH_CMD "rm -rf /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22

    
    ps -ef | grep softbus_server_main |grep -v grep | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps -ef | grep dsoftbus_hello |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22
    SSH_CMD "ps -ef | grep softbus_server_main |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22


    rm -rf /log.file
    SSH_CMD "rm -rf /dsoftbus_hello"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22
    SSH_CMD "rm -rf /log.file"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  root 300 22

    LOG_INFO "End to restore the test environment."
}


main "$@"
