
#!/usr/bin/bash
# 测试 crictl rm 命令，包括基本使用和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一些容器用于测试
    cri_run_container test_container1 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container1"
    cri_run_container test_container2 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container2"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本使用
    # crictl rm 只能删除已停止的容器，先停止再删除
    crictl stop $(crictl ps -q)
    CHECK_RESULT $? 0 0 "Failed to stop containers"
    crictl rm $(crictl ps -q)
    CHECK_RESULT $? 0 0 "crictl rm basic usage failed"

    # 测试 --all 参数
    cri_run_container test_container3 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container3"
    crictl stop $(crictl ps -q)
    CHECK_RESULT $? 0 0 "Failed to stop container for --all test"
    crictl rm --all
    CHECK_RESULT $? 0 0 "crictl rm --all failed"

    # 测试 --force 参数
    cri_run_container test_container4 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container4"
    crictl start $(crictl ps -q)
    crictl rm --force $(crictl ps -q)
    CHECK_RESULT $? 0 0 "crictl rm --force failed"

    # 测试组合参数
    cri_run_container test_container5 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container5"
    cri_run_container test_container6 busybox:latest
    CHECK_RESULT $? 0 0 "Failed to create test_container6"
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
