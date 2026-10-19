
#!/usr/bin/bash
# 本测试用例用于测试byzanz命令的基本功能，包括不同参数组合的使用情况。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "byzanz"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    byzanz-record --duration=5 --x=100 --y=100 --width=200 --height=200 ./test1.gif
    CHECK_RESULT $? 0 0 "failed to record with basic parameters"
    
    # 测试带鼠标和音频的命令
    byzanz-record --duration=5 --x=100 --y=100 --width=200 --height=200 --cursor --audio ./test2.gif
    CHECK_RESULT $? 0 0 "failed to record with cursor and audio"
    
    # 测试带延迟的命令
    byzanz-record --duration=5 --delay=2 --x=100 --y=100 --width=200 --height=200 ./test3.gif
    CHECK_RESULT $? 0 0 "failed to record with delay"
    
    # 测试带详细输出的命令
    byzanz-record --duration=5 --x=100 --y=100 --width=200 --height=200 --verbose ./test4.gif
    CHECK_RESULT $? 0 0 "failed to record with verbose output"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "byzanz"
        # 清理测试中间产物文件
        rm -f ./test1.gif ./test2.gif ./test3.gif ./test4.gif
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
