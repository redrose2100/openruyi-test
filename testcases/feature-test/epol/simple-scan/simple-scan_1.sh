
#!/usr/bin/bash
# 测试simple-scan命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "simple-scan"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch "./test.pdf"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    simple-scan --help
    CHECK_RESULT $? 0 0 "simple-scan --help failed"
    simple-scan --help-all
    CHECK_RESULT $? 0 0 "simple-scan --help-all failed"
    simple-scan --help-gtk
    CHECK_RESULT $? 0 0 "simple-scan --help-gtk failed"

    # 测试版本选项
    simple-scan --version
    CHECK_RESULT $? 0 0 "simple-scan --version failed"

    # 测试调试选项
    simple-scan --debug
    CHECK_RESULT $? 0 0 "simple-scan --debug failed"

    # 测试修复PDF文件选项
    simple-scan --fix-pdf=./test.pdf
    CHECK_RESULT $? 0 0 "simple-scan --fix-pdf=./test.pdf failed"

    # 测试显示选项
    simple-scan --display=:0
    CHECK_RESULT $? 0 0 "simple-scan --display=:0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "simple-scan"
    # 清理测试中间产物文件
    rm -f "./test.pdf"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
