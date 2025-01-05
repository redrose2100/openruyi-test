
#!/usr/bin/bash
# 测试用例描述：测试 deepin-pw-check 的 pwd_conf_update 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "deepin-pw-check"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试无参数情况
    pwd_conf_update
    CHECK_RESULT $? 1 0 "pwd_conf_update without parameters failed"

    # 测试 -d 参数
    pwd_conf_update -d
    CHECK_RESULT $? 1 0 "pwd_conf_update with -d parameter failed"

    # 测试 -h 参数
    pwd_conf_update -h
    CHECK_RESULT $? 1 0 "pwd_conf_update with -h parameter failed"

    # 测试 -d 和 -h 参数组合
    pwd_conf_update -d -h
    CHECK_RESULT $? 1 0 "pwd_conf_update with -d and -h parameters failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "deepin-pw-check"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
