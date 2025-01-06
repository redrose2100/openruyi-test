
#!/usr/bin/bash
# 请填写测试用例描述：测试 solid-hardware unmount 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-solid"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 获取一个可卸载的设备UDI
    local udi=$(solid-hardware query "isVolume" | head -n 1)
    if [ -z "$udi" ]; then
        LOG_INFO "No mountable device found, skipping test."
        exit 0
    fi
    echo "$udi" > ./test_udi.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    local udi=$(cat ./test_udi.txt)
    solid-hardware unmount "$udi"
    CHECK_RESULT $? 0 0 "Failed to unmount device with UDI: $udi"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "kf5-solid"
    rm -f ./test_udi.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
