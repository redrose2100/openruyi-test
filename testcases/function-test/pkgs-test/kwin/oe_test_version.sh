
#!/usr/bin/bash
# 请填写测试用例描述：测试kwin_wayland命令的--version参数

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
    # 测试--version参数
    kwin_wayland --version
    CHECK_RESULT $? 0 0 "kwin_wayland --version failed"
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
