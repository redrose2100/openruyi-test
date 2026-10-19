
#!/usr/bin/bash
# 请填写测试用例描述：测试 mate-disk-usage-analyzer 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_directory
    touch ./test_directory/test_file.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本功能
    mate-disk-usage-analyzer ./test_directory
    CHECK_RESULT $? 0 0 "mate-disk-usage-analyzer failed to run on directory"
    
    # 测试 --help 参数
    mate-disk-usage-analyzer --help
    CHECK_RESULT $? 0 0 "mate-disk-usage-analyzer --help failed"
    
    # 测试 --version 参数
    mate-disk-usage-analyzer --version
    CHECK_RESULT $? 0 0 "mate-disk-usage-analyzer --version failed"
    
    # 测试 --display 参数
    mate-disk-usage-analyzer --display=:0.0 ./test_directory
    CHECK_RESULT $? 0 0 "mate-disk-usage-analyzer --display=:0.0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -rf ./test_directory
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
