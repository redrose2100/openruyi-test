
#!/usr/bin/bash
# 测试 crictl inspect 命令，验证其参数组合和输出格式

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器以供测试
    crictl run --runtime=runq --image=busybox --image-pull-policy=never --name=test_container --no-pull --command=/bin/sh --args="-c echo 'Hello, World!'" --log-level=debug
    CHECK_RESULT $? 0 0 "Failed to create test container"
    # 获取容器ID
    container_id=$(crictl ps -q)
    CHECK_RESULT $? 0 0 "Failed to get container ID"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl inspect 命令的基本用法
    crictl inspect $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with basic usage"
    
    # 测试 crictl inspect 命令的 --output 参数
    crictl inspect --output=json $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=json"
    
    crictl inspect --output=yaml $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=yaml"
    
    crictl inspect --output=go-template --template="{{.metadata.name}}" $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --output=go-template"
    
    # 测试 crictl inspect 命令的 --quiet 参数
    crictl inspect --quiet $container_id
    CHECK_RESULT $? 0 0 "Failed to inspect container with --quiet"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    crictl rm $container_id
    CHECK_RESULT $? 0 0 "Failed to remove test container"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
