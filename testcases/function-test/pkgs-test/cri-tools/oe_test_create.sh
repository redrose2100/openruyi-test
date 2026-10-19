
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl create 命令，包括各种参数组合和参数顺序

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
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl create 命令的基本用法
    crictl create test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create basic usage failed"

    # 测试 --auth 参数
    crictl create --auth "dXNlcm5hbWU6cGFzc3dvcmQ=" test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --auth failed"

    # 测试 --cancel-timeout 参数
    crictl create --cancel-timeout 10s test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --cancel-timeout failed"

    # 测试 --creds 参数
    crictl create --creds "username:password" test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --creds failed"

    # 测试 --no-pull 参数
    crictl create --no-pull test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --no-pull failed"

    # 测试 --with-pull 参数
    crictl create --with-pull test-pod ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl create with --with-pull failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
