
#!/usr/bin/bash
# 请填写测试用例描述：测试 nmstatectl edit 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "nmstate"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 nmstatectl edit 命令的基本用法
    nmstatectl edit
    CHECK_RESULT $? 0 0 "nmstatectl edit failed"

    # 测试 nmstatectl edit 命令的 --json 参数
    nmstatectl edit --json
    CHECK_RESULT $? 0 0 "nmstatectl edit --json failed"

    # 测试 nmstatectl edit 命令的 --no-verify 参数
    nmstatectl edit --no-verify
    CHECK_RESULT $? 0 0 "nmstatectl edit --no-verify failed"

    # 测试 nmstatectl edit 命令的 --memory-only 参数
    nmstatectl edit --memory-only
    CHECK_RESULT $? 0 0 "nmstatectl edit --memory-only failed"

    # 测试 nmstatectl edit 命令的 interfaces 参数
    nmstatectl edit eth0
    CHECK_RESULT $? 0 0 "nmstatectl edit eth0 failed"

    # 测试 nmstatectl edit 命令的多个参数组合
    nmstatectl edit --json --no-verify --memory-only eth0
    CHECK_RESULT $? 0 0 "nmstatectl edit --json --no-verify --memory-only eth0 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "nmstate"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
