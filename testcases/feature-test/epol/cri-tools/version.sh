
#!/usr/bin/bash
# 测试 crictl version 命令的基本功能和参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 创建一个配置文件以避免默认端点问题
    echo "runtime-endpoint: unix:///run/containerd/containerd.sock" > ./crictl.yaml
    export CRI_CONFIG_FILE="./crictl.yaml"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl version 命令的基本功能
    crictl version
    CHECK_RESULT $? 0 0 "crictl version command failed"

    # 测试 crictl version 命令的 --help 参数
    crictl version --help
    CHECK_RESULT $? 0 0 "crictl version --help command failed"

    # 测试 crictl version 命令的 -h 参数
    crictl version -h
    CHECK_RESULT $? 0 0 "crictl version -h command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./crictl.yaml
    unset CRI_CONFIG_FILE
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
