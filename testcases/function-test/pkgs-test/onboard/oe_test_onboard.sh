
#!/usr/bin/bash
# 测试用例描述：测试onboard命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "onboard"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    touch ./test_layout.onboard
    touch ./test_theme.theme
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本命令
    onboard -h
    CHECK_RESULT $? 0 0 "onboard -h failed"

    # 测试布局文件参数
    onboard -l ./test_layout.onboard
    CHECK_RESULT $? 0 0 "onboard -l ./test_layout.onboard failed"

    # 测试主题文件参数
    onboard -t ./test_theme.theme
    CHECK_RESULT $? 0 0 "onboard -t ./test_theme.theme failed"

    # 测试窗口大小参数
    onboard -s 800x600
    CHECK_RESULT $? 0 0 "onboard -s 800x600 failed"

    # 测试窗口位置参数
    onboard -x 100 -y 200
    CHECK_RESULT $? 0 0 "onboard -x 100 -y 200 failed"

    # 测试高级选项参数
    onboard -m
    CHECK_RESULT $? 0 0 "onboard -m failed"

    # 测试启动延迟参数
    onboard -D 2.0
    CHECK_RESULT $? 0 0 "onboard -D 2.0 failed"

    # 测试调试选项参数
    onboard -d all
    CHECK_RESULT $? 0 0 "onboard -d all failed"

    # 测试组合参数
    onboard -l ./test_layout.onboard -t ./test_theme.theme -s 800x600 -x 100 -y 200 -m -D 2.0 -d all
    CHECK_RESULT $? 0 0 "onboard -l ./test_layout.onboard -t ./test_theme.theme -s 800x600 -x 100 -y 200 -m -D 2.0 -d all failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "onboard"
    # 清理测试中间产物文件
    rm -f ./test_layout.onboard ./test_theme.theme
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
