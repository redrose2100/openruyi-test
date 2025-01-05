
#!/usr/bin/bash
# 本测试用例用于测试 baobab 命令的基本功能，包括帮助选项、版本信息以及目录参数。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "baobab"
    # 准备测试数据
    mkdir -p ./test_directory
    touch ./test_directory/test_file
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    baobab --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试所有帮助选项
    baobab --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    # 测试版本信息
    baobab --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试目录参数
    baobab ./test_directory
    CHECK_RESULT $? 0 0 "Failed to scan specified directory"
    
    # 测试所有文件系统选项
    baobab -a
    CHECK_RESULT $? 0 0 "Failed to scan all file systems"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "baobab"
    # 清理测试中间产物文件
    rm -rf ./test_directory
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
