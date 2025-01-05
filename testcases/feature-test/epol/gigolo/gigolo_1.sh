
#!/usr/bin/bash
# 本测试用例用于验证gigolo命令的基本功能，包括帮助信息、版本信息、URI schemes列表等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gigolo"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    gigolo --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试所有帮助信息
    gigolo --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    # 测试GTK+选项
    gigolo --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试版本信息
    gigolo --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试URI schemes列表
    gigolo --list-schemes
    CHECK_RESULT $? 0 0 "Failed to list supported URI schemes"
    
    # 测试verbose模式
    gigolo --verbose --display=:0
    CHECK_RESULT $? 0 0 "Failed to run in verbose mode"
    
    # 测试auto-connect选项
    gigolo --auto-connect
    CHECK_RESULT $? 0 0 "Failed to auto-connect bookmarks"
    
    # 测试new-instance选项
    gigolo --new-instance --display=:0
    CHECK_RESULT $? 0 0 "Failed to enforce opening a new instance"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gigolo"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
