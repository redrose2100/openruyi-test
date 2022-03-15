
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {  
    cmd="useradd xtest>/tmp/null 2>&1; echo xtest:hj814| chpasswd;   cp /etc/security/time.conf /etc/security/time.conf_bak; cp /etc/pam.d/login /etc/pam.d/login_bak;" 
    SSH_CMD "$cmd" 127.0.0.1  hj814 root 20 22    
    cmd="echo login\\\;tty\\\* \\\& \\\!ttyp\\\*\\\;\\\!root\\\;\\\!A0000-2400 >>/etc/security/time.conf;
        echo account requisite pam_time.so >>/etc/pam.d/login "
    echo $cmd
    SSH_CMD "$cmd" 127.0.0.1  hj814 root 20 22    

    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    SSH_CMD "echo hhhh"  127.0.0.1  hj814 xtest 20 22
    varflag="1"
    if [ "$?" == "0" ]; then
        varflag="0"
    fi
    CHECK_RESULT $? "1"
    LOG_INFO "End to run test."
}
function post_test() {

    #mv /etc/pam.d/login_bak /etc/pam.d/login;  
    LOG_INFO "End to restore the test environment."
}

main "$@"
