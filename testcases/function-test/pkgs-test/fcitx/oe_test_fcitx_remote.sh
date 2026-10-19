
#!/usr/bin/bash
# 测试用例描述：测试 fcitx-remote 命令在不带参数时的行为，预期输出为 fcitx 的状态（0 表示关闭，1 表示非激活，2 表示激活）

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 fcitx-remote 命令在不带参数时的行为
    fcitx-remote
    CHECK_RESULT $? 0 0 "fcitx-remote command failed"
    # 检查输出是否为预期的状态值（0, 1, 或 2）
    fcitx_state=$(fcitx-remote)
    if [[ "$fcitx_state" =~ ^[012]$ ]]; then
        LOG_INFO "fcitx-remote output is valid: $fcitx_state"
    else
        LOG_INFO "fcitx-remote output is invalid: $fcitx_state"
        CHECK_RESULT 1 0 0 "fcitx-remote output is not 0, 1, or 2"
    fi
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "fcitx"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
