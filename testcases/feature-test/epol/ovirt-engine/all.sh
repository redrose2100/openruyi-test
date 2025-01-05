
#!/usr/bin/bash
# 测试 engine-config 命令的 -a 或 --all 参数，获取所有可用的配置值

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "ovirt-engine"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    engine-config -a
    CHECK_RESULT $? 0 0 "Failed to get all configuration values with -a option"

    engine-config --all
    CHECK_RESULT $? 0 0 "Failed to get all configuration values with --all option"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "ovirt-engine"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
