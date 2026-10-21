
#!/usr/bin/bash
# 请填写测试用例描述：测试solid-hardware5 details命令，验证其输出设备详细信息的功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-solid"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 获取一个有效的UDI作为测试数据
    udi=$(solid-hardware5 list | head -n 1)
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 测试details命令，使用获取到的UDI
    solid-hardware5 details "$udi"
    CHECK_RESULT $? 0 0 "solid-hardware5 details command failed"
    # 测试details命令，使用无效的UDI
    invalid_udi="invalid_udi"
    solid-hardware5 details "$invalid_udi"
    CHECK_RESULT $? 1 0 "solid-hardware5 details command with invalid UDI should fail"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "kf5-solid"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
