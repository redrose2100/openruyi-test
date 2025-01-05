
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl rmi 命令，包括基本用法和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 拉取一个测试镜像
    crictl pull busybox
    # 获取镜像ID
    IMAGE_ID=$(crictl images | grep busybox | awk '{print $3}')
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本用法
    crictl rmi $IMAGE_ID
    CHECK_RESULT $? 0 0 "Failed to remove image with ID $IMAGE_ID"
    
    # 测试 --all 参数
    crictl pull busybox
    IMAGE_ID=$(crictl images | grep busybox | awk '{print $3}')
    crictl rmi --all
    CHECK_RESULT $? 0 0 "Failed to remove all images with --all flag"
    
    # 测试 --prune 参数
    crictl pull busybox
    crictl rmi --prune
    CHECK_RESULT $? 0 0 "Failed to remove unused images with --prune flag"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -rf ./test_files
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
