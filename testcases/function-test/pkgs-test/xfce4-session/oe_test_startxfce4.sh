
#!/usr/bin/bash
# 请填写测试用例描述：测试xfce4-session的启动选项

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-session"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令 --help 选项
    startxfce4 --help
    CHECK_RESULT $? 0 0 "startxfce4 --help failed"

    # 测试命令 --with-ck-launch 选项
    startxfce4 --with-ck-launch
    CHECK_RESULT $? 0 0 "startxfce4 --with-ck-launch failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-session"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
