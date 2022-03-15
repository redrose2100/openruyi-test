
source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    #cp /etc/security/access.conf  /etc/security/access.conf_pam
    #echo "-:root:127.0.0.1" >/etc/security/access.conf 
    
    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    # 测试命令：ls
 #   ls -CZl -all
 #   CHECK_RESULT 0

    # 测试/目录下是否存在proc|usr|roor|var|sys|etc|boot|dev目录
#    CHECK_RESULT "$(ls / | grep -cE 'proc|usr|roor|var|sys|etc|boot|dev')" 7

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

 #   mv /etc/security/access.conf_pam  /etc/security/access.conf

    LOG_INFO "End to restore the test environment."
}

main "$@"
