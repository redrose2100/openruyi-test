
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl stopp 命令，用于停止一个或多个运行中的 pod。

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
    # 创建一个测试 pod（原实现引用的 test-pod-config.yaml 从未生成，必然失败）
    cri_make_pod_config ./test-pod-config.yaml test-pod
    POD_ID=$(crictl runp ./test-pod-config.yaml)
    CHECK_RESULT $? 0 0 "Failed to create test pod"
    cri_require_id "$POD_ID" "Failed to create test pod"
    export POD_ID
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 获取 pod id（直接使用 pre_test 捕获的 ID，不从表格输出里 grep）
    pod_id="$POD_ID"
    cri_require_id "$pod_id" "Failed to get pod id"
    # 停止 pod
    crictl stopp "$pod_id"
    CHECK_RESULT $? 0 0 "Failed to stop pod"
    # 检查 pod 是否已经停止
    # 原实现用 crictl pods | grep -v "test-pod"，取反匹配几乎必然成功，无法验证状态。
    # 正确做法：stopp 后 sandbox 不再是 Ready，故按 state=ready 且指定 id 查询应为空。
    ready_id=$(crictl pods -q --state ready --id "$pod_id")
    [ -z "$ready_id" ]
    CHECK_RESULT $? 0 0 "Pod is still ready after stopp"
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
    rm -f ./test-pod-config.yaml ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
