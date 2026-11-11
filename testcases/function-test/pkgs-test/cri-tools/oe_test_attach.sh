
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl attach 命令的基本功能和参数组合

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
    # 创建一个容器用于测试
    # 注意：crictl attach 要求容器开启 tty，否则 CRI 直接拒绝；
    # 同时 attach 会持续跟随容器 stdio，必须用 timeout 限时，否则用例挂死。
    CRI_CONTAINER_TTY=true cri_run_container test_container busybox:latest /bin/sh -c "sleep 3600"
    CHECK_RESULT $? 0 0 "Failed to create test container"
    CONTAINER_ID=$(crictl ps -q)
    cri_require_id "$CONTAINER_ID" "Failed to get container ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl attach 命令的基本功能
    cri_run_stream 10 crictl attach "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "crictl attach failed"
    
    # 测试 crictl attach 命令的 --stdin 参数
    cri_run_stream 10 crictl attach --stdin "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "crictl attach --stdin failed"
    
    # 测试 crictl attach 命令的 --tty 参数
    cri_run_stream 10 crictl attach --tty "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "crictl attach --tty failed"
    
    # 测试 crictl attach 命令的 --stdin 和 --tty 参数组合
    cri_run_stream 10 crictl attach --stdin --tty "$CONTAINER_ID"
    CHECK_RESULT $? 0 0 "crictl attach --stdin --tty failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 运行中的容器需先停止再删除，清理应先于卸载软件包
    crictl stop "$CONTAINER_ID" >/dev/null 2>&1
    crictl rm -f "$CONTAINER_ID" >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
