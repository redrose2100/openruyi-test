
#!/usr/bin/bash
# 测试 crictl port-forward 命令，包括基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个测试用的 pod
    crictl runp ./test-pod.yaml
    # 获取 pod 的 ID
    pod_id=$(crictl pods | grep "test-pod" | awk '{print $1}')
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl port-forward 命令的基本功能
    crictl port-forward "$pod_id" 8080:80
    CHECK_RESULT $? 0 0 "crictl port-forward command failed"

    # 测试 crictl port-forward 命令的参数组合
    crictl port-forward "$pod_id" 8081:8080
    CHECK_RESULT $? 0 0 "crictl port-forward command with different ports failed"

    # 测试 crictl port-forward 命令的帮助信息
    crictl port-forward --help
    CHECK_RESULT $? 0 0 "crictl port-forward --help command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./test-pod.yaml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
