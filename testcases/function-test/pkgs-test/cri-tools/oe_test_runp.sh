
#!/usr/bin/bash
# 测试 crictl runp 命令，包括不同参数组合和配置文件的使用

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
    # 准备测试数据
    # 注意：crictl runp 需要的是 CRI 的 PodSandboxConfig，不是 Kubernetes 的 "kind: Pod"，
    # 后者字段不匹配会被服务端拒绝。故统一由 cri_lib 生成合法配置。
    cri_make_pod_config ./pod-config.yaml test-pod
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl runp 命令的基本使用
    crictl runp ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp failed"
    # 同名 sandbox 不允许重复创建，后续参数测试前先清理
    crictl rmp -f $(crictl pods -q) >/dev/null 2>&1

    # 测试 crictl runp 命令的 --cancel-timeout 参数
    crictl runp --cancel-timeout 10s ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp --cancel-timeout failed"
    crictl rmp -f $(crictl pods -q) >/dev/null 2>&1

    # 测试 crictl runp 命令的 --runtime 参数（必须是真实存在的 runtime handler，默认 runc）
    crictl runp --runtime "runc" ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp --runtime failed"

    # 测试 crictl runp 命令的 --help 参数
    crictl runp --help
    CHECK_RESULT $? 0 0 "crictl runp --help failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 对象，再卸载软件包（否则 crictl 已不存在）
    crictl rmp -f --all >/dev/null 2>&1
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./pod-config.yaml ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
