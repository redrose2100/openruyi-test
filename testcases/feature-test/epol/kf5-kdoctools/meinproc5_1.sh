
#!/usr/bin/bash
# 本测试脚本用于测试meinproc5命令，包括其各种参数组合和基本功能。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-kdoctools"
    # 准备测试数据
    echo "<doc><title>Test Document</title><para>This is a test document.</para></doc>" > ./test.xml
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    meinproc5 --help
    CHECK_RESULT $? 0 0 "Failed to display help information"
    
    # 测试版本信息
    meinproc5 --version
    CHECK_RESULT $? 0 0 "Failed to display version information"
    
    # 测试输出到stdout
    meinproc5 --stdout ./test.xml
    CHECK_RESULT $? 0 0 "Failed to output to stdout"
    
    # 测试输出到文件
    meinproc5 -o ./output.html ./test.xml
    CHECK_RESULT $? 0 0 "Failed to output to file"
    
    # 测试检查文档有效性
    meinproc5 --check ./test.xml
    CHECK_RESULT $? 1 0 "Failed to check document validity"
    
    # 测试创建缓存文件
    meinproc5 --cache ./cache.cache ./test.xml
    CHECK_RESULT $? 0 0 "Failed to create cache file"
    
    # 测试设置srcdir
    meinproc5 --srcdir ./srcdir ./test.xml
    CHECK_RESULT $? 1 0 "Failed to set srcdir"
    
    # 测试传递参数到样式表
    meinproc5 --param key=value ./test.xml
    CHECK_RESULT $? 0 0 "Failed to pass parameters to stylesheet"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "kf5-kdoctools"
    # 清理测试中间产物文件
    rm -f ./test.xml ./output.html ./cache.cache
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
