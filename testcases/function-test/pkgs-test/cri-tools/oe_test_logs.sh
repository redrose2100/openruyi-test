
#!/usr/bin/bash
# 测试 crictl logs 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"

    # 引导 CRI 服务（containerd）：cri-tools 只提供客户端，服务端须自行拉起
    cri_ensure_runtime || cri_abort "CRI runtime (containerd) is not available"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一个容器用于测试（输出日志内容供后续 logs 查看）
    cri_run_container test-container busybox:latest /bin/sh -c "echo 'hello from container'; sleep 3600"
    CHECK_RESULT $? 0 0 "Failed to create test container"
    CONTAINER_ID=$(crictl ps -q)
    cri_require_id "$CONTAINER_ID" "Failed to get container ID"
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
    # --follow 会持续跟随容器日志直到容器退出，测试环境中容器保持运行，
    # 使用 timeout 限制跟随时间，timeout 杀进程返回 124 即证明 follow 正常跟随输出
    timeout 10 crictl logs --follow "$CONTAINER_ID"
    CHECK_RESULT $? 124 0 "crictl logs --follow failed"
    
    # 测试 --limit-bytes 参数
    crictl logs --limit-bytes 1024 $CONTAINER_ID
    CHECK_RESULT $? 0 0 "crictl logs --limit-bytes failed"
    
    # 测试 --previous 参数
    # --previous 读取的是上一次实例的日志文件，因此需先重启一次容器产生 previous 日志
    crictl stop --timeout 1 "$CONTAINER_ID" >/dev/null 2>&1
    crictl start "$CONTAINER_ID" >/dev/null 2>&1
    crictl logs --previous "$CONTAINER_ID"
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
    # 运行中的容器需先停止再删除，否则 crictl rm 会被 CRI 拒绝
    crictl stop "$CONTAINER_ID" >/dev/null 2>&1
    crictl rm -f "$CONTAINER_ID" >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
