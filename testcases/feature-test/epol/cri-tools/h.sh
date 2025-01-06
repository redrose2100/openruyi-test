
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl h 命令，显示命令列表或帮助信息

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl h 命令的基本用法
    crictl h
    CHECK_RESULT $? 0 0 "crictl h command failed"

    # 测试 crictl h 命令加上 --help 选项
    crictl h --help
    CHECK_RESULT $? 0 0 "crictl h --help command failed"

    # 测试 crictl h 命令加上 -h 选项
    crictl h -h
    CHECK_RESULT $? 0 0 "crictl h -h command failed"

    # 测试 crictl h 命令加上具体的命令参数
    crictl h version
    CHECK_RESULT $? 0 0 "crictl h version command failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
