
#!/usr/bin/bash
# 本测试用例用于测试xfce4-session命令的基本功能，包括帮助选项、版本信息和应用选项。

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
    xfce4-session --help
    CHECK_RESULT $? 0 0 "xfce4-session --help failed"
    
    # 测试所有帮助选项
    xfce4-session --help-all
    CHECK_RESULT $? 0 0 "xfce4-session --help-all failed"
    
    # 测试GTK+选项
    xfce4-session --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-session --help-gtk failed"
    
    # 测试版本信息
    xfce4-session --version
    CHECK_RESULT $? 0 0 "xfce4-session --version failed"
    
    # 测试禁用TCP端口绑定
    xfce4-session --disable-tcp
    CHECK_RESULT $? 0 0 "xfce4-session --disable-tcp failed"
    
    # 测试X display选项
    xfce4-session --display=:0
    CHECK_RESULT $? 0 0 "xfce4-session --display=:0 failed"
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
