
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl rmi 命令，包括基本用法和参数组合

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
    # 拉取一个测试镜像（固定 tag，避免 depends on 默认 tag 解析）
    crictl pull busybox:latest
    CHECK_RESULT $? 0 0 "Failed to pull busybox:latest"
    # 获取镜像ID
    IMAGE_ID=$(crictl images -q busybox:latest)
    cri_require_id "$IMAGE_ID" "Failed to get image ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本用法
    crictl rmi "$IMAGE_ID"
    CHECK_RESULT $? 0 0 "Failed to remove image with ID $IMAGE_ID"
    
    # 测试 --all 参数
    crictl pull busybox:latest
    crictl rmi --all
    CHECK_RESULT $? 0 0 "Failed to remove all images with --all flag"
    
    # 测试 --prune 参数
    crictl pull busybox:latest
    crictl rmi --prune
    CHECK_RESULT $? 0 0 "Failed to remove unused images with --prune flag"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 镜像，再卸载软件包（否则 crictl 已不存在）
    crictl rmi --all >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -rf ./test_files
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
