
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl pods 命令的各种参数组合

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
    # 创建一个真实 sandbox，使 --id/--name/--namespace 等过滤参数能验证到实数据
    cri_make_pod_config ./pod-config.json pods-test-pod
    POD_ID=$(crictl runp ./pod-config.json)
    CHECK_RESULT $? 0 0 "Failed to create test pod"
    cri_require_id "$POD_ID" "Failed to create test pod"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl pods 命令的各种参数组合
    crictl pods
    CHECK_RESULT $? 0 0 "crictl pods failed"

    crictl pods --id "$POD_ID"
    CHECK_RESULT $? 0 0 "crictl pods --id failed"

    crictl pods --label "key=value"
    CHECK_RESULT $? 0 0 "crictl pods --label failed"

    crictl pods --last 5
    CHECK_RESULT $? 0 0 "crictl pods --last failed"

    crictl pods --latest
    CHECK_RESULT $? 0 0 "crictl pods --latest failed"

    crictl pods --name "pods-test-pod"
    CHECK_RESULT $? 0 0 "crictl pods --name failed"

    crictl pods --namespace "default"
    CHECK_RESULT $? 0 0 "crictl pods --namespace failed"

    crictl pods --no-trunc
    CHECK_RESULT $? 0 0 "crictl pods --no-trunc failed"

    crictl pods --output json
    CHECK_RESULT $? 0 0 "crictl pods --output json failed"

    crictl pods --output yaml
    CHECK_RESULT $? 0 0 "crictl pods --output yaml failed"

    crictl pods --output table
    CHECK_RESULT $? 0 0 "crictl pods --output table failed"

    crictl pods --quiet
    CHECK_RESULT $? 0 0 "crictl pods --quiet failed"

    # pod sandbox 的状态只有 ready/notready（容器才是 running/exited），
    # 原实现传 "running" 会被 crictl 判为非法取值
    crictl pods --state "ready"
    CHECK_RESULT $? 0 0 "crictl pods --state failed"

    crictl pods --verbose
    CHECK_RESULT $? 0 0 "crictl pods --verbose failed"

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
    rm -f ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
