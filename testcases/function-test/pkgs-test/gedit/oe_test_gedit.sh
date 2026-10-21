
#!/usr/bin/bash
# 本测试用例用于测试 gedit 命令的基本功能，包括打开文件、指定编码、创建新窗口和文档等。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gedit"
    # 准备测试数据
    echo "Test content" > ./testfile.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试打开文件
    gedit ./testfile.txt
    CHECK_RESULT $? 0 0 "Failed to open file with gedit"
    
    # 测试指定编码
    gedit --encoding=utf-8 ./testfile.txt
    CHECK_RESULT $? 0 0 "Failed to open file with specified encoding"
    
    # 测试创建新窗口
    gedit --new-window ./testfile.txt
    CHECK_RESULT $? 0 0 "Failed to create new window"
    
    # 测试创建新文档
    gedit --new-document
    CHECK_RESULT $? 0 0 "Failed to create new document"
    
    # 测试等待文件关闭
    gedit --wait ./testfile.txt
    CHECK_RESULT $? 0 0 "Failed to wait for file to close"
    
    # 测试独立模式
    gedit --standalone ./testfile.txt
    CHECK_RESULT $? 0 0 "Failed to run in standalone mode"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "gedit"
    # 清理测试中间产物文件
    rm -f ./testfile.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
