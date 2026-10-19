
#!/usr/bin/bash
# 测试kiran-screensaver-command命令的各个参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kiran-screensaver"
    LOG_INFO "End of environmental preparation!"
}
# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --query 参数
    kiran-screensaver-command --query
    CHECK_RESULT $? 0 0 "failed to query the state of the screensaver"

    # 测试 --time 参数
    kiran-screensaver-command --time
    CHECK_RESULT $? 0 0 "failed to query the length of time the screensaver has been active"

    # 测试 --lock 参数
    kiran-screensaver-command --lock
    CHECK_RESULT $? 0 0 "failed to lock the screen immediately"

    # 测试 --unlock 参数
    kiran-screensaver-command --unlock
    CHECK_RESULT $? 0 0 "failed to unlock the screen immediately"

    # 测试 --activate 参数
    kiran-screensaver-command --activate
    CHECK_RESULT $? 0 0 "failed to turn the screensaver on"

    # 测试 --deactivate 参数
    kiran-screensaver-command --deactivate
    CHECK_RESULT $? 0 0 "failed to deactivate the screensaver"

    # 测试 --inhibit 参数
    kiran-screensaver-command --inhibit
    CHECK_RESULT $? 0 0 "failed to inhibit the screensaver from activating"

    # 测试 --application-name 参数
    kiran-screensaver-command --inhibit --application-name "test_app"
    CHECK_RESULT $? 0 0 "failed to inhibit the screensaver with application name"

    # 测试 --reason 参数
    kiran-screensaver-command --inhibit --reason "testing"
    CHECK_RESULT $? 0 0 "failed to inhibit the screensaver with reason"

    # 测试 --help 参数
    kiran-screensaver-command --help
    CHECK_RESULT $? 0 0 "failed to display help on commandline options"

    # 测试 --help-all 参数
    kiran-screensaver-command --help-all
    CHECK_RESULT $? 0 0 "failed to display help including Qt specific options"

    LOG_INFO "End of the test."
}
# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kiran-screensaver"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
