
#!/usr/bin/bash
# 测试用例描述：测试solid-hardware eject命令，确保能够正确弹出指定设备

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-solid"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 获取一个可弹出设备的UDI
    solid-hardware5 list > ./device_list.txt
    CHECK_RESULT $? 0 0 "Failed to list devices"
    UDI=$(grep -m 1 'udi' ./device_list.txt | awk '{print $1}')
    CHECK_RESULT $? 0 0 "Failed to find a device UDI"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    solid-hardware5 eject "$UDI"
    CHECK_RESULT $? 0 0 "Failed to eject device with UDI: $UDI"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "kf5-solid"
    rm -f ./device_list.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
