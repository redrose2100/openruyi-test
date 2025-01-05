
#!/usr/bin/bash
# 本测试用例用于测试xfce4-appfinder命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-appfinder"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --help 参数
    xfrun4 --help
    CHECK_RESULT $? 0 0 "xfrun4 --help failed"

    # 测试 --help-all 参数
    xfrun4 --help-all
    CHECK_RESULT $? 0 0 "xfrun4 --help-all failed"

    # 测试 --help-gtk 参数
    xfrun4 --help-gtk
    CHECK_RESULT $? 0 0 "xfrun4 --help-gtk failed"

    # 测试 --collapsed 参数
    xfrun4 --collapsed
    CHECK_RESULT $? 0 0 "xfrun4 --collapsed failed"

    # 测试 --version 参数
    xfrun4 --version
    CHECK_RESULT $? 0 0 "xfrun4 --version failed"

    # 测试 --replace 参数
    xfrun4 --replace
    CHECK_RESULT $? 0 0 "xfrun4 --replace failed"

    # 测试 --quit 参数
    xfrun4 --quit
    CHECK_RESULT $? 0 0 "xfrun4 --quit failed"

    # 测试 --disable-server 参数
    xfrun4 --disable-server
    CHECK_RESULT $? 0 0 "xfrun4 --disable-server failed"

    # 测试 --display 参数
    xfrun4 --display=:0
    CHECK_RESULT $? 0 0 "xfrun4 --display=:0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-appfinder"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
