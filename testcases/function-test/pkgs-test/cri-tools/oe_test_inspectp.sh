
#!/usr/bin/bash
# 测试 crictl inspectp 命令，验证其参数组合和输出格式

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
    # 创建一个测试pod（原实现引用的 test-pod-config.yaml 从未生成，必然失败）
    cri_make_pod_config ./test-pod-config.yaml test-pod
    pod_id=$(crictl runp ./test-pod-config.yaml)
    CHECK_RESULT $? 0 0 "Failed to create test pod"
    cri_require_id "$pod_id" "Failed to create test pod"
    export POD_ID="$pod_id"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # pod ID 已在 pre_test 中捕获（原实现用正则从表格里抓，脆弱且依赖输出格式）
    pod_id="$POD_ID"
    cri_require_id "$pod_id" "Failed to get pod ID"

    # 测试默认输出
    crictl inspectp $pod_id
    CHECK_RESULT $? 0 0 "Failed to inspect pod with default output"

    # 测试json输出
    crictl inspectp --output json $pod_id
    CHECK_RESULT $? 0 0 "Failed to inspect pod with json output"

    # 测试yaml输出
    crictl inspectp --output yaml $pod_id
    CHECK_RESULT $? 0 0 "Failed to inspect pod with yaml output"

    # 测试go-template输出
    crictl inspectp --output go-template --template="{{.id}}" $pod_id
    CHECK_RESULT $? 0 0 "Failed to inspect pod with go-template output"

    # 测试quiet模式
    crictl inspectp --quiet $pod_id
    CHECK_RESULT $? 0 0 "Failed to inspect pod in quiet mode"

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
