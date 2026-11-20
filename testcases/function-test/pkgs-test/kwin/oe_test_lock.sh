
#!/usr/bin/bash
# 测试 kwin_wayland 会拒绝不存在的 --lock 选项
#
# 说明：kwin 6.8.2 的 kwin_wayland 没有 --lock 选项（--help-all 中相邻的选项是
# --lockscreen / --no-lockscreen，已由 oe_test_lockscreen.sh、oe_test_no_lockscreen.sh
# 覆盖）。原用例把 --lock 当成合法选项并断言退出码为 0，实际上 kwin 会直接打印
# "kwin: Unknown option 'lock'." 并以非 0 退出，用例必然失败。
# 这里保留用例名与用例数量，改为断言“未知选项必须被拒绝、合法选项必须被接受”，
# 是一条有效且不会假通过的回归用例。

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

    # --lock 不存在：单独使用必须被拒绝
    kwin_wayland --lock
    CHECK_RESULT $? 1 0 "kwin_wayland --lock should be rejected"

    # --lock 与合法选项组合，仍必须被拒绝
    kwin_wayland --lock --width 1280 --height 720
    CHECK_RESULT $? 1 0 "kwin_wayland --lock --width 1280 --height 720 should be rejected"

    kwin_wayland --lock --drm
    CHECK_RESULT $? 1 0 "kwin_wayland --lock --drm should be rejected"

    kwin_wayland --lock --no-lockscreen
    CHECK_RESULT $? 1 0 "kwin_wayland --lock --no-lockscreen should be rejected"

    kwin_wayland --lock --no-global-shortcuts
    CHECK_RESULT $? 1 0 "kwin_wayland --lock --no-global-shortcuts should be rejected"

    kwin_wayland --lock --no-kactivities
    CHECK_RESULT $? 1 0 "kwin_wayland --lock --no-kactivities should be rejected"

    # 对照组：真实存在的 --lockscreen 必须被接受
    kwin_wayland --lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --lockscreen should be accepted"

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
