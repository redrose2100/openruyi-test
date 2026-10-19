
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl attach 命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器用于测试
    crictl run --net=host --name=test_container --image=busybox:latest
    CONTAINER_ID=$(crictl ps -q)
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl attach 命令的基本功能
    crictl attach $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl attach failed"
    
    # 测试 crictl attach 命令的 --stdin 参数
    crictl attach --stdin $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl attach --stdin failed"
    
    # 测试 crictl attach 命令的 --tty 参数
    crictl attach --tty $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl attach --tty failed"
    
    # 测试 crictl attach 命令的 --stdin 和 --tty 参数组合
    crictl attach --stdin --tty $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl attach --stdin --tty failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    crictl rm $CONTAINER_ID
    DNF_REMOVE "cri-tools"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
