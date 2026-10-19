
#!/usr/bin/bash
# 本测试用例用于测试xfce4-session-logout命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-session"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xfce4-session-logout --help
    CHECK_RESULT $? 0 0 "xfce4-session-logout --help failed"
    
    xfce4-session-logout --help-all
    CHECK_RESULT $? 0 0 "xfce4-session-logout --help-all failed"
    
    xfce4-session-logout --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-session-logout --help-gtk failed"
    
    # 测试应用选项
    xfce4-session-logout --logout
    CHECK_RESULT $? 0 0 "xfce4-session-logout --logout failed"
    
    xfce4-session-logout --halt
    CHECK_RESULT $? 0 0 "xfce4-session-logout --halt failed"
    
    xfce4-session-logout --reboot
    CHECK_RESULT $? 0 0 "xfce4-session-logout --reboot failed"
    
    xfce4-session-logout --suspend
    CHECK_RESULT $? 0 0 "xfce4-session-logout --suspend failed"
    
    xfce4-session-logout --hibernate
    CHECK_RESULT $? 0 0 "xfce4-session-logout --hibernate failed"
    
    xfce4-session-logout --hybrid-sleep
    CHECK_RESULT $? 0 0 "xfce4-session-logout --hybrid-sleep failed"
    
    xfce4-session-logout --switch-user
    CHECK_RESULT $? 0 0 "xfce4-session-logout --switch-user failed"
    
    xfce4-session-logout --fast
    CHECK_RESULT $? 0 0 "xfce4-session-logout --fast failed"
    
    xfce4-session-logout --version
    CHECK_RESULT $? 0 0 "xfce4-session-logout --version failed"
    
    xfce4-session-logout --display=:0
    CHECK_RESULT $? 0 0 "xfce4-session-logout --display=:0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-session"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
