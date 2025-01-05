
#!/usr/bin/bash
# 测试 mate-terminal 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-terminal"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test_config_file.conf"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 help 选项
    mate-terminal --help
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --help"
    
    # 测试 --help-all 选项
    mate-terminal --help-all
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --help-all"
    
    # 测试 --disable-factory 选项
    mate-terminal --disable-factory --display=:0
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --disable-factory --display=:0"
    
    # 测试 --load-config 选项
    mate-terminal --load-config=./test_config_file.conf --display=:0
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --load-config=./test_config_file.conf --display=:0"
    
    # 测试 --save-config 选项
    mate-terminal --save-config=./test_config_file.conf --display=:0
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --save-config=./test_config_file.conf --display=:0"
    
    # 测试 --display 选项
    mate-terminal --display=:0
    CHECK_RESULT $? 0 0 "failed to run mate-terminal --display=:0"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "mate-terminal"
    # 清理测试中间产物文件
    rm -f "./test_config_file.conf"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
