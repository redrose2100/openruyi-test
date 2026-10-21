
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl pull 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个 pod-config.yaml 文件用于测试
    cat > ./pod-config.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-container
    image: nginx:latest
EOF
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl pull 命令的基本功能
    crictl pull nginx:latest
    CHECK_RESULT $? 0 0 "Failed to pull nginx:latest"
    
    # 测试 crictl pull 命令的 --creds 参数
    crictl pull --creds testuser:testpassword nginx:latest
    CHECK_RESULT $? 0 0 "Failed to pull nginx:latest with --creds"
    
    # 测试 crictl pull 命令的 --pod-config 参数
    crictl pull --pod-config ./pod-config.yaml nginx:latest
    CHECK_RESULT $? 0 0 "Failed to pull nginx:latest with --pod-config"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./pod-config.yaml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
