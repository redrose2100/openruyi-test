
#!/usr/bin/bash
# 本测试脚本用于测试xfce4-screensaver-command命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-screensaver"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    xfce4-screensaver-command --help
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --help failed"

    # 测试 --version 参数
    xfce4-screensaver-command --version
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --version failed"

    # 测试 --query 参数
    xfce4-screensaver-command --query
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --query failed"

    # 测试 --time 参数
    xfce4-screensaver-command --time
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --time failed"

    # 测试 --lock 参数
    xfce4-screensaver-command --lock
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --lock failed"

    # 测试 --cycle 参数
    xfce4-screensaver-command --cycle
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --cycle failed"

    # 测试 --activate 参数
    xfce4-screensaver-command --activate
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --activate failed"

    # 测试 --deactivate 参数
    xfce4-screensaver-command --deactivate
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --deactivate failed"

    # 测试 --poke 参数
    xfce4-screensaver-command --poke
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --poke failed"

    # 测试 --inhibit 参数
    xfce4-screensaver-command --inhibit
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --inhibit failed"

    # 测试 --application-name 参数
    xfce4-screensaver-command --inhibit --application-name "TestApp"
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --inhibit --application-name failed"

    # 测试 --reason 参数
    xfce4-screensaver-command --inhibit --reason "Testing"
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --inhibit --reason failed"

    # 测试 --exit 参数
    xfce4-screensaver-command --exit
    CHECK_RESULT $? 0 0 "xfce4-screensaver-command --exit failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-screensaver"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
