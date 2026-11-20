
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl pull 命令的基本功能和参数组合

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
    # 创建一个 pod-config 文件用于测试（crictl pull --pod-config 需要 CRI 的 PodSandboxConfig）
    cri_make_pod_config ./pod-config.yaml test-pod
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl pull 命令的基本功能
    crictl pull busybox:latest
    CHECK_RESULT $? 0 0 "Failed to pull busybox:latest"
    
    # 测试 crictl pull 命令的 --creds 参数
    # 注意：Docker Hub 公共镜像用错误凭据拉取必然返回鉴权错误，
    # 故此用例只校验 --creds 被命令行正确识别（不是 unknown flag），
    # 而不是断言拉取成功。
    pull_creds_output=$(crictl pull --creds testuser:testpassword busybox:latest 2>&1)
    echo "$pull_creds_output" | grep -qi "unknown flag"
    CHECK_RESULT $? 1 0 "crictl pull did not recognise the --creds flag"
    
    # 测试 crictl pull 命令的 --pod-config 参数
    crictl pull --pod-config ./pod-config.yaml busybox:latest
    CHECK_RESULT $? 0 0 "Failed to pull busybox:latest with --pod-config"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 镜像，再卸载软件包（否则 crictl 已不存在）
    crictl rmi busybox:latest >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./pod-config.yaml ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
