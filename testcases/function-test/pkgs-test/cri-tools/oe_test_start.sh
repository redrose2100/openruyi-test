
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl start 命令，启动一个或多个已创建的容器

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
    # 创建一个已创建但未启动（created）的容器，供 start 测试
    cri_create_container test_container busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create container"
    # 获取容器ID
    container_id=$(crictl ps -aq | head -1)
    cri_require_id "$container_id" "Failed to get container ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 启动容器
    crictl start "$container_id"
    CHECK_RESULT $? 0 0 "Failed to start container"
    # 检查容器状态
    # 注意：crictl ps 默认输出截断的短 ID，grep 完整 ID 必然匹配不到，
    # 因此改用 -q --id 精确查询运行中的容器
    running_id=$(crictl ps -q --id "$container_id")
    [ -n "$running_id" ]
    CHECK_RESULT $? 0 0 "Container not running after start"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 必须先做 CRI 清理再卸载 cri-tools，否则 crictl 二进制已不存在，清理会 command not found
    crictl stop "$container_id" >/dev/null 2>&1
    crictl rm -f "$container_id" >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
