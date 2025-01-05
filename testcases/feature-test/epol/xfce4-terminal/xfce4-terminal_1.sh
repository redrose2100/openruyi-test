
#!/usr/bin/bash
# 本测试脚本用于测试xfce4-terminal命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-terminal"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    xfce4-terminal -h
    CHECK_RESULT $? 0 0 "xfce4-terminal -h failed"
    xfce4-terminal --help
    CHECK_RESULT $? 0 0 "xfce4-terminal --help failed"

    # 测试版本信息
    xfce4-terminal -V
    CHECK_RESULT $? 0 0 "xfce4-terminal -V failed"
    xfce4-terminal --version
    CHECK_RESULT $? 0 0 "xfce4-terminal --version failed"

    # 测试新建窗口和标签页
    xfce4-terminal --window
    CHECK_RESULT $? 0 0 "xfce4-terminal --window failed"
    xfce4-terminal --tab
    CHECK_RESULT $? 0 0 "xfce4-terminal --tab failed"

    # 测试执行命令
    xfce4-terminal -x echo "Hello World"
    CHECK_RESULT $? 0 0 "xfce4-terminal -x echo failed"
    xfce4-terminal -e "echo Hello World"
    CHECK_RESULT $? 0 0 "xfce4-terminal -e echo failed"

    # 测试窗口和标签页的标题
    xfce4-terminal -T "Test Title"
    CHECK_RESULT $? 0 0 "xfce4-terminal -T failed"
    xfce4-terminal --title "Test Title"
    CHECK_RESULT $? 0 0 "xfce4-terminal --title failed"

    # 测试窗口的显示选项
    xfce4-terminal --fullscreen
    CHECK_RESULT $? 0 0 "xfce4-terminal --fullscreen failed"
    xfce4-terminal --maximize
    CHECK_RESULT $? 0 0 "xfce4-terminal --maximize failed"
    xfce4-terminal --minimize
    CHECK_RESULT $? 0 0 "xfce4-terminal --minimize failed"
    xfce4-terminal --show-menubar
    CHECK_RESULT $? 0 0 "xfce4-terminal --show-menubar failed"
    xfce4-terminal --hide-menubar
    CHECK_RESULT $? 0 0 "xfce4-terminal --hide-menubar failed"
    xfce4-terminal --show-borders
    CHECK_RESULT $? 0 0 "xfce4-terminal --show-borders failed"
    xfce4-terminal --hide-borders
    CHECK_RESULT $? 0 0 "xfce4-terminal --hide-borders failed"
    xfce4-terminal --show-toolbar
    CHECK_RESULT $? 0 0 "xfce4-terminal --show-toolbar failed"
    xfce4-terminal --hide-toolbar
    CHECK_RESULT $? 0 0 "xfce4-terminal --hide-toolbar failed"
    xfce4-terminal --show-scrollbar
    CHECK_RESULT $? 0 0 "xfce4-terminal --show-scrollbar failed"
    xfce4-terminal --hide-scrollbar
    CHECK_RESULT $? 0 0 "xfce4-terminal --hide-scrollbar failed"

    # 测试字体和缩放
    xfce4-terminal --font "Monospace 12"
    CHECK_RESULT $? 0 0 "xfce4-terminal --font failed"
    xfce4-terminal --zoom 1.5
    CHECK_RESULT $? 0 0 "xfce4-terminal --zoom failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-terminal"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
