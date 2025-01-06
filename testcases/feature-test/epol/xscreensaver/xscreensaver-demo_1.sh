
#!/usr/bin/bash
# 本测试用例用于测试xscreensaver-demo命令的基本功能，包括帮助选项、版本信息和调试信息。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xscreensaver"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    xscreensaver-demo --help
    CHECK_RESULT $? 0 0 "xscreensaver-demo --help failed"
    
    # 测试所有帮助选项
    xscreensaver-demo --help-all
    CHECK_RESULT $? 0 0 "xscreensaver-demo --help-all failed"
    
    # 测试GApplication选项
    xscreensaver-demo --help-gapplication
    CHECK_RESULT $? 0 0 "xscreensaver-demo --help-gapplication failed"
    
    # 测试GTK+选项
    xscreensaver-demo --help-gtk
    CHECK_RESULT $? 0 0 "xscreensaver-demo --help-gtk failed"
    
    # 测试版本信息
    xscreensaver-demo --version
    CHECK_RESULT $? 0 0 "xscreensaver-demo --version failed"
    
    # 测试调试信息
    xscreensaver-demo --debug
    CHECK_RESULT $? 0 0 "xscreensaver-demo --debug failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xscreensaver"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
