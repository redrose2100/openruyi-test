
#!/usr/bin/bash
# 测试 marco-message enable-keybindings 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "marco"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 marco-message enable-keybindings 命令
    marco-message enable-keybindings
    CHECK_RESULT $? 0 0 "marco-message enable-keybindings failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "marco"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
