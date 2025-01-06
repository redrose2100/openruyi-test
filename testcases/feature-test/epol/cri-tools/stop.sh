
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl stop 命令，验证其停止一个或多个运行中的容器的功能。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个测试容器
    crictl run --net=host --pid=host --no-pull --name test-container --image busybox:latest --image-pull-progress-detail --image-pull-policy=never --runtime=containerd-shim --runtime-endpoint=unix:///run/containerd/containerd.sock --timeout=10s --debug
    CHECK_RESULT $? 0 0 "Failed to create test container"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 获取容器ID
    container_id=$(crictl ps -q)
    CHECK_RESULT $? 0 0 "Failed to get container ID"
    
    # 停止容器
    crictl stop $container_id
    CHECK_RESULT $? 0 0 "Failed to stop container"
    
    # 验证容器是否已停止
    crictl ps --id $container_id
    CHECK_RESULT $? 1 0 "Container is still running after stop command"
    
    # 测试超时参数
    crictl run --net=host --pid=host --no-pull --name test-container2 --image busybox:latest --image-pull-progress-detail --image-pull-policy=never --runtime=containerd-shim --runtime-endpoint=unix:///run/containerd/containerd.sock --timeout=10s --debug
    CHECK_RESULT $? 0 0 "Failed to create second test container"
    container_id2=$(crictl ps -q)
    CHECK_RESULT $? 0 0 "Failed to get second container ID"
    
    crictl stop --timeout 5s $container_id2
    CHECK_RESULT $? 0 0 "Failed to stop container with timeout"
    
    # 验证容器是否已停止
    crictl ps --id $container_id2
    CHECK_RESULT $? 1 0 "Second container is still running after stop command with timeout"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    crictl rm $container_id
    CHECK_RESULT $? 0 0 "Failed to remove container"
    crictl rmi busybox:latest
    CHECK_RESULT $? 0 0 "Failed to remove image"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
