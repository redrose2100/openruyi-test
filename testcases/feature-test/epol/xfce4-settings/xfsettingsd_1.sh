
#!/usr/bin/bash
# 本测试用例用于测试xfsettingsd命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-settings"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfsettingsd --help
    CHECK_RESULT $? 0 0 "xfsettingsd --help failed"
    
    # 测试所有帮助选项
    xfsettingsd --help-all
    CHECK_RESULT $? 0 0 "xfsettingsd --help-all failed"
    
    # 测试会话管理选项
    xfsettingsd --help-sm-client
    CHECK_RESULT $? 0 0 "xfsettingsd --help-sm-client failed"
    
    # 测试版本信息
    xfsettingsd --version
    CHECK_RESULT $? 0 0 "xfsettingsd --version failed"
    
    # 测试后台运行选项
    xfsettingsd --daemon
    CHECK_RESULT $? 0 0 "xfsettingsd --daemon failed"
    
    # 测试不等待窗口管理器选项
    xfsettingsd --disable-wm-check
    CHECK_RESULT $? 0 0 "xfsettingsd --disable-wm-check failed"
    
    # 测试替换运行中的xsettings守护进程选项
    xfsettingsd --replace
    CHECK_RESULT $? 0 0 "xfsettingsd --replace failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-settings"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
