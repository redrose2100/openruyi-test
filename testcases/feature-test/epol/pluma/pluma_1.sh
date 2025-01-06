
#!/usr/bin/bash
# 测试 pluma 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "pluma"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./testfile.txt"
    # 设置 DISPLAY 环境变量
    export DISPLAY=:0.0
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本功能
    pluma "./testfile.txt"
    CHECK_RESULT $? 0 0 "Failed to open file with pluma"
    
    # 测试 --version 参数
    pluma --version
    CHECK_RESULT $? 0 0 "Failed to show version with --version"
    
    # 测试 --encoding 参数
    pluma --encoding=utf-8 "./testfile.txt"
    CHECK_RESULT $? 0 0 "Failed to open file with specified encoding"
    
    # 测试 --list-encodings 参数
    pluma --list-encodings
    CHECK_RESULT $? 0 0 "Failed to list encodings with --list-encodings"
    
    # 测试 --new-window 参数
    pluma --new-window "./testfile.txt"
    CHECK_RESULT $? 0 0 "Failed to open new window with --new-window"
    
    # 测试 --new-document 参数
    pluma --new-document
    CHECK_RESULT $? 0 0 "Failed to create new document with --new-document"
    
    # 测试 --display 参数
    pluma --display=:0.0 "./testfile.txt"
    CHECK_RESULT $? 0 0 "Failed to open file with specified display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "pluma"
    # 清理测试中间产物文件
    rm -f "./testfile.txt"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
