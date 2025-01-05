
#!/usr/bin/bash
# 测试dde-dconfig-daemon命令的基本选项和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "dde-app-services"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_prefix
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本选项
    dde-dconfig-daemon -h
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -h failed"
    
    dde-dconfig-daemon --help
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon --help failed"
    
    dde-dconfig-daemon --help-all
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon --help-all failed"
    
    # 测试命令的参数组合
    dde-dconfig-daemon -t 5
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -t 5 failed"
    
    dde-dconfig-daemon -p ./test_prefix
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -p ./test_prefix failed"
    
    dde-dconfig-daemon -e 1
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -e 1 failed"
    
    # 测试命令的参数顺序
    dde-dconfig-daemon -t 5 -p ./test_prefix -e 1
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -t 5 -p ./test_prefix -e 1 failed"
    
    dde-dconfig-daemon -p ./test_prefix -t 5 -e 1
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -p ./test_prefix -t 5 -e 1 failed"
    
    dde-dconfig-daemon -e 1 -t 5 -p ./test_prefix
    CHECK_RESULT $? 0 0 "dde-dconfig-daemon -e 1 -t 5 -p ./test_prefix failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "dde-app-services"
    # 清理测试中间产物文件
    rm -rf ./test_prefix
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
