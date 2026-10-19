
#!/usr/bin/bash
# 本测试用例用于测试Thunar命令的基本功能，包括帮助选项、版本信息、退出功能等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "Thunar"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    thunar --help
    CHECK_RESULT $? 0 0 "Thunar --help failed"
    
    # 测试所有帮助选项
    thunar --help-all
    CHECK_RESULT $? 0 0 "Thunar --help-all failed"
    
    # 测试GApplication选项
    thunar --help-gapplication
    CHECK_RESULT $? 0 0 "Thunar --help-gapplication failed"
    
    # 测试GTK+选项
    thunar --help-gtk
    CHECK_RESULT $? 0 0 "Thunar --help-gtk failed"
    
    # 测试版本信息
    thunar --version
    CHECK_RESULT $? 0 0 "Thunar --version failed"
    
    # 测试退出功能
    thunar --quit
    CHECK_RESULT $? 0 0 "Thunar --quit failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "Thunar"
    # 清理测试中间产物文件
    rm -rf ./testfile*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
