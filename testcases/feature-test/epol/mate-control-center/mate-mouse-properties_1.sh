
#!/usr/bin/bash
# 本测试用例用于测试 mate-mouse-properties 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-control-center"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    mate-mouse-properties --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    mate-mouse-properties --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    mate-mouse-properties --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试应用选项
    mate-mouse-properties -p general
    CHECK_RESULT $? 0 0 "Failed to show general page"
    
    mate-mouse-properties --show-page=general
    CHECK_RESULT $? 0 0 "Failed to show general page with --show-page option"
    
    # 测试显示选项
    mate-mouse-properties --display=:0
    CHECK_RESULT $? 0 0 "Failed to use display option"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-control-center"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
