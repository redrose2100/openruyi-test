
#!/usr/bin/bash
# 测试 kwin_wayland 会拒绝不存在的 --crashes 选项
#
# 说明：kwin 6.8.2 的 kwin_wayland 没有 --crashes 选项（--help-all 中不存在）。
# 原用例断言退出码为 1（CHECK_RESULT $? 1 0），与 "Unknown option" 的返回码恰好
# 相同，属于“意外通过”，并没有真正验证 --crashes 的功能。这里改为显式断言
# “未知选项必须被拒绝”，让用例语义与断言一致。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

source "${OET_PATH}/testcases/function-test/pkgs-test/kwin/common/kwin_common.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kwin"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."

    # --crashes 不存在：各种取值都必须被拒绝（解析阶段即失败，与取值无关）
    kwin_wayland --crashes 1
    CHECK_RESULT $? 1 0 "kwin_wayland --crashes 1 should be rejected"

    kwin_wayland --crashes 0
    CHECK_RESULT $? 1 0 "kwin_wayland --crashes 0 should be rejected"

    kwin_wayland --crashes 5
    CHECK_RESULT $? 1 0 "kwin_wayland --crashes 5 should be rejected"

    kwin_wayland --crashes -1
    CHECK_RESULT $? 1 0 "kwin_wayland --crashes -1 should be rejected"

    kwin_wayland --crashes 100
    CHECK_RESULT $? 1 0 "kwin_wayland --crashes 100 should be rejected"

    # 对照组：真实存在的 --replace 必须被接受
    kwin_wayland --replace
    CHECK_RESULT $? 0 0 "kwin_wayland --replace should be accepted"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 先清理残留合成器与 wayland socket 锁文件，避免污染后续用例
    kwin_wayland_cleanup
    # 卸载安装的软件包
    DNF_REMOVE
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
