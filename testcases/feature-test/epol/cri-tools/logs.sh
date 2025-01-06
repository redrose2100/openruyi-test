
#!/usr/bin/bash
# 测试 crictl logs 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器用于测试
    crictl run --name test-container /path/to/image /path/to/command
    CONTAINER_ID=$(crictl ps -q)
    if [ -z "$CONTAINER_ID" ]; then
        LOG_ERROR "Failed to create container"
        exit 1
    fi
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl logs 命令及其参数
    # 测试默认参数
    crictl logs $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs failed"
    
    # 测试 --follow 参数
    crictl logs --follow $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --follow failed"
    
    # 测试 --limit-bytes 参数
    crictl logs --limit-bytes 1024 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --limit-bytes failed"
    
    # 测试 --previous 参数
    crictl logs --previous $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --previous failed"
    
    # 测试 --since 参数
    crictl logs --since "2023-01-01T00:00:00" $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --since failed"
    
    # 测试 --tail 参数
    crictl logs --tail 10 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --tail failed"
    
    # 测试 --timestamps 参数
    crictl logs --timestamps $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --timestamps failed"
    
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
