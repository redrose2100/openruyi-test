
#!/usr/bin/bash
# 测试用例描述：测试 obxprop 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "openbox"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 obxprop 命令的基本功能
    obxprop --help
    CHECK_RESULT $? 0 0 "obxprop --help failed"

    # 测试 --display 参数
    obxprop --display :0.0
    CHECK_RESULT $? 0 0 "obxprop --display :0.0 failed"

    # 测试 --id 参数
    obxprop --id 0x123456
    CHECK_RESULT $? 0 0 "obxprop --id 0x123456 failed"

    # 测试 --root 参数
    obxprop --root
    CHECK_RESULT $? 0 0 "obxprop --root failed"

    # 测试多个参数组合
    obxprop --display :0.0 --id 0x123456
    CHECK_RESULT $? 0 0 "obxprop --display :0.0 --id 0x123456 failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "openbox"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
