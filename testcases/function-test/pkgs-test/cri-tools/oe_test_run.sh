
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl run 命令，验证其参数组合和行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    cat <<EOF > ./container-config.json
{
  "metadata": {
    "name": "test-container"
  },
  "image": {
    "image": "busybox"
  },
  "command": [
    "echo",
    "hello"
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
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    crictl run --timeout 10s --runtime "runc" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run command failed"
    crictl run --no-pull ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --no-pull command failed"
    crictl run --with-pull ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --with-pull command failed"
    crictl run --auth "dXNlcm5hbWU6cGFzc3dvcmQ=" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --auth command failed"
    crictl run --creds "username:password" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --creds command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "cri-tools"
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
