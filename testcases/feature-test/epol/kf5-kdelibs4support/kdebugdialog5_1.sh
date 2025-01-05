
#!/usr/bin/bash
# 测试用例描述：测试kdebugdialog5命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-kdelibs4support"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    kdebugdialog5 --help
    CHECK_RESULT $? 0 0 "kdebugdialog5 --help failed"

    # 测试 --help-qt 参数
    kdebugdialog5 --help-qt
    CHECK_RESULT $? 0 0 "kdebugdialog5 --help-qt failed"

    # 测试 --help-kde 参数
    kdebugdialog5 --help-kde
    CHECK_RESULT $? 0 0 "kdebugdialog5 --help-kde failed"

    # 测试 --help-all 参数
    kdebugdialog5 --help-all
    CHECK_RESULT $? 0 0 "kdebugdialog5 --help-all failed"

    # 测试 --author 参数
    kdebugdialog5 --author
    CHECK_RESULT $? 0 0 "kdebugdialog5 --author failed"

    # 测试 --version 参数
    kdebugdialog5 --version
    CHECK_RESULT $? 0 0 "kdebugdialog5 --version failed"

    # 测试 --license 参数
    kdebugdialog5 --license
    CHECK_RESULT $? 0 0 "kdebugdialog5 --license failed"

    # 测试 --fullmode 参数
    kdebugdialog5 --fullmode
    CHECK_RESULT $? 0 0 "kdebugdialog5 --fullmode failed"

    # 测试 --on 参数
    kdebugdialog5 --on "area1"
    CHECK_RESULT $? 0 0 "kdebugdialog5 --on failed"

    # 测试 --off 参数
    kdebugdialog5 --off "area1"
    CHECK_RESULT $? 0 0 "kdebugdialog5 --off failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-kdelibs4support"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
