
#!/usr/bin/bash
# 本测试用例用于测试 mate-about 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-desktop"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    mate-about --help
    CHECK_RESULT $? 0 0 "mate-about --help failed"

    # 测试 --help-all 参数
    mate-about --help-all
    CHECK_RESULT $? 0 0 "mate-about --help-all failed"

    # 测试 --help-gtk 参数
    mate-about --help-gtk
    CHECK_RESULT $? 0 0 "mate-about --help-gtk failed"

    # 测试 --version 参数
    mate-about --version
    CHECK_RESULT $? 0 0 "mate-about --version failed"

    # 测试 --display 参数
    mate-about --display=:0
    CHECK_RESULT $? 0 0 "mate-about --display=:0 failed"

    # 测试多个参数组合
    mate-about --help --version
    CHECK_RESULT $? 0 0 "mate-about --help --version failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-desktop"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
