
#!/usr/bin/bash
# 测试 crictl port-forward 命令，包括基本功能和参数组合

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
    # 创建一个测试用的 pod（原实现引用的 test-pod.yaml 从未生成，必然失败）
    cri_make_pod_config ./test-pod.yaml test-pod
    pod_id=$(crictl runp ./test-pod.yaml)
    CHECK_RESULT $? 0 0 "Failed to create test pod"
    cri_require_id "$pod_id" "Failed to create test pod"
    export POD_ID="$pod_id"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    pod_id="$POD_ID"
    cri_require_id "$pod_id" "Failed to get pod ID"
    # 测试 crictl port-forward 命令的帮助信息（纯本地参数解析，不依赖网络转发）
    crictl port-forward --help
    CHECK_RESULT $? 0 0 "crictl port-forward --help command failed"
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
    rm -f ./test-pod.yaml ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
