
#!/usr/bin/bash
# 本测试用例用于测试xfce4-power-manager命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-power-manager"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-power-manager --help
    CHECK_RESULT $? 0 0 "xfce4-power-manager --help failed"
    
    xfce4-power-manager --help-all
    CHECK_RESULT $? 0 0 "xfce4-power-manager --help-all failed"
    
    xfce4-power-manager --help-sm-client
    CHECK_RESULT $? 0 0 "xfce4-power-manager --help-sm-client failed"
    
    # 测试应用选项
    xfce4-power-manager --daemon
    CHECK_RESULT $? 0 0 "xfce4-power-manager --daemon failed"
    
    xfce4-power-manager --debug
    CHECK_RESULT $? 0 0 "xfce4-power-manager --debug failed"
    
    xfce4-power-manager --dump
    CHECK_RESULT $? 0 0 "xfce4-power-manager --dump failed"
    
    xfce4-power-manager --restart
    CHECK_RESULT $? 0 0 "xfce4-power-manager --restart failed"
    
    xfce4-power-manager -c
    CHECK_RESULT $? 0 0 "xfce4-power-manager -c failed"
    
    xfce4-power-manager --customize
    CHECK_RESULT $? 0 0 "xfce4-power-manager --customize failed"
    
    xfce4-power-manager -q
    CHECK_RESULT $? 0 0 "xfce4-power-manager -q failed"
    
    xfce4-power-manager --quit
    CHECK_RESULT $? 0 0 "xfce4-power-manager --quit failed"
    
    xfce4-power-manager -V
    CHECK_RESULT $? 0 0 "xfce4-power-manager -V failed"
    
    xfce4-power-manager --version
    CHECK_RESULT $? 0 0 "xfce4-power-manager --version failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-power-manager"
    # 清理测试中间产物文件
    rm -rf ./testfile*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
