
#!/usr/bin/bash
# 测试用例描述：测试 qtxdg-mat def-file-manager 命令的参数功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "libqtxdg"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    qtxdg-mat --help
    CHECK_RESULT $? 0 0 "Failed to display help information"
    
    # 测试版本信息
    qtxdg-mat --version
    CHECK_RESULT $? 0 0 "Failed to display version information"
    
    # 测试列出可用的文件管理器
    qtxdg-mat def-file-manager -l
    CHECK_RESULT $? 0 0 "Failed to list available file managers"
    
    # 测试设置默认文件管理器
    qtxdg-mat def-file-manager -s "thunar"
    CHECK_RESULT $? 0 0 "Failed to set default file manager"
    
    # 测试获取默认文件管理器
    qtxdg-mat def-file-manager
    CHECK_RESULT $? 0 0 "Failed to get default file manager"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "libqtxdg"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
