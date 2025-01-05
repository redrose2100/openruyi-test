
#!/usr/bin/bash
# 测试用例描述：测试 startdde 命令的 -no-xsession-scripts 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "startdde"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 startdde 命令的 -no-xsession-scripts 参数
    startdde -no-xsession-scripts
    CHECK_RESULT $? 0 0 "startdde -no-xsession-scripts failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "startdde"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
