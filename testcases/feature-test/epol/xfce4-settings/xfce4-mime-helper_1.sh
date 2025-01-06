
#!/usr/bin/bash
# 本测试用例用于测试xfce4-mime-helper命令的各种参数组合和参数顺序

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-settings"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的参数组合和参数顺序
    xfce4-mime-helper -V
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -V failed"

    xfce4-mime-helper --version
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --version failed"

    xfce4-mime-helper -h
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -h failed"

    xfce4-mime-helper --help
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --help failed"

    xfce4-mime-helper --help-all
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --help-all failed"

    xfce4-mime-helper --help-gtk
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --help-gtk failed"

    xfce4-mime-helper -l WebBrowser
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -l WebBrowser failed"

    xfce4-mime-helper --launch WebBrowser
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --launch WebBrowser failed"

    xfce4-mime-helper -q MailReader
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -q MailReader failed"

    xfce4-mime-helper --query MailReader
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --query MailReader failed"

    xfce4-mime-helper -l FileManager
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -l FileManager failed"

    xfce4-mime-helper --launch FileManager
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --launch FileManager failed"

    xfce4-mime-helper -q TerminalEmulator
    CHECK_RESULT $? 0 0 "xfce4-mime-helper -q TerminalEmulator failed"

    xfce4-mime-helper --query TerminalEmulator
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --query TerminalEmulator failed"

    xfce4-mime-helper --display=:0.0 -l WebBrowser
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --display=:0.0 -l WebBrowser failed"

    xfce4-mime-helper --display=:0.0 --launch WebBrowser
    CHECK_RESULT $? 0 0 "xfce4-mime-helper --display=:0.0 --launch WebBrowser failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-settings"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
