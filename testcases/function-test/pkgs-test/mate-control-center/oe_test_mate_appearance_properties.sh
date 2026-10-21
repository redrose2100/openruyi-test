
#!/usr/bin/bash
# 本测试用例用于测试 mate-appearance-properties 命令的基本功能，包括显示帮助信息、安装主题、显示特定页面等功能。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    # 准备测试数据
    touch ./test-theme.tar.gz
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试显示帮助信息
    mate-appearance-properties --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试显示所有帮助信息
    mate-appearance-properties --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    # 测试显示GTK+选项
    mate-appearance-properties --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试安装主题
    mate-appearance-properties -i ./test-theme.tar.gz
    CHECK_RESULT $? 0 0 "Failed to install theme"
    
    # 测试显示特定页面
    mate-appearance-properties -p theme
    CHECK_RESULT $? 0 0 "Failed to show theme page"
    
    mate-appearance-properties -p background
    CHECK_RESULT $? 0 0 "Failed to show background page"
    
    mate-appearance-properties -p fonts
    CHECK_RESULT $? 0 0 "Failed to show fonts page"
    
    mate-appearance-properties -p interface
    CHECK_RESULT $? 0 0 "Failed to show interface page"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    # 清理测试中间产物文件
    rm -f ./test-theme.tar.gz
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
