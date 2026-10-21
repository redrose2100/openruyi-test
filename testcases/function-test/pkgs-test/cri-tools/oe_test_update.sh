
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl update 命令，更新一个或多个正在运行的容器的资源限制

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个测试容器
    crictl run --name test-container --image busybox
    # 获取容器ID
    CONTAINER_ID=$(crictl ps -q)
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 测试 --cpu-share 参数
    crictl update --cpu-share 512 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with --cpu-share parameter"

    # 测试 --cpu-period 参数
    crictl update --cpu-period 100000 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with --cpu-period parameter"

    # 测试 --cpu-quota 参数
    crictl update --cpu-quota 50000 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with --cpu-quota parameter"

    # 测试 --cpuset-cpus 参数
    crictl update --cpuset-cpus 0 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with --cpuset-cpus parameter"

    # 测试 --memory 参数
    crictl update --memory 1048576 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with --memory parameter"

    # 测试多个参数组合
    crictl update --cpu-share 512 --cpu-period 100000 --cpu-quota 50000 --cpuset-cpus 0 --memory 1048576 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "Failed to update container with multiple parameters"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        DNF_REMOVE "cri-tools"
        # 清理测试中间产物文件
        crictl rm $CONTAINER_ID
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
