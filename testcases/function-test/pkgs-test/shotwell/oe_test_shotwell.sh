
#!/usr/bin/bash
# 测试用例描述：测试shotwell的基本命令和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "shotwell"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test_image.jpg"
    mkdir -p "./test_data"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    shotwell --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试显示版本信息
    shotwell --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试全屏模式启动
    shotwell --fullscreen
    CHECK_RESULT $? 0 0 "Failed to start in fullscreen mode"
    
    # 测试指定数据目录
    shotwell --datadir=./test_data
    CHECK_RESULT $? 0 0 "Failed to set data directory"
    
    # 测试不显示启动进度条
    shotwell --no-startup-progress
    CHECK_RESULT $? 0 0 "Failed to disable startup progress meter"
    
    # 测试不监控库目录
    shotwell --no-runtime-monitoring
    CHECK_RESULT $? 0 0 "Failed to disable runtime monitoring"
    
    # 测试指定显示
    shotwell --display=:0
    CHECK_RESULT $? 0 0 "Failed to set display"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "shotwell"
    # 清理测试中间产物文件
    rm -f "./test_image.jpg"
    rm -rf "./test_data"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
