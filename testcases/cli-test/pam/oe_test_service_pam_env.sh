
source ${OET_PATH}/libs/locallibs/common_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {  
    cmd="test -e /tmp/a && rm -rf /tmp/a; \
       cp -f /etc/security/pam_env.conf /etc/security/pam_env.conf_bak; \
      echo HOME DEFAULT=\${HOME} OVERRIDE=/var/>/etc/security/pam_env.conf"
    
    SSH_CMD "$cmd" 127.0.0.1  hj814 root 20 22    

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    SSH_CMD "echo \$HOME>/tmp/a" 127.0.0.1  hj814 root 20 22
    CHECK_RESULT $?
    SSH_SCP root@127.0.0.1:/tmp/a /tmp/a hj814 
    CHECK_RESULT $?
    tmpa=`cat /tmp/a`
    CHECK_RESULT "$tmpa"  "/var/"
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {

    mv /etc/security/pam_env.conf_bak /etc/security/pam_env.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
