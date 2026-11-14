
#!/usr/bin/bash
# 测试 crictl stats 命令及其参数

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
    # crictl stats 必须基于真实运行中的容器，否则无数据可展示
    cri_run_container test-container busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test container"
    CONTAINER_ID=$(crictl ps -q)
    cri_require_id "$CONTAINER_ID" "Failed to get container ID"
    POD_ID=$(crictl pods -q | head -1)
    cri_require_id "$POD_ID" "Failed to get pod ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl stats 命令及其参数
    crictl stats
    CHECK_RESULT $? 0 0 "crictl stats failed"

    crictl stats --all
    CHECK_RESULT $? 0 0 "crictl stats --all failed"

    crictl stats --output json
    CHECK_RESULT $? 0 0 "crictl stats --output json failed"

    crictl stats --output yaml
    CHECK_RESULT $? 0 0 "crictl stats --output yaml failed"

    crictl stats --output table
    CHECK_RESULT $? 0 0 "crictl stats --output table failed"

    crictl stats --seconds 2
    CHECK_RESULT $? 0 0 "crictl stats --seconds 2 failed"

    # --watch 会持续刷新输出，必须用 timeout 限时，超时返回 124 即证明 watch 正常
    timeout 10 crictl stats --watch
    CHECK_RESULT $? 124 0 "crictl stats --watch failed"

    # 使用真实存在的容器/Pod ID
    crictl stats --id $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl stats --id $CONTAINER_ID failed"

    crictl stats --pod $POD_ID
    CHECK_RESULT $? 0 0 "crictl stats --pod $POD_ID failed"

    crictl stats --label key=value
    CHECK_RESULT $? 0 0 "crictl stats --label key=value failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 对象，再卸载软件包（否则 crictl 已不存在）
    crictl stop "$CONTAINER_ID" >/dev/null 2>&1
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
