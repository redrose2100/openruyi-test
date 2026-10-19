
#!/usr/bin/bash
# 请填写测试用例描述：测试crictl exec命令，包括各种参数组合和命令执行

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器用于测试
    crictl run --net=host --rm --name test-container --image busybox:latest
    CONTAINER_ID=$(crictl ps -q)
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试crictl exec命令的基本用法
    crictl exec $CONTAINER_ID echo "Hello, World!"
    CHECK_RESULT $? 0 0 "crictl exec basic usage failed"

    # 测试--interactive参数
    crictl exec --interactive $CONTAINER_ID echo "Interactive mode"
    CHECK_RESULT $? 0 0 "crictl exec --interactive failed"

    # 测试--sync参数
    crictl exec --sync $CONTAINER_ID echo "Synchronous mode"
    CHECK_RESULT $? 0 0 "crictl exec --sync failed"

    # 测试--timeout参数
    crictl exec --timeout 5 $CONTAINER_ID sleep 2
    CHECK_RESULT $? 0 0 "crictl exec --timeout failed"

    # 测试--tty参数
    crictl exec --tty $CONTAINER_ID echo "TTY mode"
    CHECK_RESULT $? 0 0 "crictl exec --tty failed"

    # 测试多个参数组合
    crictl exec --interactive --sync --timeout 5 --tty $CONTAINER_ID echo "Combined options"
    CHECK_RESULT $? 0 0 "crictl exec combined options failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    crictl rm $CONTAINER_ID
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
