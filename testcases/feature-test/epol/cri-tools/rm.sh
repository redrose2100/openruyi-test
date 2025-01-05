
#!/usr/bin/bash
# 测试 crictl rm 命令，包括基本使用和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一些容器用于测试
    crictl run --net=host --name=test_container1 --image=busybox:latest
    crictl run --net=host --name=test_container2 --image=busybox:latest
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本使用
    crictl rm $(crictl ps -q)
    CHECK_RESULT $? 0 0 "crictl rm basic usage failed"

    # 测试 --all 参数
    crictl run --net=host --name=test_container3 --image=busybox:latest
    crictl rm --all
    CHECK_RESULT $? 0 0 "crictl rm --all failed"

    # 测试 --force 参数
    crictl run --net=host --name=test_container4 --image=busybox:latest
    crictl start $(crictl ps -q)
    crictl rm --force $(crictl ps -q)
    CHECK_RESULT $? 0 0 "crictl rm --force failed"

    # 测试组合参数
    crictl run --net=host --name=test_container5 --image=busybox:latest
    crictl run --net=host --name=test_container6 --image=busybox:latest
    crictl rm --all --force
    CHECK_RESULT $? 0 0 "crictl rm --all --force failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -rf ./test_container*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
