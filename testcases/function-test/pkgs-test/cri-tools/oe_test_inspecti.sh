
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl inspecti 命令，包括不同输出格式和多个镜像ID的情况

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
    # 测试默认输出
    crictl inspecti $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with default output"
    
    # 测试json输出
    crictl inspecti --output json $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with json output"
    
    # 测试yaml输出
    crictl inspecti --output yaml $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with yaml output"
    
    # 测试go-template输出
    crictl inspecti --output go-template --template="{{.id}}" $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with go-template output"
    
    # 测试多个镜像ID
    crictl inspecti $IMAGE_ID $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with multiple image IDs"
    
    # 测试quiet模式
    crictl inspecti --quiet $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with quiet mode"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 必须先做 CRI 清理再卸载 cri-tools，否则 crictl 二进制已不存在，清理会 command not found
    crictl rmi "$IMAGE_ID" >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
