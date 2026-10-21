
#!/usr/bin/bash
# 本测试用例用于测试 ukui-screensaver-command 命令的各种选项

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ukui-screensaver"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h, --help 选项
    ukui-screensaver-command -h
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -h failed"
    ukui-screensaver-command --help
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --help failed"

    # 测试 --help-all 选项
    ukui-screensaver-command --help-all
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --help-all failed"

    # 测试 -v, --version 选项
    ukui-screensaver-command -v
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -v failed"
    ukui-screensaver-command --version
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --version failed"

    # 测试 -l, --lock 选项
    ukui-screensaver-command -l
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -l failed"
    ukui-screensaver-command --lock
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --lock failed"

    # 测试 -q, --query 选项
    ukui-screensaver-command -q
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -q failed"
    ukui-screensaver-command --query
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --query failed"

    # 测试 -u, --unlock 选项
    ukui-screensaver-command -u
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -u failed"
    ukui-screensaver-command --unlock
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --unlock failed"

    # 测试 -s, --screensaver 选项
    ukui-screensaver-command -s
    CHECK_RESULT $? 0 0 "ukui-screensaver-command -s failed"
    ukui-screensaver-command --screensaver
    CHECK_RESULT $? 0 0 "ukui-screensaver-command --screensaver failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "ukui-screensaver"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
