
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl create 命令，包括各种参数组合和参数顺序

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
    cat <<EOF > ./container-config.json
{
  "metadata": {
    "name": "test-container"
  },
  "image": {
    "image": "busybox:latest"
  },
  "command": [
    "/bin/sh"
  ]
}
EOF

    cat <<EOF > ./pod-config.json
{
  "metadata": {
    "name": "test-pod"
  }
}
EOF
    # 先拉取镜像到本地，使 create 不会因为需要鉴权拉取而失败
    crictl pull busybox:latest
    CHECK_RESULT $? 0 0 "Failed to pull busybox:latest"
    # crictl create 的第一个参数是 pod ID（不是 pod 名称），
    # 因此必须先创建 sandbox 并拿到真实 ID
    POD_ID=$(crictl runp ./pod-config.json)
    CHECK_RESULT $? 0 0 "Failed to create test pod"
    cri_require_id "$POD_ID" "Failed to create test pod"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl create 命令的基本用法
    crictl create "$POD_ID" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create basic usage failed"

    # 测试 --auth 参数
    crictl create --auth "dXNlcm5hbWU6cGFzc3dvcmQ=" "$POD_ID" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --auth failed"

    # 测试 --cancel-timeout 参数
    crictl create --cancel-timeout 10s "$POD_ID" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --cancel-timeout failed"

    # 测试 --creds 参数
    # 注意：镜像已在本地，create 不会真正拉取，此处只校验参数被命令行识别
    create_creds_output=$(crictl create --creds "username:password" "$POD_ID" ./container-config.json ./pod-config.json 2>&1)
    echo "$create_creds_output" | grep -qi "unknown flag"
    CHECK_RESULT $? 1 0 "crictl create did not recognise the --creds flag"

    # 测试 --no-pull 参数
    crictl create --no-pull "$POD_ID" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --no-pull failed"

    # 测试 --with-pull 参数
    crictl create --with-pull "$POD_ID" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --with-pull failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 对象，再卸载软件包（否则 crictl 已不存在）
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
