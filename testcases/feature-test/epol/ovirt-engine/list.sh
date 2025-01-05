
#!/usr/bin/bash
# 请填写测试用例描述：测试 engine-config 命令的 -l 或 --list 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -l 参数
    engine-config -l
    CHECK_RESULT $? 0 0 "engine-config -l failed"

    # 测试 --list 参数
    engine-config --list
    CHECK_RESULT $? 0 0 "engine-config --list failed"

    # 测试 -l 参数加上 --cver 参数
    engine-config -l --cver=general
    CHECK_RESULT $? 0 0 "engine-config -l --cver=general failed"

    # 测试 --list 参数加上 --cver 参数
    engine-config --list --cver=general
    CHECK_RESULT $? 0 0 "engine-config --list --cver=general failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "ovirt-engine"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
