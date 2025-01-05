
#!/usr/bin/bash
# 测试 crictl runp 命令，包括不同参数组合和配置文件的使用

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据
    cat <<EOF > ./pod-config.yaml
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-container
    image: busybox
EOF
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl runp 命令的基本使用
    crictl runp ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp failed"

    # 测试 crictl runp 命令的 --cancel-timeout 参数
    crictl runp --cancel-timeout 10s ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp --cancel-timeout failed"

    # 测试 crictl runp 命令的 --runtime 参数
    crictl runp --runtime "runtime-handler" ./pod-config.yaml
    CHECK_RESULT $? 0 0 "crictl runp --runtime failed"

    # 测试 crictl runp 命令的 --help 参数
    crictl runp --help
    CHECK_RESULT $? 0 0 "crictl runp --help failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./pod-config.yaml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
