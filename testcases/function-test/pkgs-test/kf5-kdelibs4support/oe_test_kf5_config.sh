
#!/usr/bin/bash
# 本测试脚本用于测试kf5-config命令的各种参数组合

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
    kf5-config --help
    CHECK_RESULT $? 0 0 "kf5-config --help failed"

    # 测试 --help-qt 参数
    kf5-config --help-qt
    CHECK_RESULT $? 0 0 "kf5-config --help-qt failed"

    # 测试 --help-kde 参数
    kf5-config --help-kde
    CHECK_RESULT $? 0 0 "kf5-config --help-kde failed"

    # 测试 --help-all 参数
    kf5-config --help-all
    CHECK_RESULT $? 0 0 "kf5-config --help-all failed"

    # 测试 --author 参数
    kf5-config --author
    CHECK_RESULT $? 0 0 "kf5-config --author failed"

    # 测试 --version 参数
    kf5-config --version
    CHECK_RESULT $? 0 0 "kf5-config --version failed"

    # 测试 --license 参数
    kf5-config --license
    CHECK_RESULT $? 0 0 "kf5-config --license failed"

    # 测试 --prefix 参数
    kf5-config --prefix
    CHECK_RESULT $? 0 0 "kf5-config --prefix failed"

    # 测试 --exec-prefix 参数
    kf5-config --exec-prefix
    CHECK_RESULT $? 0 0 "kf5-config --exec-prefix failed"

    # 测试 --libsuffix 参数
    kf5-config --libsuffix
    CHECK_RESULT $? 0 0 "kf5-config --libsuffix failed"

    # 测试 --kde-version 参数
    kf5-config --kde-version
    CHECK_RESULT $? 0 0 "kf5-config --kde-version failed"

    # 测试 --types 参数
    kf5-config --types
    CHECK_RESULT $? 0 0 "kf5-config --types failed"

    # 测试 --path 参数
    kf5-config --path services
    CHECK_RESULT $? 0 0 "kf5-config --path services failed"

    # 测试 --userpath 参数
    kf5-config --userpath desktop
    CHECK_RESULT $? 0 0 "kf5-config --userpath desktop failed"

    # 测试 --install 参数
    kf5-config --install services
    CHECK_RESULT $? 0 0 "kf5-config --install services failed"

    # 测试 --qt-prefix 参数
    kf5-config --qt-prefix
    CHECK_RESULT $? 0 0 "kf5-config --qt-prefix failed"

    # 测试 --qt-binaries 参数
    kf5-config --qt-binaries
    CHECK_RESULT $? 0 0 "kf5-config --qt-binaries failed"

    # 测试 --qt-libraries 参数
    kf5-config --qt-libraries
    CHECK_RESULT $? 0 0 "kf5-config --qt-libraries failed"

    # 测试 --qt-plugins 参数
    kf5-config --qt-plugins
    CHECK_RESULT $? 0 0 "kf5-config --qt-plugins failed"

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
