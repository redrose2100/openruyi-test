
#!/usr/bin/bash
# 本测试用例用于测试gnome-logs命令的基本功能，包括帮助选项和版本信息。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-logs"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    gnome-logs --help
    CHECK_RESULT $? 0 0 "gnome-logs --help failed"
    
    gnome-logs --help-all
    CHECK_RESULT $? 0 0 "gnome-logs --help-all failed"
    
    gnome-logs --help-gapplication
    CHECK_RESULT $? 0 0 "gnome-logs --help-gapplication failed"
    
    gnome-logs --help-gtk
    CHECK_RESULT $? 0 0 "gnome-logs --help-gtk failed"
    
    # 测试版本信息
    gnome-logs --version
    CHECK_RESULT $? 0 0 "gnome-logs --version failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnome-logs"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
