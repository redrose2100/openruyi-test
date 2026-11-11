
#!/usr/bin/bash
# 测试 crictl inspect 命令，验证其参数组合和输出格式

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"

    # 引导 CRI 服务（containerd）：cri-tools 只提供客户端，服务端须自行拉起
    cri_ensure_runtime || cri_abort "CRI runtime (containerd) is not available"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器以供测试
    # 注意：容器主命令不能立即退出（如 echo），否则容器会进入 exited 状态，
    # crictl ps -q 仅列运行中的容器，就取不到 ID。因此用 sleep 保持运行。
    cri_run_container test_container busybox:latest /bin/sh -c "echo 'Hello, World!'; sleep 3600"
    CHECK_RESULT $? 0 0 "Failed to create test container"
    # 获取容器ID
    container_id=$(crictl ps -q)
    cri_require_id "$container_id" "Failed to get container ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl inspect 命令的基本用法
    crictl inspect $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with basic usage"
    
    # 测试 crictl inspect 命令的 --output 参数
    crictl inspect --output=json $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=json"
    
    crictl inspect --output=yaml $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=yaml"
    
    crictl inspect --output=go-template --template="{{.metadata.name}}" $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=go-template"
    
    # 测试 crictl inspect 命令的 --quiet 参数
    crictl inspect --quiet $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --quiet"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 运行中的容器需先停止再删除，且清理应先于卸载软件包
    crictl stop "$container_id" >/dev/null 2>&1
    crictl rm -f "$container_id" >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
